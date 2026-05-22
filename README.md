# Kernel Upgrade Script (v2.8)

[🇩🇪 Wechseln zur deutschen Version](README_DE.md)

A fully automated bash script to compile, install, and sign current mainline Linux kernels. This script is optimized to integrate modern kernel features and security standards (UEFI Secure Boot signing) seamlessly.

## 🚀 Features

- **Fully Automated:** Downloads the latest stable kernel from `kernel.org`, configures, builds, and installs it.
- **Waydroid Ready:** Automatically integrates `.config` fragments for **Binder** and **memfd** (required for modern Waydroid/Android containers, replacing the obsolete ashmem).
- **Secure Boot Support:** Automated MOK (Machine Owner Key) generation and signing of kernel images (`sbsign`).
- **Autosign Integration:** Installs a post-install hook that automatically signs future kernel updates.
- **Multilingual:** Automatically detects system locale (English/German).
- **Flexible:** Supports installing specific versions via `--kernelversion`.

## 🛠 Prerequisites

The script installs necessary dependencies automatically via `apt`. Generally required:
- A Debian-based system (Ubuntu, Linux Mint, Debian, etc.)
- Active internet connection
- Root privileges (via `sudo`)

## 📦 Installation & Usage

1. **Prepare the script:**
   Save or download the script code as `kernel_upgrade`.

2. **Make it executable:**
   ```bash
   chmod +x kernel_upgrade

3. **Run it:**
   ```bash
   ./kernel_upgrade

## ⚙️ Parameters & Options
   ```
Option	               Description
-h, --help	            Shows the help page.
--version	            Shows the current script version (v2.0).
--kernelversion [VER]	Forces the build of a specific version (e.g., 6.12.1).
--signonly	            Only signs an existing kernel in /boot (no build).
--installautosign	      Installs the hook script for automatic signing during updates.
--uninstallautosign   	Removes the autosign script and optionally cleans up keys.
```

## 🔐 Secure Boot Note
If you use Secure Boot, the script will ask you during the first run whether to generate new MOK keys.

Confirm the generation.

Reboot your system after the script finishes.

In the blue menu (MOK Manager), select: Enroll MOK -> Continue -> Yes -> Enter Password -> Reboot.
The new kernel can now be booted securely.

## 📂 File Structure
~/Downloads: Location for extracting kernel sources and building .deb packages.

~/.mok_keys: Storage for your private UEFI keys.

/etc/kernel/postinst.d/: Installation path for the autosign hook.
