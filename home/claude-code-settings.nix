{ config, pkgs, lib, ... }:

{
  # Generate Claude Code settings.json file with MCP servers and other configurations
  home.activation.generateClaudeCodeSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Configuring Claude Code settings.json..."

    # Enable biometric unlock for this session
    export OP_BIOMETRIC_UNLOCK_ENABLED=true

    # Retrieve credentials from 1Password
    CIRCLECI_TOKEN=$(${pkgs._1password-cli}/bin/op read "op://MCPs/circleci-mcp/api-token" --account my.1password.com 2>/dev/null || echo "")
    DD_API_KEY=$(${pkgs._1password-cli}/bin/op read "op://MCPs/datadog-mcp/api-key" --account my.1password.com 2>/dev/null || echo "")
    DD_APP_KEY=$(${pkgs._1password-cli}/bin/op read "op://MCPs/datadog-mcp/app-key" --account my.1password.com 2>/dev/null || echo "")

    # Create the Claude settings directory if it doesn't exist
    CLAUDE_SETTINGS_DIR="$HOME/.claude"
    mkdir -p "$CLAUDE_SETTINGS_DIR"

    # Backup existing settings.json if it exists
    CLAUDE_SETTINGS_FILE="$CLAUDE_SETTINGS_DIR/settings.json"
    if [ -f "$CLAUDE_SETTINGS_FILE" ]; then
      cp "$CLAUDE_SETTINGS_FILE" "$CLAUDE_SETTINGS_FILE.backup.$(date +%Y%m%d-%H%M%S)"
      echo "✓ Backed up existing Claude Code settings"
    fi

    # Generate the Claude Code settings.json file
    cat > "$CLAUDE_SETTINGS_FILE" << EOF
    {
      "\$schema": "https://json.schemastore.org/claude-code-settings.json",
      "model": "opus",
      "hooks": {
        "PostToolUse": [
          {
            "matcher": "Edit|MultiEdit|Write",
            "hooks": [
              {
                "type": "command",
                "command": "jq -r '.tool_input.file_path' | { read file_path; if echo \"\$file_path\" | grep -q '\\\\.dart\$'; then dart format \"\$file_path\"; fi; }"
              },
              {
                "type": "command",
                "command": "jq -r '.tool_input.file_path' | { read file_path; if echo \"\$file_path\" | grep -q '\\\\.rb\$'; then bundle exec rubocop -a \"\$file_path\" 2>/dev/null || rubocop -a \"\$file_path\" 2>/dev/null || true; fi; }"
              }
            ]
          }
        ]
      },
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

    echo "✓ Claude Code settings.json configured with all MCP servers"
  '';
}