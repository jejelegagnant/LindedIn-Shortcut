#!/bin/bash

echo "=== LinkedIn Shortcut Setup ==="

# 1. Ask for the keyboard path
echo "Please enter the path to your keyboard event node (e.g., /dev/input/event0):"
read -e KBD_PATH

# 2. Get the actual user running the setup (not root)
TARGET_USER=${SUDO_USER:-$USER}

# 3. Save the configuration using snapctl
echo "Saving configuration..."
snapctl set keyboard="$KBD_PATH"
snapctl set user="$TARGET_USER"

# 4. Restart the daemon to apply changes
snapctl restart "${SNAP_NAME}.daemon"

echo "Setup complete! The daemon will run as user: $TARGET_USER"
echo "Note: You must grant hardware access to this strictly confined snap."
echo "Run: sudo snap connect linkedin-shortcut:raw-input"
