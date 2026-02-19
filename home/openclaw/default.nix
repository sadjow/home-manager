{ config, pkgs, lib, ... }:

let
  stateDir = "${config.home.homeDirectory}/.openclaw";
  secretsDir = "${config.home.homeDirectory}/.secrets";
in
{
  home.activation.openclawSecrets = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
    echo "Retrieving OpenClaw secrets from 1Password..."
    export OP_BIOMETRIC_UNLOCK_ENABLED=true

    mkdir -p "${secretsDir}"
    chmod 700 "${secretsDir}"

    TELEGRAM_TOKEN=$(${pkgs._1password-cli}/bin/op read "op://MCPs/openclaw-telegram/bot-token" --account my.1password.com 2>/dev/null || echo "")
    GATEWAY_TOKEN=$(${pkgs._1password-cli}/bin/op read "op://MCPs/openclaw-gateway/token" --account my.1password.com 2>/dev/null || echo "")

    if [ -z "$TELEGRAM_TOKEN" ] || [ -z "$GATEWAY_TOKEN" ]; then
      echo "Warning: Could not retrieve OpenClaw secrets from 1Password"
      echo "Make sure 1Password desktop app is running and approve biometric auth"
    else
      echo -n "$TELEGRAM_TOKEN" > "${secretsDir}/openclaw-telegram-token"
      chmod 600 "${secretsDir}/openclaw-telegram-token"
      echo -n "$GATEWAY_TOKEN" > "${secretsDir}/openclaw-gateway-token"
      chmod 600 "${secretsDir}/openclaw-gateway-token"
      echo "✓ OpenClaw secrets retrieved and stored"
    fi
  '';

  home.activation.openclawPatchConfig = lib.hm.dag.entryAfter [ "openclawConfigFiles" ] ''
    export OP_BIOMETRIC_UNLOCK_ENABLED=true
    CONFIG_FILE="${stateDir}/openclaw.json"

    if [ -f "${secretsDir}/openclaw-gateway-token" ]; then
      GATEWAY_TOKEN=$(${pkgs.coreutils}/bin/cat "${secretsDir}/openclaw-gateway-token")
      if [ -L "$CONFIG_FILE" ]; then
        REAL_CONTENT=$(${pkgs.coreutils}/bin/cat "$CONFIG_FILE")
        ${pkgs.coreutils}/bin/rm -f "$CONFIG_FILE"
        echo "$REAL_CONTENT" | ${pkgs.jq}/bin/jq --arg token "$GATEWAY_TOKEN" '.gateway.auth.token = $token' > "$CONFIG_FILE"
        echo "✓ OpenClaw config patched with gateway token"
      fi
    fi
  '';

  programs.openclaw = {
    enable = true;
    package = pkgs.openclaw-gateway;
    documents = ./documents;

    instances.default = {
      enable = true;
      plugins = [];
      config = {
        gateway = {
          mode = "local";
          auth.token = "PLACEHOLDER_REPLACED_AT_ACTIVATION";
        };

        channels.telegram = {
          tokenFile = "${secretsDir}/openclaw-telegram-token";
          allowFrom = [ 1210886270 ];
          groups."*".requireMention = true;
        };
      };
    };
  };
}
