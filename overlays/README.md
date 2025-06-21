# Home Manager Overlays

This directory contains custom Nix overlays for packages that need special handling or newer versions than what's available in nixpkgs.

## Claude Code

Claude Code is now managed via an external flake: `github:sadjow/claude-code-nix`

The package provides:
- ✅ **Always available**: System-wide availability regardless of project Node.js version
- ✅ **Latest version**: Direct from npm registry with automated updates
- ✅ **No conflicts**: Bundled Node.js v20 runtime
- ✅ **Reproducible**: Declarative installation with binary cache

### Usage

```bash
claude --version  # Shows current version
claude --help     # Show available commands
```

### Binary Cache

Pre-built binaries are available from:
- **Cache URL**: https://claude-code.cachix.org
- **Public Key**: `claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4Du12kVeWEE4fsRk=`

For more details, see: https://github.com/sadjow/claude-code-nix