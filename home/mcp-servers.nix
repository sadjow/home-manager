{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    _1password-cli
    nodejs  # Node.js LTS for running MCP servers
  ];

  # Generate Claude Desktop MCP configuration with secrets from 1Password
  # This runs during home-manager activation with biometric authentication
  home.activation.generateMcpConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Retrieving MCP credentials from 1Password (biometric auth required)..."

    # Enable biometric unlock for this session
    export OP_BIOMETRIC_UNLOCK_ENABLED=true

    # Retrieve CircleCI token
    CIRCLECI_TOKEN=$(${pkgs._1password-cli}/bin/op read "op://MCPs/circleci-mcp/api-token" --account my.1password.com 2>/dev/null || echo "")

    # Retrieve Datadog credentials
    DD_API_KEY=$(${pkgs._1password-cli}/bin/op read "op://MCPs/datadog-mcp/api-key" --account my.1password.com 2>/dev/null || echo "")
    DD_APP_KEY=$(${pkgs._1password-cli}/bin/op read "op://MCPs/datadog-mcp/app-key" --account my.1password.com 2>/dev/null || echo "")

    # Check if we got all credentials
    if [ -z "$CIRCLECI_TOKEN" ] || [ -z "$DD_API_KEY" ] || [ -z "$DD_APP_KEY" ]; then
      echo "Warning: Some MCP credentials could not be retrieved from 1Password"
      echo "Make sure 1Password desktop app is running and you approve biometric auth"
      echo "You can re-run 'home-manager switch' to try again"
    else
      echo "✓ Successfully retrieved all MCP credentials"
    fi

    # Create the Claude Desktop config directory if it doesn't exist
    CONFIG_DIR="$HOME/Library/Application Support/Claude"
    mkdir -p "$CONFIG_DIR"

    # Remove any existing symlink or backup
    CONFIG_FILE="$CONFIG_DIR/claude_desktop_config.json"
    if [ -L "$CONFIG_FILE" ]; then
      rm -f "$CONFIG_FILE"
    fi

    # Generate the config file with actual credentials
    cat > "$CONFIG_FILE" << EOF
    {
      "mcpServers": {
        "circleci-mcp-server": {
          "command": "${pkgs.nodejs}/bin/npx",
          "args": ["-y", "@circleci/mcp-server-circleci@latest"],
          "env": {
            "CIRCLECI_TOKEN": "$CIRCLECI_TOKEN",
            "CIRCLECI_BASE_URL": "https://circleci.com",
            "PATH": "${pkgs.nodejs}/bin:/usr/bin:/bin"
          }
        },
        "datadog": {
          "command": "${pkgs.nodejs}/bin/node",
          "args": ["${config.home.homeDirectory}/opensource/datadog-mcp/build/index.js"],
          "env": {
            "DD_API_KEY": "$DD_API_KEY",
            "DD_APP_KEY": "$DD_APP_KEY",
            "DD_SITE": "datadoghq.com"
          }
        }
      }
    }
    EOF

    echo "Claude Desktop MCP configuration updated"
  '';
}