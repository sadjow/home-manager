import os
from pathlib import Path
import sys
import tempfile

import tomlkit


def write_private(path, text):
    descriptor, temporary = tempfile.mkstemp(dir=path.parent, prefix=f'.{path.name}.')
    try:
        with os.fdopen(descriptor, 'w') as output:
            output.write(text)
        os.replace(temporary, path)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


def activate(source, target):
    desired = tomlkit.parse(source.read_text())
    original = target.read_text() if target.exists() else ''
    current = tomlkit.parse(original)
    if 'sandbox_mode' in desired:
        # Codex rejects combining the legacy sandbox setting with a named profile.
        current.pop('default_permissions', None)
    current.update(desired)
    updated = tomlkit.dumps(current)
    target.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
    if target.is_symlink() or not target.exists() or updated != original:
        if target.exists():
            write_private(target.with_name(target.name + '.home-manager-backup'), original)
        write_private(target, updated)
    else:
        target.chmod(0o600)


if __name__ == '__main__':
    try:
        activate(*(Path(argument) for argument in sys.argv[1:]))
    except (OSError, ValueError) as error:
        sys.exit(f'Could not reconcile Codex settings ({type(error).__name__}).')
