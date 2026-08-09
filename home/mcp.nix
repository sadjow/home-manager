{ lib, ... }:

let
  secretFile = "$HOME/.config/spireworks-mcp.env";
  loadSecrets = ''
    if [ -f "${secretFile}" ]; then
      . "${secretFile}"
    fi
  '';
in
{
  home.activation.ensureSpireworksMcpSecretFile = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    secret_file="${secretFile}"

    if [ ! -f "$secret_file" ]; then
      install -d -m 700 "$(dirname "$secret_file")"
      printf '%s\n' \
        'export SPIREWORKS_STAGING_ADMIN_MCP_TOKEN=' \
        'export SPIREWORKS_STAGING_MEMBER_MCP_TOKEN=' \
        'export SPIREWORKS_DEV_ADMIN_MCP_TOKEN=' \
        > "$secret_file"
      chmod 600 "$secret_file"
    fi
  '';

  home.activation.exportSpireworksMcpSecrets = lib.hm.dag.entryAfter [ "ensureSpireworksMcpSecretFile" ] ''
    secret_file="${secretFile}"

    if [ -f "$secret_file" ]; then
      SPIREWORKS_STAGING_ADMIN_MCP_TOKEN=""
      SPIREWORKS_STAGING_MEMBER_MCP_TOKEN=""
      SPIREWORKS_DEV_ADMIN_MCP_TOKEN=""
      . "$secret_file"

      /bin/launchctl setenv SPIREWORKS_STAGING_ADMIN_MCP_TOKEN "$SPIREWORKS_STAGING_ADMIN_MCP_TOKEN" || true
      /bin/launchctl setenv SPIREWORKS_STAGING_MEMBER_MCP_TOKEN "$SPIREWORKS_STAGING_MEMBER_MCP_TOKEN" || true
      /bin/launchctl setenv SPIREWORKS_DEV_ADMIN_MCP_TOKEN "$SPIREWORKS_DEV_ADMIN_MCP_TOKEN" || true
    fi
  '';

  programs.zsh.initContent = loadSecrets;
  programs.bash.bashrcExtra = loadSecrets;
}
