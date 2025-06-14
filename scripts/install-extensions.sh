#!/usr/bin/env bash
set -euo pipefail

DOWNLOAD_DIR="/home/coder/extensions"
EXTENSIONS_FILE="/home/coder/extensions.txt"
TMP_DIR="${DOWNLOAD_DIR}/tmp"

mkdir -p "$DOWNLOAD_DIR"

if [ ! -f "$EXTENSIONS_FILE" ]; then
  echo "Extensions file $EXTENSIONS_FILE not found."
  exit 1
fi

while IFS= read -r url || [[ -n "$url" ]]; do
  # Skip empty lines or comments
  [[ -z "$url" || "$url" =~ ^# ]] && continue

  echo "🔧 Downloading from URL: $url"

  mkdir -p "$TMP_DIR"
  cd "$TMP_DIR"

  # Extract filename from URL (last path segment)
  filename=$(basename "$url")
  # If filename does not end with .vsix, append .vsix
  [[ "$filename" != *.vsix ]] && filename="${filename}.vsix"

  target_path="${DOWNLOAD_DIR}/${filename}"

  if [[ -f "$target_path" ]]; then
    echo "✔ $filename already exists. Skipping download."
  else
    if curl -L -o "$filename" "$url"; then
      if unzip -t "$filename" >/dev/null 2>&1; then
        echo "✔ Valid VSIX. Moving to $DOWNLOAD_DIR"
        mv "$filename" "$target_path"
      else
        echo "❌ Invalid VSIX file downloaded. Deleting."
        rm -f "$filename"
        continue
      fi
    else
      echo "❌ Failed to download $url"
      continue
    fi
  fi

  echo "📦 Installing $target_path..."
  if code-server --install-extension "$target_path"; then
    echo "✅ Installed: $filename"
  else
    echo "❌ Failed to install: $filename"
  fi

  # Clean up temp dir after each iteration
  rm -rf "$TMP_DIR"
done < "$EXTENSIONS_FILE"
