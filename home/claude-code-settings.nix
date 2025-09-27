{ config, pkgs, lib, ... }:

{
  # Manage Claude Code MCP servers in ~/.claude.json
  home.activation.generateClaudeCodeSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Configuring Claude Code MCP servers in ~/.claude.json..."

    # Enable biometric unlock for this session
    export OP_BIOMETRIC_UNLOCK_ENABLED=true

    # Retrieve credentials from 1Password
    CIRCLECI_TOKEN=$(${pkgs._1password-cli}/bin/op read "op://MCPs/circleci-mcp/api-token" --account my.1password.com 2>/dev/null || echo "")
    DD_API_KEY=$(${pkgs._1password-cli}/bin/op read "op://MCPs/datadog-mcp/api-key" --account my.1password.com 2>/dev/null || echo "")
    DD_APP_KEY=$(${pkgs._1password-cli}/bin/op read "op://MCPs/datadog-mcp/app-key" --account my.1password.com 2>/dev/null || echo "")

    # Update ~/.claude.json with MCP servers
    CLAUDE_CONFIG_FILE="$HOME/.claude.json"

    # Backup existing file if it exists
    if [ -f "$CLAUDE_CONFIG_FILE" ]; then
      cp "$CLAUDE_CONFIG_FILE" "$CLAUDE_CONFIG_FILE.backup.$(date +%Y%m%d-%H%M%S)"
      echo "✓ Backed up existing Claude Code config"

      # Update existing file with MCP servers
      ${pkgs.jq}/bin/jq --argjson servers '{
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
            "CIRCLECI_TOKEN": "'"$CIRCLECI_TOKEN"'",
            "CIRCLECI_BASE_URL": "https://circleci.com",
            "PATH": "${pkgs.nodejs}/bin:/usr/bin:/bin"
          }
        },
        "datadog": {
          "command": "${pkgs.nodejs}/bin/node",
          "args": ["'"${config.home.homeDirectory}"'/opensource/datadog-mcp/build/index.js"],
          "env": {
            "DD_API_KEY": "'"$DD_API_KEY"'",
            "DD_APP_KEY": "'"$DD_APP_KEY"'",
            "DD_SITE": "datadoghq.com"
          }
        }
      }' '. + {userMcpServers: $servers}' "$CLAUDE_CONFIG_FILE" > "$CLAUDE_CONFIG_FILE.tmp" && \
      mv "$CLAUDE_CONFIG_FILE.tmp" "$CLAUDE_CONFIG_FILE"
    else
      echo "Warning: ~/.claude.json not found. Creating minimal configuration..."
      cat > "$CLAUDE_CONFIG_FILE" << EOF
    {
      "userMcpServers": {
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
    fi

    echo "✓ Claude Code MCP servers configured in ~/.claude.json"

    # Also maintain ~/.claude/settings.json for hooks and other settings
    CLAUDE_SETTINGS_DIR="$HOME/.claude"
    mkdir -p "$CLAUDE_SETTINGS_DIR"

    CLAUDE_SETTINGS_FILE="$CLAUDE_SETTINGS_DIR/settings.json"
    # Only create settings.json if it doesn't exist, preserve user's existing settings
    if [ ! -f "$CLAUDE_SETTINGS_FILE" ]; then
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
      }
    }
    EOF
      echo "✓ Created ~/.claude/settings.json with hooks configuration"
    fi
  '';
}