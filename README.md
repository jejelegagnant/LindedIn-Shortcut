# LinkedIn Shortcut

A low-latency C-based Linux daemon designed to optimize professional networking workflows by providing an immediate, global hardware shortcut to professional platforms.

## Overview

This project implements a system-level service that monitors hardware input events directly via the Linux kernel's input subsystem. By bypassing traditional desktop environment hotkey managers, it ensures a highly responsive and reliable trigger for professional engagement tools, specifically tailored for users who require high-frequency access to networking platforms.

## Features

- **Low-Level Event Monitoring:** Written in C to interface directly with `/dev/input/` nodes for minimal resource footprint.
- **Non-Blocking Architecture:** Designed as a background daemon to ensure no interference with standard system operations.
- **Automated Hardware Detection:** Includes an interactive setup utility to identify and map specific keyboard event nodes.
- **Environment Agnostic:** Compatible with both Wayland and X11 sessions.

## Installation

The most efficient way to deploy the daemon is via the Snap Store. This ensures all dependencies and environment variables are handled correctly.

```bash
sudo snap install linkedin-shortcut --classic --edge
```

## Initial Configuration

After installation, run the included setup utility to map the daemon to your specific hardware configuration. This script will detect your keyboard's event node and allow you to specify your preferred browser.

```bash
sudo linkedin-shortcut.setup
```

The default global hotkey is configured as:
Ctrl + Alt + Shift + Super + L

## Technical Structure

The project is composed of several specialized components:

| File | Description |
|---|---|
| `linkedin_daemon.c` | Core C source responsible for event monitoring and process spawning |
| `Makefile` | Handles compilation and installation logic |
| `setup.sh` | Interactive shell utility for hardware and environment configuration |
| `snapcraft.yaml` | Defines the build pipeline and confinement parameters for cross-distribution compatibility |

## Building from Source

If you prefer to build the binary manually outside of the Snap environment:

**Prerequisites:** Ensure `gcc` and `make` are installed on your system.

**Compile:**

```bash
make
```

**Install:**

```bash
sudo make install
```

## License

This project is released under the [GNU General Public License v2.0 or later](LICENSE).

> **Note:** This tool is intended for professional productivity optimization. Ensure you have the necessary permissions to access `/dev/input/` nodes on your system.
