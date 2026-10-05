# Hermes Desktop — Raspberry Pi ARM64

Easy installer and launcher for **Hermes Desktop** on ARM64 Raspberry Pi systems.

Tested on:

* Raspberry Pi 5
* ARM64 / aarch64
* Ubuntu 24.04
* GNOME Desktop

This project installs **Hermes Desktop** without replacing or modifying your operating system.

## Features

* Raspberry Pi 5 ARM64 support
* Downloads the ARM64 Hermes Desktop AppImage
* Creates a dedicated Hermes Desktop directory
* Makes the AppImage executable automatically
* Launches Hermes Desktop with the required Electron sandbox workaround
* Simple setup and start scripts
* Update checking support

## Requirements

* Raspberry Pi 5
* 64-bit ARM operating system
* Ubuntu/Debian-based Linux
* Graphical desktop environment
* Internet connection

The installer is intended for **ARM64/aarch64** systems.

## Installation

Clone the repository:

```bash
git clone https://github.com/jamieduk/Setup-Hermes-Desktop-RPI.git
cd Setup-Hermes-Desktop-RPI
```

Make the scripts executable:

```bash
chmod +x setup.sh start.sh update-check.sh
```

Run the setup:

```bash
./setup.sh
```

Hermes Desktop will be installed to:

```text
~/Downloads/Hermes-Desktop/
```

## Starting Hermes Desktop

After installation, run:

```bash
./start.sh
```

The launcher starts Hermes Desktop using:

```text
--no-sandbox
```

This is required because the Electron/Chromium SUID sandbox inside the AppImage cannot obtain the required permissions when running from the temporary AppImage mount.

## Installation Location

The AppImage is stored in:

```text
~/Downloads/Hermes-Desktop/
```

The directory will contain the Hermes Desktop AppImage along with the launcher/setup files as applicable.

## Updating

The repository includes an update checker:

```bash
./update-check.sh
```

This can be used to check whether a newer Hermes Desktop release is available.

## Why This Repository Exists

Hermes Desktop provides an ARM64 AppImage, but getting the application running correctly on a Raspberry Pi can require an additional Electron sandbox workaround.

This repository provides simple scripts so Raspberry Pi users can install and launch Hermes Desktop without manually dealing with the AppImage setup.

## Does This Replace Raspberry Pi OS or Ubuntu?

**No.**

Hermes Desktop is a normal Linux desktop application.

It runs on top of your existing operating system:

```text
Raspberry Pi 5
└── Ubuntu / Linux ARM64
    └── GNOME Desktop
        └── Hermes Desktop
```

It does **not**:

* Replace your operating system
* Repartition your drive
* Flash your Raspberry Pi
* Replace GNOME
* Replace your desktop environment
* Require a separate operating system

## Troubleshooting

### Hermes exits with a sandbox error

If you see an error similar to:

```text
The SUID sandbox helper binary was found, but is not configured correctly.
```

make sure you are launching Hermes through:

```bash
./start.sh
```

The launcher uses:

```text
--no-sandbox
```

to work around the AppImage's Chromium sandbox permission issue.

### Check your architecture

Run:

```bash
uname -m
```

A supported Raspberry Pi 5 installation should report:

```text
aarch64
```

or:

```text
arm64
```

## Repository

[Setup-Hermes-Desktop-RPI on GitHub](https://github.com/jamieduk/Setup-Hermes-Desktop-RPI?utm_source=chatgpt.com)

## Credits

Hermes Desktop is developed separately from this installation project.

This repository provides Raspberry Pi ARM64 installation and launch scripts.

---

**(c) J~Net 2026**

