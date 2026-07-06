#!/bin/sh
# Optional development entrypoint.
#
# In the published image the n8n-nodes-smbclient community node is already
# installed in /home/node/.n8n/nodes at build time, so this script normally
# just hands off to n8n's own entrypoint.
#
# For local development you can bind-mount this repo at /opt/code-temp and set
# REINSTALL_SMB_NODE=true to override the pre-installed version with the one
# you are currently editing.
set -e

SOURCE_DIR="/opt/code-temp"
NODES_DIR="/home/node/.n8n/nodes"
PKG_NAME="n8n-nodes-smbclient"

if [ -d "$SOURCE_DIR/dist" ] && [ "${REINSTALL_SMB_NODE:-false}" = "true" ]; then
	echo "Development mode: reinstalling $PKG_NAME from $SOURCE_DIR ..."
	mkdir -p "$NODES_DIR"
	cd "$NODES_DIR"
	[ -f package.json ] || echo '{"name":"installed-nodes","private":true}' > package.json
	npm install "$SOURCE_DIR" --no-audit --no-fund --loglevel error
else
	echo "$PKG_NAME is pre-installed (set REINSTALL_SMB_NODE=true + mount /opt/code-temp to override)."
fi

# Hand off to n8n's own entrypoint.
exec /docker-entrypoint.sh "$@"
