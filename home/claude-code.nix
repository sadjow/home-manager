{ pkgs, lib, ... }:

let
  # Editor extensions launch their bundled Claude binary, so the wrapper's flag never reaches them.
  claudeExtensionEditors = [ "Code" "Cursor" "Windsurf" ];
  jsoncParser = pkgs.callPackage ../pkgs/jsonc-parser.nix { };
  profiles = import ./claude/profiles.nix;
  configDirectories = [ profiles.default ] ++ lib.attrValues profiles.isolated;
  authoredFiles = directory: {
    "${directory}/CLAUDE.md" = {
      source = ./claude/CLAUDE.md;
      force = true;
    };
    "${directory}/agents" = {
      source = ./claude/agents;
      recursive = true;
      force = true;
    };
    "${directory}/commands" = {
      source = ./claude/commands;
      recursive = true;
      force = true;
    };
    "${directory}/hooks" = {
      source = ./claude/hooks;
      recursive = true;
      force = true;
    };
  };
in
{
  # Home Manager owns authored Claude inputs. Claude keeps mutable runtime state.
  home.file = lib.mergeAttrsList (map authoredFiles configDirectories);

  # The stable wrapper keeps the bypass option, and the config directory keeps
  # authentication, including its macOS Keychain entry, separate per profile.
  home.packages = lib.mapAttrsToList
    (command: directory: pkgs.writeShellScriptBin command ''
      export CLAUDE_CONFIG_DIR="$HOME/${directory}"
      exec "$HOME/.local/bin/claude" "$@"
    '')
    profiles.isolated;

  home.activation.claudeWritableSettings = lib.hm.dag.entryAfter ["linkGeneration"] (
    lib.concatMapStringsSep "\n" ({ directory, name }: ''
      run ${pkgs.python3}/bin/python3 ${../scripts/reconcile-json-settings.py} \
        ${./claude + "/${name}"} \
        "$HOME/${directory}/${name}" \
        "$HOME/${directory}/.home-manager-settings/${name}"
    '') (lib.cartesianProduct {
      directory = configDirectories;
      name = [ "settings.json" "settings.local.json" ];
    })
  );

  home.activation.claudeEditorBypassPermissions = lib.hm.dag.entryAfter ["writeBoundary"] (
    lib.concatMapStringsSep "\n" (editor: ''
      run env JSONC_PARSER=${jsoncParser} ${pkgs.nodejs}/bin/node ${../scripts/set-jsonc-setting.js} \
        "$HOME/Library/Application Support/${editor}/User/settings.json" \
        claudeCode.allowDangerouslySkipPermissions true
    '') claudeExtensionEditors
  );

  # Create stable claude binary paths to prevent permission resets
  home.activation.claudeStableLink = lib.hm.dag.entryAfter ["linkGeneration"] ''
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
    for directory in ${lib.escapeShellArgs configDirectories}; do
      if [ -d "$HOME/$directory" ]; then
        find "$HOME/$directory" -type d -exec chmod 700 {} +
        find "$HOME/$directory" -type f -exec chmod 600 {} +
      fi
    done

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
