{ pkgs, lib, ... }:

let
  remoteMcpServers = import ./remote-mcp-servers.nix;
  claudeProfiles = import ./claude/profiles.nix;
  # The default profile keeps its state beside its directory, isolated ones inside theirs.
  claudeStateFiles = [ ".claude.json" ]
    ++ map (directory: "${directory}/.claude.json") (lib.attrValues claudeProfiles.isolated);
  reconcileAgentMcpServers = pkgs.writeShellApplication {
    name = "reconcile-agent-mcp-servers";
    runtimeInputs = [
      pkgs.codex
      pkgs.coreutils
      pkgs.gnugrep
      pkgs.jq
    ];
    text = builtins.readFile ../scripts/reconcile-agent-mcp-servers;
  };
in
{
  home.activation.agentMcpServers = lib.hm.dag.entryAfter
    [ "restoreClaudeConfig" "restoreCursorConfig" ]
    (lib.concatStringsSep "\n" (lib.mapAttrsToList
      (name: url: ''
        ${lib.getExe reconcileAgentMcpServers} \
          ${lib.escapeShellArg name} \
          ${lib.escapeShellArg url} \
          ${lib.escapeShellArgs claudeStateFiles}
      '')
      remoteMcpServers));
}
