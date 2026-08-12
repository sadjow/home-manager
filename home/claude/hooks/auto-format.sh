#!/bin/bash
# Auto-format files based on extension
# Runs silently - errors don't block operations

# Read the file path from tool input (passed via stdin as JSON)
FILE=$(cat | jq -r '.tool_input.file_path // .tool_input.filePath // empty' 2>/dev/null)

# Exit if no file path
[ -z "$FILE" ] || [ ! -f "$FILE" ] && exit 0

# Format based on extension
case "$FILE" in
  *.ex|*.exs)
    mix format "$FILE" 2>/dev/null || true
    ;;
  *.rb)
    bundle exec rubocop -A "$FILE" 2>/dev/null || true
    ;;
  *.ts|*.tsx|*.vue|*.js|*.jsx)
    yarn prettier --write "$FILE" 2>/dev/null || npx prettier --write "$FILE" 2>/dev/null || true
    ;;
  *.dart)
    dart format "$FILE" 2>/dev/null || true
    ;;
  *.clj|*.cljs|*.cljc|*.edn)
    cljstyle fix "$FILE" 2>/dev/null || true
    ;;
  *.nix)
    nixfmt "$FILE" 2>/dev/null || alejandra "$FILE" 2>/dev/null || true
    ;;
  *.json)
    jq '.' "$FILE" > "$FILE.tmp" 2>/dev/null && mv "$FILE.tmp" "$FILE" || rm -f "$FILE.tmp"
    ;;
esac

exit 0
