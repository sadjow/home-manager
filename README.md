# Home Manager Configuration

Personal Nix home-manager configuration for macOS (Apple Silicon) that manages user environment, packages, and dotfiles using Nix flakes.

## Features

- 🏠 **Declarative Environment**: Complete user environment managed through Nix
- 📦 **Package Management**: Reproducible package installation across machines
- 🔧 **Development Tools**: Comprehensive development environment setup
- 🚀 **Flake-based**: Modern Nix flakes for better reproducibility
- 🍎 **macOS Optimized**: Specifically configured for Apple Silicon Macs
- 💾 **Binary Caches**: Fast package installation with pre-built binaries
- ⚙️ **Global Direnv**: Universal direnv integration across all terminals and editors

## Quick Start

### Prerequisites

1. **Install Nix** (if not already installed):

   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. **Install Home Manager**:

   ```bash
   nix run home-manager/master -- init --switch
   ```

### Installation

1. **Clone this repository**:

   ```bash
   git clone https://github.com/sadjow/home-manager ~/.config/home-manager
   cd ~/.config/home-manager
   ```

2. **Apply the configuration**:

   ```bash
   home-manager switch --flake .
   ```

## Configuration Structure

```text
├── flake.nix              # Flake definition with inputs and outputs
├── flake.lock             # Locked dependency versions
├── darwin-configuration.nix # nix-darwin system config (hostname, etc.)
├── home.nix               # Main home-manager configuration
├── home/
│   ├── AGENTS.md          # Shared global agent instructions
│   ├── claude/            # Authored Claude Code configuration
│   ├── nix/
│   │   ├── caches.nix     # Binary cache URLs and public keys
│   │   └── default.nix    # User Nix settings
│   ├── claude-code.nix    # Claude Code integration
│   └── shell.nix          # Shell configuration (zsh/bash with global direnv)
├── docs/
│   ├── AGENT_HARNESS_SKILL_LINEAGE.md # Personal and project skill feedback loop
│   └── CHANNEL_STRATEGY.md             # Nixpkgs channel strategy and alternatives
├── overlays/
│   └── README.md          # Information about custom overlays
├── CLAUDE.md              # AI assistant guidance
└── README.md              # This file
```

## Included Packages

### Development Tools

- **Languages**: Ruby, Dart, Node.js (via asdf)
- **Editors**: Neovim
- **Version Control**: Git, GitHub CLI
- **Build Tools**: CocoaPods, FFmpeg
- **Shell**: tmux, direnv, ripgrep, bat

### Utilities

- **Security**: AWS Vault, GPG
- **Network**: nmap
- **AI Tools**: Claude Code (via external flake)
- **Package Management**: Cachix, asdf-vm

### External Flakes

- **devenv**: Fast, declarative development environments
- **claude-code**: AI coding assistant with dedicated Node.js runtime

## Binary Caches

Cache URLs and public signing keys are defined once in [`home/nix/caches.nix`](home/nix/caches.nix). Home Manager uses this catalog to generate the user Nix configuration. It takes effect after activation, including for subsequent builds of this configuration.

After `home-manager switch`, Nix automatically checks these caches for matching packages across projects. Public caches do not require a Cachix token or a separate `cachix use` command. New caches must be registered in the catalog; Nix does not discover a cache from a package name.

Flake-provided configuration is also accepted automatically through the existing `nix.settings.accept-flake-config = true` setting. A cached build must match the exact package derivation and platform; changing inputs can require a local build.

The former Garnix cache is excluded because its hosted service [shut down on July 15, 2026](https://garnix.io/blog/shutting-down/).

Verification:

```bash
# Show only the effective cache URLs and public signing keys
nix config show --json | jq '{substituters: .substituters.value, "trusted-public-keys": ."trusted-public-keys".value}'
```

## Development Environment Integration

### Global Direnv Support

This configuration provides comprehensive direnv integration that works seamlessly across all terminals and editors:

#### Features
- **Universal Support**: Works in VSCode, Cursor, and any terminal application
- **Multi-shell**: Supports both zsh and bash shells
- **Login Shell Compatibility**: Properly configured for login shells spawned by editors
- **Auto-loading**: Direnv hooks are loaded automatically without manual setup

#### How it Works
The global direnv integration is implemented through:

1. **Profile-level hooks**: Added to `.zprofile` and `.bash_profile` for login shells
2. **Interactive shell integration**: Built-in home-manager direnv support
3. **Global PATH configuration**: Ensures direnv is available system-wide
4. **Redundant loading protection**: Prevents duplicate initialization

#### Verification
```bash
# Test direnv in different shell contexts
zsh -l -c 'command -v _direnv_hook && echo "✓ direnv loaded in zsh"'
bash -l -c 'command -v _direnv_hook && echo "✓ direnv loaded in bash"'
direnv --version  # Should show installed version
```

This means when you open a project with a `.envrc` file in any editor, the environment will be automatically activated in all terminal sessions without additional configuration.

## Common Commands

### Configuration Management

```bash
# Apply home-manager configuration
home-manager switch --flake .

# Apply nix-darwin system configuration
sudo darwin-rebuild switch --flake .#codecraft

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

## Customization

### Adding Packages

Edit `home.nix` and add packages to the `home.packages` list:

```nix
home.packages = [
  pkgs.your-package
  # ... other packages
];
```

### Modifying Configuration

The configuration is modular. Key files to modify:

- **`home.nix`**: Main package list and basic settings
- **`home/AGENTS.md`**: Shared global instructions for supported coding agents
- **`home/claude/`**: Authored Claude Code settings, agents, commands, hooks, and local skills
- **`home/claude-code.nix`**: Claude Code file ownership and runtime-state boundary
- **`home/nix/default.nix`**: User Nix settings
- **`home/nix/caches.nix`**: Binary cache URLs and public signing keys
- **`home/shell.nix`**: Shell configuration and direnv integration
- **`flake.nix`**: Add new input flakes or change system configurations

### Adding Binary Caches

Add the cache URL and its complete public signing key to the `caches` attribute set in `home/nix/caches.nix`:

```nix
"https://your-cache.cachix.org" = "your-cache.cachix.org-1:your-public-key=";
```

Apply with `home-manager switch --flake .#sadjow`. If the change includes a new untracked file, use `home-manager switch --flake 'path:.#sadjow'` so Nix includes it.

## Architecture

### Key Design Decisions

- **Flake-based**: Uses Nix flakes for improved reproducibility and dependency management
- **Modular**: Configuration split into logical modules for easier maintenance
- **macOS Optimized**: Specifically configured for Apple Silicon (aarch64-darwin)
- **External Dependencies**: Important tools like Claude Code managed as separate flakes
- **Binary Caching**: Multiple cache sources for fast package installation
- **Agent Harness Skill Lineage**: Keeps portable personal capabilities while deriving independent project-owned copies or adaptations (see [Agent Harness Skill Lineage](docs/AGENT_HARNESS_SKILL_LINEAGE.md))
- **Channel Strategy**: Uses nixpkgs-unstable for latest packages (see [Channel Strategy Documentation](docs/CHANNEL_STRATEGY.md))

### System Compatibility

- **Platform**: macOS (Apple Silicon / aarch64-darwin)
- **Nix Version**: Compatible with Nix 2.19+
- **Home Manager**: Uses latest stable release

## Troubleshooting

### Common Issues

1. **Flake evaluation errors**:

   ```bash
   nix flake check --show-trace
   ```

2. **Binary cache issues**:

   ```bash
   nix store ping --store https://cache-url.org
   ```

3. **Home Manager conflicts**:

   ```bash
   home-manager switch --flake . --show-trace
   ```

### Getting Help

- Check the [Home Manager manual](https://nix-community.github.io/home-manager/)
- Review the [Nix flakes documentation](https://nixos.wiki/wiki/Flakes)
- See `CLAUDE.md` for AI assistant specific guidance

## Related Projects

- **[claude-code-nix](https://github.com/sadjow/claude-code-nix)**: Dedicated Nix package for Claude Code
- **[devenv](https://devenv.sh/)**: Fast, declarative development environments

## License

This configuration is provided as-is for personal use. Feel free to adapt it for your own needs.

---

**Note**: This configuration is personalized for user "sadjow". You'll need to update usernames, paths, and personal preferences when adapting it for your own use.
