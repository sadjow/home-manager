{ pkgs, lib, ... }:

{
  # Home Manager owns authored Claude inputs. Claude keeps mutable runtime state.
  home.file = {
    ".claude/CLAUDE.md" = {
      source = ./claude/CLAUDE.md;
      force = true;
    };
    ".claude/agents" = {
      source = ./claude/agents;
      recursive = true;
      force = true;
    };
    ".claude/commands" = {
      source = ./claude/commands;
      recursive = true;
      force = true;
    };
    ".claude/hooks" = {
      source = ./claude/hooks;
      recursive = true;
      force = true;
    };
  };

  home.activation.claudeWritableSettings = lib.hm.dag.entryAfter ["linkGeneration"] (
    lib.concatMapStringsSep "\n" (name: ''
      run ${pkgs.python3}/bin/python3 ${../scripts/reconcile-claude-settings.py} \
        ${./claude + "/${name}"} \
        "$HOME/.claude/${name}" \
        "$HOME/.claude/.home-manager-settings/${name}"
    '') [ "settings.json" "settings.local.json" ]
  );

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

    # Avoid following managed skill symlinks into their source directories
    if [ -d "$HOME/.claude" ]; then
      find "$HOME/.claude" -type d -exec chmod 700 {} +
      find "$HOME/.claude" -type f -exec chmod 600 {} +
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
