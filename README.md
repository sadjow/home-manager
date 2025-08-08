# Home Manager Configuration

Personal Nix home-manager configuration for macOS (Apple Silicon) that manages user environment, packages, and dotfiles using Nix flakes.

## Features

- 🏠 **Declarative Environment**: Complete user environment managed through Nix
- 📦 **Package Management**: Reproducible package installation across machines
- 🔧 **Development Tools**: Comprehensive development environment setup
- 🚀 **Flake-based**: Modern Nix flakes for better reproducibility
- 🍎 **macOS Optimized**: Specifically configured for Apple Silicon Macs
- 💾 **Binary Caches**: Fast package installation with pre-built binaries

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
├── home.nix               # Main home-manager configuration
├── home/
│   └── nix/
│       └── default.nix    # Nix-specific settings and binary caches
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

This configuration uses several binary caches for faster package installation:

- **cache.nixos.org**: Official Nix cache
- **devenv.cachix.org**: Devenv package cache  
- **nix-community.cachix.org**: Community packages
- **claude-code.cachix.org**: Custom Claude Code builds

### Flake-level cache configuration (for fast devenv updates)

To ensure flake operations (including `devenv` updates) use the right caches without rebuilding locally, caches are declared at the flake level and accepted non-interactively:

- Flake-level caches are set in `flake.nix` via `nixConfig.extra-substituters` and `nixConfig.extra-trusted-public-keys`.
- Non-interactive acceptance is enabled in `home/nix/default.nix` via:
  - `nix.settings.experimental-features = [ "nix-command" "flakes" ];`
  - `nix.settings.accept-flake-config = true;`

Verification:

```bash
# Show effective daemon config (should list cachix and devenv caches)
nix config show | grep -E 'substituters|trusted.*keys'

# Run flake commands without prompts
nix --accept-flake-config flake check
```

Troubleshooting:

- If prompts still appear, pass `--accept-flake-config` on the command, or ensure Home Manager has applied the config:

```bash
home-manager switch --flake .
```

- If packages still rebuild, the exact inputs may not be present in caches for your platform; otherwise, caching is correctly configured.

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
- **`home/nix/default.nix`**: Nix daemon settings and binary caches
- **`flake.nix`**: Add new input flakes or change system configurations

### Adding Binary Caches

To add a new binary cache, edit `home/nix/default.nix`:

```nix
caches = {
  "cache.nixos.org" = "6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
  "your-cache.cachix.org" = "your-public-key=";
  # ... other caches
};
```

## Architecture

### Key Design Decisions

- **Flake-based**: Uses Nix flakes for improved reproducibility and dependency management
- **Modular**: Configuration split into logical modules for easier maintenance
- **macOS Optimized**: Specifically configured for Apple Silicon (aarch64-darwin)
- **External Dependencies**: Important tools like Claude Code managed as separate flakes
- **Binary Caching**: Multiple cache sources for fast package installation

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
