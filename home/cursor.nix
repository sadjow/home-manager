{ config, pkgs, lib, ... }:

{
  # Manage Cursor commands directory with declarative command files
  home.file = {
    # Clean Code Principles documentation
    ".cursor/commands/clean-code.md" = {
      source = ./cursor/commands/clean-code.md;
      force = true;
    };

    # GitHub PR Review Commands documentation
    ".cursor/commands/github-pr-review.md" = {
      source = ./cursor/commands/github-pr-review.md;
      force = true;
    };
  };

  # Preserve Cursor configuration during switches
  home.activation.preserveCursorConfig = lib.hm.dag.entryBefore ["writeBoundary"] ''
    # Ensure .cursor directory exists
    mkdir -p $HOME/.cursor

    # Backup important Cursor configs if they exist
    for file in argv.json cli-config.json ide_state.json; do
      if [ -f "$HOME/.cursor/$file" ]; then
        cp -p "$HOME/.cursor/$file" "$HOME/.cursor/$file.backup" 2>/dev/null || true
      fi
    done
  '';

  home.activation.restoreCursorConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Restore Cursor configs if backups exist and originals are missing
    for file in argv.json cli-config.json ide_state.json; do
      if [ -f "$HOME/.cursor/$file.backup" ] && [ ! -f "$HOME/.cursor/$file" ]; then
        cp -p "$HOME/.cursor/$file.backup" "$HOME/.cursor/$file"
      fi
    done

    # Ensure proper permissions for Cursor directory
    if [ -d "$HOME/.cursor" ]; then
      # Set restrictive permissions for sensitive files
      [ -f "$HOME/.cursor/mcp.json" ] && chmod 600 "$HOME/.cursor/mcp.json"
      [ -f "$HOME/.cursor/cli-config.json" ] && chmod 600 "$HOME/.cursor/cli-config.json"

      # Ensure commands directory has proper permissions
      [ -d "$HOME/.cursor/commands" ] && chmod 755 "$HOME/.cursor/commands"
      [ -d "$HOME/.cursor/commands" ] && chmod 644 "$HOME/.cursor/commands"/*.md 2>/dev/null || true
    fi

    # Clean up old MCP backups (keep only last 5)
    if [ -d "$HOME/.cursor" ]; then
      ls -t "$HOME/.cursor"/mcp.json.backup.* 2>/dev/null | tail -n +6 | xargs rm -f 2>/dev/null || true
    fi
  '';
}
