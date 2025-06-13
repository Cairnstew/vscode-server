#!/usr/bin/env bash

# Prompt for extension identifier
read -rp "Enter extension ID (e.g. ms-python.python): " ext_id
IFS='.' read -r publisher name <<< "$ext_id"

# Prompt for version
read -rp "Enter version (e.g. 2024.17.2024100401): " version

# Ask for target platform
echo "Select target platform (leave empty if universal):"
echo "  1) alpine-x64"
echo "  2) alpine-arm64"
echo "  3) linux-armhf"
echo "  4) linux-arm64"
echo "  5) linux-x64"
echo "  6) win32-arm64"
echo "  7) win32-x64"
echo "  8) darwin-arm64"
echo "  9) darwin-x64"
echo "  0) Universal (no targetPlatform)"
read -rp "Enter platform number [0-9]: " platform_choice

# Map choice to platform string
platform=""
case "$platform_choice" in
  1) platform="alpine-x64" ;;
  2) platform="alpine-arm64" ;;
  3) platform="linux-armhf" ;;
  4) platform="linux-arm64" ;;
  5) platform="linux-x64" ;;
  6) platform="win32-arm64" ;;
  7) platform="win32-x64" ;;
  8) platform="darwin-arm64" ;;
  9) platform="darwin-x64" ;;
  0) platform="" ;;
  *) echo "Invalid option"; exit 1 ;;
esac

# Build the URL
url="https://marketplace.visualstudio.com/_apis/public/gallery/publishers/${publisher}/vsextensions/${name}/${version}/vspackage"
if [[ -n "$platform" ]]; then
  url="${url}?targetPlatform=${platform}"
fi

echo "Generated .vsix download URL:"
echo "$url"
