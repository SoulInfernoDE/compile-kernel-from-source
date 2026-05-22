# Kernel Upgrade Script (v2.9)

[🇩🇪 Wechseln zur deutschen Version](README_DE.md)

A fully automated bash script to compile, install, and sign current mainline Linux kernels. This script is optimized to integrate modern kernel features, clean up custom kernel remnants, and handle security standards (UEFI Secure Boot signing) seamlessly.

## 🚀 Features

- **🌐 OTA Auto-Updater:** Automatically checks the GitHub repository on execution. If a newer version is found, it hot-swaps itself and resumes your command instantly (even works with options like `-h`).

- **📦 Global CLI Integration (`--install-system`):** Installs the script to `~/.scripts`, configures your `~/.bashrc` PATH, and activates native tab autocompletion.

- **Fully Automated:** Downloads the latest stable kernel from `kernel.org`, configures, builds, and installs it.

- **Waydroid Ready:** Automatically integrates `.config` fragments for **Binder** and **memfd** (required for modern Waydroid/Android containers, replacing the obsolete ashmem).

- **Secure Boot & DKMS Support:** Automated MOK (Machine Owner Key) generation and signing of kernel images (`sbsign`). Deploys matching PEM and binary DER keys simultaneously to prevent SSL/ASN1 parsing errors during third-party module builds (e.g., DisplayLink `evdi` via `kmodsign`).

- **🔄 Smart Version Validation:** Detects if the target kernel is already running or installed, prompting you with an interactive selection of the top 3 alternative stable releases instead of starting redundant builds.

- **🧹 Automated Purge Sequence (`--purge-custom`):** Safely removes old `-waydroid` kernel remnants, header configurations, and debugging symbols. It uses a temporary `grub-reboot` hook to boot into your stock distribution kernel, performs a deep clean-up, and automatically resumes the script post-reboot.
- **Autosign Integration:** Installs a post-install hook that automatically signs future kernel updates.
- **Multilingual:** Automatically detects system locale (English/German).


## 🛠 Prerequisites

The script installs necessary dependencies automatically via `apt`. Generally required:
- A Debian-based system (Ubuntu, Linux Mint, Debian, etc.)
- Active internet connection
- Root privileges (via `sudo`)


## 📦 Installation & Usage

1. **Prepare the script:**
   Download the script code and name it `kernel_upgrade` (or use your local filename).

2. **Make it executable:**
   ```bash
   chmod +x kernel_upgrade

3. **Install it system-wide (Recommended):**
   ```bash
   ./kernel_upgrade --install-system && source ~/.bashrc

From now on, you can simply run kernel_upgrade from any directory in your terminal with full tab completion!


⚙️ Parameters & Options
 ```bash
Option                  Description
-h, --help              Shows the comprehensive help page.
--version               Shows the current script version (v2.9-stable).
--install-system        Installs the script globally to ~/.scripts and sets up PATH.
--kernelversion [VER]   Forces the build of a specific version (e.g., 6.12.1).
--purge-custom          Triggers automated single-reboot cleanup for old custom kernel builds.
--signonly              Only signs an existing kernel in /boot (no build).
--installautosign       Installs the hook script for automatic signing during updates.
--uninstallautosign     Removes the autosign script and optionally cleans up keys.
```


🔐 Secure Boot Note
If you use Secure Boot, the script will ask you during the first run whether to generate new MOK keys.

Confirm the generation.

Reboot your system after the script finishes.

In the blue menu (MOK Manager), select: Enroll MOK -> Continue -> Yes -> Enter Password -> Reboot.
The new kernel can now be booted securely.


📂 File Structure
~/.scripts/: Installation path for the global environment execution.

~/Downloads: Location for extracting kernel sources and building .deb packages.

~/.mok_keys: Storage for your private UEFI keys (PEM and binary DER formats).

/var/lib/shim-signed/mok/: System deployment path for sbsign and dkms / kmodsign compatibility.

/etc/kernel/postinst.d/: Installation path for the autosign hook.
