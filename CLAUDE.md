# CLAUDE.md

Guidance for Claude Code when working in this repository.

## Overview

Nix flake home-manager configuration for macOS on Apple Silicon (aarch64-darwin), with nix-darwin for system-level settings. User `sadjow`, home directory `/Users/sadjow`. Uses nixpkgs-unstable with home-manager/master (alternatives in `docs/CHANNEL_STRATEGY.md`), allows unfree packages, and home-manager manages its own version.

## Commands

```bash
home-manager switch --flake .                    # apply user configuration
home-manager switch --flake . -n                 # dry run
home-manager build --flake .                     # build without switching
sudo darwin-rebuild switch --flake .#codecraft   # apply nix-darwin system configuration
nix flake check                                  # validate
nix flake update                                 # update all inputs
nix flake lock --update-input <input-name>       # update one input
nix flake show                                   # list outputs
nix-collect-garbage -d                           # garbage collection
```

## Layout

- `flake.nix`: inputs (nixpkgs, home-manager, darwin, devenv, claude-code) and aarch64-darwin outputs
- `darwin-configuration.nix`: nix-darwin system configuration (hostname, system-level settings)
- `home.nix`: main home-manager configuration importing the modules below and defining packages
- `home/nix/default.nix`: user Nix settings and authentication
- `home/nix/caches.nix`: binary cache catalog applied through Home Manager for all projects
- `home/shell.nix`: zsh with asdf-vm and global direnv hooks for login and interactive shells (`docs/DIRENV_INTEGRATION.md`)
- `home/claude-code.nix` and `home/claude/`: authored Claude Code configuration (`docs/CLAUDE_CODE_INTEGRATION.md`, ownership boundary in `home/claude/README.md`)

## Rules

- Define cache URLs and complete public signing keys only in `home/nix/caches.nix` and apply them through Home Manager instead of running `cachix use`. Keep them out of `flake.nix`, whose `nixConfig` requires literal values.
- Keep the stable `~/.local/bin/claude` symlink and the `~/.claude.json` preservation in `home/claude-code.nix`; they prevent permission and login resets after a switch.
