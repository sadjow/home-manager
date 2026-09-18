import json
import os
from pathlib import Path
import sys
import tempfile


MISSING = object()


def reconcile(previous, desired, current):
    if previous == desired:
        return current
    if isinstance(desired, dict) and (isinstance(current, dict) or current is MISSING):
        previous = previous if isinstance(previous, dict) else {}
        current = current if isinstance(current, dict) else {}
        result = {}
        for key in previous.keys() | desired.keys() | current.keys():
            value = reconcile(previous.get(key, MISSING), desired.get(key, MISSING),
                              current.get(key, MISSING))
            if value is not MISSING:
                result[key] = value
        return result
    return desired


def read_settings(path):
    if not path.exists():
        return {}
    value = json.loads(path.read_text())
    if not isinstance(value, dict):
        raise ValueError(f'{path.name} must contain a JSON object')
    return value


def write_private(path, value):
    descriptor, temporary = tempfile.mkstemp(dir=path.parent, prefix=f'.{path.name}.')
    try:
        with os.fdopen(descriptor, 'w') as output:
            json.dump(value, output, indent=2, sort_keys=True)
            output.write('\n')
        os.replace(temporary, path)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


def activate(source, target, baseline):
    desired = read_settings(source)
    previous = read_settings(baseline) if target.exists() else {}
    current = read_settings(target)
    merged = reconcile(previous, desired, current)
    target.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
    baseline.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
    if target.is_symlink() or not target.exists() or merged != current:
        if target.exists():
            write_private(target.with_name(target.name + '.home-manager-backup'), current)
        write_private(target, merged)
    else:
        target.chmod(0o600)
    write_private(baseline, desired)


if __name__ == '__main__':
    try:
        activate(*(Path(argument) for argument in sys.argv[1:]))
    except (OSError, ValueError) as error:
        sys.exit(f'Could not reconcile Claude settings: {error}')
