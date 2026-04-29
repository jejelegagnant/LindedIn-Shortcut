# LinkedIn Shortcut Daemon

A strictly confined, background Linux daemon that listens for a global keyboard shortcut (`Ctrl + Alt + Shift + Super + L`) and instantly launches LinkedIn in the user's default web browser.

## Architecture

This project uses a Client/Server Inter-Process Communication (IPC) architecture to comply with Canonical's strict Snap sandboxing rules, avoiding the need for a manual "Classic" confinement review.

As you may already know from system architecture design, crossing the boundary between a root hardware service and a user-space graphical session requires careful privilege separation. This snap splits the workload into two distinct processes:

1. **The Hardware Daemon (Server):** Runs as a background `systemd` service with root privileges. It utilizes the `raw-input` plug to read `/dev/input/eventX`. When the shortcut is detected, it writes a single trigger byte to a shared Named Pipe (FIFO).
2. **The User Agent (Client):** Runs within the user's active Wayland/X11 graphical session, automatically started via a `.desktop` entry. It continuously polls the FIFO. Upon receiving the trigger byte, it executes `xdg-open` utilizing the `desktop` plug, safely launching the browser with the correct D-Bus session variables.

## Prerequisites

- `snapd` installed on your system.
- `snapcraft` (for building from source).
- A Linux desktop environment (GNOME, KDE, etc.) running Wayland or X11.

## Installation

### Building from Source

1. Clone the repository and navigate to the root directory.
2. Build the snap package:

```bash
snapcraft clean build-c-binaries
snapcraft pack
```

3. Install the built snap locally:

```bash
sudo snap install ./linkedin-shortcut_3.0-ipc_amd64.snap --dangerous
```

## Configuration

Because this snap operates under strict confinement, you must manually grant it permission to read raw keyboard input, and specify which input device to monitor.

### 1. Grant Hardware Access

Allow the daemon to read from `/dev/input/`:

```bash
sudo snap connect linkedin-shortcut:raw-input
```

### 2. Run the Setup Script

Initialize the configuration and create the IPC pipe. You will need to know the path to your keyboard's event node (e.g., `/dev/input/event3`).

```bash
sudo linkedin-shortcut.setup
```

## Usage

### Automatic Startup

The User Agent is configured to start automatically when you log into your graphical session.

If installing for the first time mid-session: you must log out and log back in for GNOME or your desktop environment to trigger the autostart `.desktop` file.

Once logged in, press `Ctrl + Alt + Shift + Super + L` anywhere to open LinkedIn.

### Manual Testing

If you wish to test the IPC bridge without logging out, you can run the agent manually in a standard terminal (do not use `sudo`):

```bash
linkedin-shortcut.agent
```

Leave the terminal open and press the keyboard shortcut. The terminal will log the event and launch the browser.

## Troubleshooting

- **Daemon crash loop / permission denied:** Ensure you have run `sudo snap connect linkedin-shortcut:raw-input`. If the permission was missing, `systemd` may have given up on restarting the daemon. Reset it by running `sudo snap restart linkedin-shortcut.daemon`.
- **Shortcut does nothing (agent not running):** Check whether the agent is running in the background. You can inspect the user-level `systemd` journal:

```bash
journalctl --user -f | grep linkedin
```

- **"Cannot open device" in daemon logs:** Ensure the path provided during `linkedin-shortcut.setup` is the absolute path (e.g., `/dev/input/event3`, not just `event3`). Verify your keyboard path using `evtest`.
