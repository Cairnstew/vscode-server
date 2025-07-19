#!/usr/bin/env bash
set -euo pipefail

echo "Starting code-server..."
exec code-server "$@"
