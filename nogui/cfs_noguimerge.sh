#!/bin/bash

echo "Kernel Pull Merge Script v0.1a"
echo 'Installing dependencies'
sudo apt install git dwarves build-essential fakeroot bc kmod cpio libxi-dev libncurses5-dev libgtk2.0-dev libglib2.0-dev libglade2-dev libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev dpkg-dev autoconf libdw-dev cmake zstd packagekit qt5ct libpackagekitqt5-dev nano
cd ~/Downloads
rm linux-*.tar.xz 2> /dev/null
mkdir kernel
read -p "Which kernel version do you want to compile? (example: 5.17.5) " KERNEL_VERSION
echo 'kernel version you entered: '$KERNEL_VERSION'_android'
wget 'https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-'$KERNEL_VERSION'.tar.xz'
tar xvf linux-* -C kernel/ --strip-components=1
cd kernel
cp /boot/config-$(uname -r) ./.config
make olddefconfig
echo 'Configuration file with standard defaults options: '$KERNEL_VERSION'_android has been created..'
# Downloading the merge fragments file - if you need this changed create a pull request
wget https://raw.githubusercontent.com/SoulInfernoDE/compile-kernel-from-source/main/nogui/.config-fragment
# Using terminal script from torvalds to modify the needed lines into the .config file found in the kernel sources under kernel/scripts/kconfig/merge_config.sh
# Merge IP fragment CONFIG_ settings into the main .config file
./scripts/kconfig/merge_config.sh .config .config-fragment
echo 'merging new android options into the .config file:'
make olddefconfig
echo 'You have'
nproc && echo 'cpu cores'
echo "Ready to start compiling! Enter "time nice make bindeb-pkg -jYOUR NUMBER OF CORES HERE" to start compiling with multi-core mode.."
echo 'If the script has an error for you, please report it on github. You can leave a screenshot if you like to in the issues section'
