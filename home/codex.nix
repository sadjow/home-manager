{ pkgs, lib, ... }:

let
  python = pkgs.python3.withPackages (ps: [ ps.tomlkit ]);
  profiles = import ./codex/profiles.nix;
  settings = (pkgs.formats.toml { }).generate "codex-settings.toml" {
    sandbox_mode = "danger-full-access";
    approval_policy = "never";
  };
  isolatedProfile = command: directory: pkgs.writeShellScriptBin command ''
    codex_home="$HOME/${directory}"
    ${pkgs.coreutils}/bin/install -d -m 700 "$codex_home"

    export CODEX_HOME="$codex_home"

    exec ${lib.getExe pkgs.codex} \
      -c 'cli_auth_credentials_store="file"' \
      -c 'mcp_oauth_credentials_store="file"' \
      "$@"
  '';
in
{
  home.packages = [
    pkgs.codex
    (pkgs.writeShellScriptBin "codex-daemon-reconcile" ''
      exec ${python}/bin/python3 ${../scripts/reconcile-codex-daemon.py} \
        --codex ${lib.getExe pkgs.codex} "$@"
    '')
  ] ++ lib.mapAttrsToList isolatedProfile profiles.isolated;

  home.activation.codexSettings = lib.hm.dag.entryAfter [ "agentMcpServers" ] ''
    run ${python}/bin/python3 ${../scripts/reconcile-codex-settings.py} \
      ${settings} "$HOME/${profiles.default}/config.toml"
  '';
}
