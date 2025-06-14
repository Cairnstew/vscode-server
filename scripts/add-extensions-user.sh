#!/usr/bin/env bash
set -euo pipefail

USER_SETTINGS="/home/coder/.local/share/code-server/User/settings.json"
mkdir -p "$(dirname "$USER_SETTINGS")"

# Create empty JSON if not exists
if [ ! -f "$USER_SETTINGS" ]; then
  echo "{}" > "$USER_SETTINGS"
fi

# Get installed extensions as JSON array
installed_exts=$(code-server --list-extensions | jq -R -s -c 'split("\n")[:-1]')

# Update extensions.enabled in settings.json
tmpfile=$(mktemp)
jq --argjson exts "$installed_exts" '
  .["extensions.enabled"] = $exts
' "$USER_SETTINGS" > "$tmpfile" && mv "$tmpfile" "$USER_SETTINGS"

echo "Updated $USER_SETTINGS with enabled extensions."
