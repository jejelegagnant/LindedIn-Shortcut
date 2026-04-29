#!/bin/bash

# Fetch configuration variables using snapctl
KBD_PATH=$(snapctl get keyboard)
TARGET_USER=$(snapctl get user)

# Check if keyboard is configured
if [ -z "$KBD_PATH" ]; then
    echo "Keyboard device not configured. Please run 'sudo linkedin-shortcut.setup'"
    exit 1
fi

# Default user to root if not set
if [ -z "$TARGET_USER" ]; then
    TARGET_USER="root"
fi

# Execute the daemon with only the keyboard and user flags
exec $SNAP/bin/linkedin_daemon -k "$KBD_PATH" -u "$TARGET_USER"
