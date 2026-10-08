import argparse
import json
import os
from pathlib import Path
import subprocess
import sys


def run(codex, *arguments):
    result = subprocess.run([codex, *arguments], capture_output=True, text=True)
    if result.returncode:
        raise RuntimeError(f'Codex {" ".join(arguments)} failed; inspect daemon status before retrying.')
    return result.stdout


def inspect(codex, home):
    versions = json.loads(run(codex, 'app-server', 'daemon', 'version'))
    features = {}
    for line in run(codex, 'features', 'list').splitlines():
        fields = line.split()
        if len(fields) >= 3 and fields[-1] in ('true', 'false'):
            features[fields[0]] = fields[-1] == 'true'
    if not features:
        raise ValueError('Could not read CLI feature settings.')
    path = home / 'app-server-daemon/settings.json'
    settings = json.loads(path.read_text()) if path.exists() else {}
    if not isinstance(settings, dict) or not isinstance(versions, dict):
        raise ValueError('Invalid daemon settings or version response.')
    overrides = settings.get('featureOverrides', {})
    if not isinstance(overrides, dict) or any(type(v) is not bool for v in overrides.values()):
        raise ValueError('Invalid daemon feature overrides.')
    if any(key not in features for key in overrides):
        raise ValueError('Daemon has feature overrides unknown to this CLI; reconcile versions first.')
    drift = {key: (value, features[key]) for key, value in overrides.items() if value != features[key]}
    return versions, drift


def reconcile(codex, home, restart=False):
    versions, drift = inspect(codex, home)
    cli = versions.get('cliVersion')
    server = versions.get('appServerVersion') or versions.get('managedCodexVersion')
    print(f'CLI version: {cli}; daemon version: {server}')
    for key, (saved, desired) in drift.items():
        print(f'{key}: saved={str(saved).lower()}, CLI={str(desired).lower()}')
    if not restart:
        print('Saved overrides differ.' if drift else 'No conflicting saved feature overrides found.')
        print('This checks saved settings, not the running handshake. Start codex to verify compatibility.')
        return 1 if drift else 0
    print('Restarting the shared daemon; active or queued work may be interrupted.', flush=True)
    # Plain restart preserves stale featureOverrides in Codex 0.161.0.
    run(codex, 'app-server', 'daemon', 'stop')
    run(codex, 'app-server', 'daemon', 'start')
    versions, drift = inspect(codex, home)
    if versions.get('status') != 'running' or drift:
        raise RuntimeError('Daemon reconciliation did not complete; inspect status before retrying.')
    print('Daemon is running with no conflicting saved overrides. Start codex to verify compatibility.')
    return 0


def main():
    parser = argparse.ArgumentParser(description='Check saved Codex daemon feature overrides against the installed CLI.')
    parser.add_argument('--codex', default='codex', help=argparse.SUPPRESS)
    parser.add_argument('--restart', action='store_true', help='Reset saved feature overrides through a fresh daemon start; interrupts shared work.')
    args = parser.parse_args()
    home = Path(os.environ.get('CODEX_HOME') or Path.home() / '.codex')
    try:
        return reconcile(args.codex, home, args.restart)
    except (OSError, ValueError, RuntimeError) as error:
        print(f'Could not reconcile daemon: {error if isinstance(error, RuntimeError) else type(error).__name__}', file=sys.stderr)
        return 1


if __name__ == '__main__':
    sys.exit(main())
