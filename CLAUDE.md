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

Key architectural decisions:
- Uses Nix flakes for reproducibility
- Configured for macOS on Apple Silicon (aarch64-darwin)
- Allows unfree packages for proprietary software
- Prepared for nix-darwin integration (currently inactive)
- Modular configuration structure via imports

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