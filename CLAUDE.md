# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Nix home-manager configuration repository for macOS (Apple Silicon) that manages user environment, packages, and dotfiles using Nix flakes.

## Common Commands

### Configuration Management
```bash
# Apply configuration changes
home-manager switch --flake .

# Build configuration without switching
home-manager build --flake .

# Preview changes (dry run)
home-manager switch --flake . -n

# Update flake dependencies
nix flake update

# Check configuration validity
nix flake check
```

### Development Commands
```bash
# Show flake outputs
nix flake show

# Update specific input
nix flake lock --update-input <input-name>

# Run garbage collection
nix-collect-garbage -d
```

## Architecture

The codebase follows a modular flake-based structure:

- **`flake.nix`**: Entry point defining inputs (nixpkgs, home-manager, darwin, devenv, claude-code) and outputs for aarch64-darwin
- **`home.nix`**: Main home-manager configuration importing modular configs and defining packages
- **`home/nix/default.nix`**: Nix-specific settings including binary caches and authentication
- **`home/shell.nix`**: Shell configuration (zsh with asdf-vm integration) and global direnv setup
- **`home/mcp-servers.nix`**: MCP servers configuration with 1Password integration

Key architectural decisions:
- Uses Nix flakes for reproducibility
- Configured for macOS on Apple Silicon (aarch64-darwin)
- Allows unfree packages for proprietary software
- Prepared for nix-darwin integration (currently inactive)
- Modular configuration structure via imports
- **Channel Strategy**: Uses nixpkgs-unstable with home-manager/master for latest packages on development machine (see `docs/CHANNEL_STRATEGY.md` for alternatives)

## Important Notes

- The repository is a git repo with the main branch as default
- User-specific configuration is for user "sadjow" with home directory `/Users/sadjow`
- Binary caches configured: nixos.org, devenv.cachix.org, nix-community.cachix.org, claude-code.cachix.org
- Home-manager manages its own version (self-managed)

## Claude Code Integration

This repository includes a special module (`home/claude-code.nix`) that:

1. Creates a stable symlink at `~/.local/bin/claude` to prevent permission resets
2. Preserves `.claude.json` and `.claude/` directory during home-manager switches
3. Ensures claude settings persist across nix updates

### Known Issues Fixed

- **Permission Reset Issue**: Claude was asking for directory permissions after every `home-manager switch` because the nix store path changed. This is now fixed by using a stable symlink.
- **Settings Loss**: Login state and trusted directories are now preserved.

## Global Direnv Integration

This configuration includes comprehensive direnv support that works across all terminals and editors, including VSCode and Cursor.

### Features

- **Multi-shell Support**: Configured for both zsh and bash shells
- **Login Shell Integration**: Works in login shells spawned by editors like VSCode/Cursor
- **Global PATH**: Ensures direnv is always available in PATH for all applications
- **Automatic Hook Loading**: Direnv hooks are loaded automatically regardless of shell initialization method

### Implementation Details

The global direnv setup is configured in `home/shell.nix` with:

1. **Profile-level hooks**: Added to `.zprofile` and `.bash_profile` for login shells
2. **Interactive shell hooks**: Built-in home-manager integration for zsh/bash
3. **Session PATH**: Ensures direnv binary is always available via `home.sessionPath`
4. **Redundant loading protection**: Prevents duplicate hook initialization

### Verification

Test direnv functionality in different shell contexts:

```bash
# Test in zsh login shell
zsh -l -c 'command -v _direnv_hook && echo "✓ direnv loaded"'

# Test in bash login shell
bash -l -c 'command -v _direnv_hook && echo "✓ direnv loaded"'

# Test direnv binary availability
direnv --version
```

### Editor Integration

This configuration ensures that when editors like VSCode, Cursor, or others spawn terminal sessions, they will automatically have access to direnv-managed environments. No additional setup is required.