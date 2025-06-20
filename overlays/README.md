# Home Manager Overlays

This directory contains custom Nix overlays for packages that need special handling or newer versions than what's available in nixpkgs.

## Claude Code Overlay

### The Problem

When working with multiple projects that use different Node.js environments, Claude Code installed via npm can become unavailable or incompatible:

1. **Project-specific Node.js versions**: When using tools like `asdf` or `devenv` with older Node.js versions, Claude Code might not be compatible
2. **Isolated environments**: In `devenv` shells or Nix shells, globally installed npm packages are not accessible
3. **Version conflicts**: Different projects might require different Node.js versions, but Claude Code needs a recent version to run

### The Solution

By installing Claude Code through Nix with its own bundled Node.js runtime, we ensure:

- ✅ **Always available**: Claude Code is available system-wide, regardless of the current project's Node.js version
- ✅ **Latest version**: We can install the latest version (1.0.30) instead of waiting for nixpkgs updates
- ✅ **No conflicts**: Uses its own Node.js v20 runtime, independent of project requirements
- ✅ **Reproducible**: Installation is declarative and reproducible across machines

### How It Works

The `claude-code.nix` overlay:

1. Downloads Claude Code directly from npm registry
2. Installs it with its own Node.js v20 runtime
3. Creates a wrapper script that ensures it runs from the correct directory
4. Handles the `yoga.wasm` file dependency by running the CLI from its installation directory

### Usage

Claude Code is automatically available after running `home-manager switch`:

```bash
claude --version  # Should show 1.0.30 (Claude Code)
claude --help     # Show available commands
```

### Updating

To update Claude Code to a newer version:

1. Edit `overlays/claude-code.nix`
2. Change the `version` variable to the desired version
3. Run `home-manager switch --flake .`

### Technical Details

The overlay works around several challenges:

- **SSL Certificates**: Uses Nix's `cacert` package to handle npm's SSL requirements
- **Shebang Issues**: Replaces the env-based shebang with a direct Node.js path
- **Module Resolution**: Runs the CLI from its installation directory to find relative dependencies
- **Path Independence**: The wrapper ensures Claude Code works regardless of the current working directory