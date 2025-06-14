#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <publisher.extensionName> <version> [output-directory]"
  echo "Example: $0 ms-python.python 2024.17.2024100401 ./downloads"
  exit 1
fi

EXTENSION_ID="$1"
VERSION="$2"
OUTPUT_DIR="${3:-.}"

# Split publisher and extension name
if [[ "$EXTENSION_ID" != *.* ]]; then
  echo "Error: Extension ID must be in 'publisher.extensionName' format"
  exit 1
fi

PUBLISHER="${EXTENSION_ID%%.*}"
EXTENSION_NAME="${EXTENSION_ID#*.}"

URL="https://marketplace.visualstudio.com/_apis/public/gallery/publishers/${PUBLISHER}/vsextensions/${EXTENSION_NAME}/${VERSION}/vspackage"

mkdir -p "$OUTPUT_DIR"
OUT_FILE="${OUTPUT_DIR}/${EXTENSION_NAME}-${VERSION}.vsix"

echo "Downloading VSIX from:"
echo "$URL"
echo "Saving to: $OUT_FILE"

curl -L -o "$OUT_FILE" "$URL"

echo "Download complete."
