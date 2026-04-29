#!/bin/bash
# Move to the snap's writable user data directory
cd "$SNAP_USER_DATA" || exit 1
sleep 2
exec "$SNAP/bin/agent"
