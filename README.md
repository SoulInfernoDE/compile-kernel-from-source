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
