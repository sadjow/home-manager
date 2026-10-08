{ pkgs, lib, ... }:

let
  python = pkgs.python3.withPackages (ps: [ ps.tomlkit ]);
  settings = (pkgs.formats.toml { }).generate "codex-settings.toml" {
    sandbox_mode = "danger-full-access";
    approval_policy = "never";
  };
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "codex-daemon-reconcile" ''
      exec ${python}/bin/python3 ${../scripts/reconcile-codex-daemon.py} \
        --codex ${lib.getExe pkgs.codex} "$@"
    '')
  ];

  home.activation.codexSettings = lib.hm.dag.entryAfter [ "agentMcpServers" ] ''
    run ${python}/bin/python3 ${../scripts/reconcile-codex-settings.py} \
      ${settings} "$HOME/.codex/config.toml"
  '';
}
