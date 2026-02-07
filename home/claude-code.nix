{ config, pkgs, lib, ... }:

{
  # Create stable claude binary paths to prevent permission resets
  home.activation.claudeStableLink = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Create .local/bin directory if it doesn't exist
    mkdir -p $HOME/.local/bin

    # Remove old symlinks if they exist
    rm -f $HOME/.local/bin/claude
    rm -f $HOME/.local/bin/claude-bun

    # Create wrapper script that enables skip-permissions as a selectable mode
    printf '#!/usr/bin/env bash\nexec %s --allow-dangerously-skip-permissions "$@"\n' \
      "${pkgs.claude-code}/bin/claude" > $HOME/.local/bin/claude
    chmod +x $HOME/.local/bin/claude
    ln -s ${pkgs.claude-code-bun}/bin/claude-bun $HOME/.local/bin/claude-bun

    # Ensure .claude directory permissions are preserved
    if [ -d "$HOME/.claude" ]; then
      chmod -R 700 "$HOME/.claude"
    fi

    # Create .claude directory if it doesn't exist
    mkdir -p $HOME/.claude
  '';

  # Add .local/bin to PATH if not already there
  home.sessionPath = [ "$HOME/.local/bin" ];
  
  # Preserve claude configuration during switches
  home.activation.preserveClaudeConfig = lib.hm.dag.entryBefore ["writeBoundary"] ''
    # Backup claude config if it exists
    if [ -f "$HOME/.claude.json" ]; then
      cp -p "$HOME/.claude.json" "$HOME/.claude.json.backup" 2>/dev/null || true
    fi
  '';
  
  home.activation.restoreClaudeConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Restore claude config if backup exists and original is missing
    if [ -f "$HOME/.claude.json.backup" ] && [ ! -f "$HOME/.claude.json" ]; then
      cp -p "$HOME/.claude.json.backup" "$HOME/.claude.json"
    fi
  '';
}