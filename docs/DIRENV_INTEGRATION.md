# Global Direnv Integration

This configuration includes comprehensive direnv support that works across all terminals and editors, including VSCode and Cursor.

## Features

- **Multi-shell Support**: Configured for both zsh and bash shells
- **Login Shell Integration**: Works in login shells spawned by editors like VSCode/Cursor
- **Global PATH**: Ensures direnv is always available in PATH for all applications
- **Automatic Hook Loading**: Direnv hooks are loaded automatically regardless of shell initialization method

## Implementation Details

The global direnv setup is configured in `home/shell.nix` with:

1. **Profile-level hooks**: Added to `.zprofile` and `.bash_profile` for login shells
2. **Interactive shell hooks**: Built-in home-manager integration for zsh/bash
3. **Session PATH**: Ensures direnv binary is always available via `home.sessionPath`
4. **Redundant loading protection**: Prevents duplicate hook initialization

## Verification

Test direnv functionality in different shell contexts:

```bash
# Test in zsh login shell
zsh -l -c 'command -v _direnv_hook && echo "✓ direnv loaded"'

# Test in bash login shell
bash -l -c 'command -v _direnv_hook && echo "✓ direnv loaded"'

# Test direnv binary availability
direnv --version
```

## Editor Integration

When editors like VSCode, Cursor, or others spawn terminal sessions, they automatically have access to direnv-managed environments. No additional setup is required.
