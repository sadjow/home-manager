# nixpkgs-unstable still predates NixOS/nixpkgs#574509, which stops atuin's e2e
# tests from sourcing the host /etc/bashrc in unsandboxed darwin builds and
# running the installed atuin instead of the one under test. Remove once the
# locked nixpkgs includes that pull request.
final: prev: {
  atuin = prev.atuin.overrideAttrs (oldAttrs: {
    env = (oldAttrs.env or { }) // {
      ATUIN_E2E_BASH = prev.lib.getExe (
        prev.writeShellScriptBin "bash" ''
          NOSYSBASHRC=1 exec ${prev.lib.getExe prev.bashInteractive} "$@"
        ''
      );
    };
  });
}
