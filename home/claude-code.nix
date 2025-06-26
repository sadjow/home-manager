{ config, pkgs, lib, ... }:

{
  # Create a stable claude binary path to prevent permission resets
  home.activation.claudeStableLink = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Create .local/bin directory if it doesn't exist
    mkdir -p $HOME/.local/bin
    
    # Remove old symlink if it exists
    rm -f $HOME/.local/bin/claude
    
    # Create stable symlink to current claude binary
    ln -s ${pkgs.claude-code}/bin/claude $HOME/.local/bin/claude
    
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