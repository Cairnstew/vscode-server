#!/usr/bin/env bash
set -euo pipefail


echo "Starting extension download..."

# Run the script to download VSIX extensions
/usr/local/bin/install-extensions.sh

/usr/local/bin/add-extensions-user.sh

echo "All extensions downloaded successfully."

echo "Starting code-server..."
exec code-server "$@"
