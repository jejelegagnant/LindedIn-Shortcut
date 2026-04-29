#!/bin/bash
# Define the new path for the renamed snap
FIFO_PATH="/var/snap/quick-linkedin/common/trigger.fifo"

echo "=== Quick LinkedIn Setup ==="

# 1. Ask for the keyboard device
read -p "Enter keyboard path (/dev/input/eventX): " KBD_PATH
snapctl set keyboard="$KBD_PATH"

# 2. Create the FIFO pipe in the correct 'common' folder[cite: 1, 2]
if [ ! -p "$FIFO_PATH" ]; then
    sudo mkfifo "$FIFO_PATH"
    sudo chmod 666 "$FIFO_PATH"
    echo "Created IPC pipe at $FIFO_PATH"
else
    echo "IPC pipe already exists."
fi

echo "Done. Please run: sudo snap connect quick-linkedin:raw-input"
