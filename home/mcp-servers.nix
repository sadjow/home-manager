{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    _1password-cli
    nodejs  # Node.js LTS for running MCP servers
  ];

  # Generate MCP configuration for all applications with secrets from 1Password
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
    CLAUDE_CONFIG_DIR="$HOME/Library/Application Support/Claude"
    mkdir -p "$CLAUDE_CONFIG_DIR"

    # Remove any existing symlink or backup
    CLAUDE_CONFIG_FILE="$CLAUDE_CONFIG_DIR/claude_desktop_config.json"
    if [ -L "$CLAUDE_CONFIG_FILE" ]; then
      rm -f "$CLAUDE_CONFIG_FILE"
    fi

    # Generate the Claude Desktop config file with actual credentials
    cat > "$CLAUDE_CONFIG_FILE" << EOF
    {
      "mcpServers": {
        "playwright": {
          "command": "${pkgs.nodejs}/bin/npx",
          "args": ["@playwright/mcp@latest"],
          "env": {
            "PATH": "${pkgs.nodejs}/bin:/usr/bin:/bin"
          }
        },
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

    echo "✓ Claude Desktop MCP configuration updated"

    # Create the Cursor config directory if it doesn't exist
    CURSOR_CONFIG_DIR="$HOME/.cursor"
    mkdir -p "$CURSOR_CONFIG_DIR"

    # Backup existing Cursor MCP config if it exists and isn't managed by us
    CURSOR_CONFIG_FILE="$CURSOR_CONFIG_DIR/mcp.json"
    if [ -f "$CURSOR_CONFIG_FILE" ] && [ ! -L "$CURSOR_CONFIG_FILE" ]; then
      cp "$CURSOR_CONFIG_FILE" "$CURSOR_CONFIG_FILE.backup.$(date +%Y%m%d-%H%M%S)"
      echo "✓ Backed up existing Cursor MCP config"
    fi

    # Remove any existing symlink
    if [ -L "$CURSOR_CONFIG_FILE" ]; then
      rm -f "$CURSOR_CONFIG_FILE"
    fi

    # Generate the Cursor config file with actual credentials
    cat > "$CURSOR_CONFIG_FILE" << EOF
    {
      "mcpServers": {
        "Figma": {
          "url": "http://127.0.0.1:3845/sse"
        },
        "playwright": {
          "command": "${pkgs.nodejs}/bin/npx",
          "args": ["@playwright/mcp@latest"],
          "env": {
            "PATH": "${pkgs.nodejs}/bin:/usr/bin:/bin"
          }
        },
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

    echo "✓ Cursor MCP configuration updated"
  '';
}