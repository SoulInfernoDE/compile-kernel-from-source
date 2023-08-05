#!/bin/bash

# Save the number of your cores to the variable CPUCORES
CPUCORES=$(nproc)
# You can change this variable to compile in any other folder
CPATH=~/Downloads
# You can change this to the version you want to compile and package to a deb file to Downloads folder
KERNEL_VERSION=6.3.13

echo "Kernel pull merge script for docker environment without asking a question"
echo 'Installing dependencies'
sudo apt install -y git dwarves build-essential fakeroot bc kmod cpio libxi-dev libncurses5-dev libgtk2.0-dev libglib2.0-dev libglade2-dev libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev dpkg-dev autoconf libdw-dev cmake zstd packagekit qt5ct libpackagekitqt5-dev nano patch patchutils
cd $CPATH
rm linux-*.tar.xz 2> /dev/null
#if the external modules have been installed we remove it here.. ..they will be burned into the kernel directly while building from source
sudo dkms remove -m anbox-ashmem/1 --all 2> /dev/null
sudo dkms remove -m anbox-binder/1 --all 2> /dev/null
mkdir -p kernel # We create a work directory folder
# Removed ashmemsource fix and using the one provided by chris
# echo 'Pulling ashmemk6.tar.xz source from anbox-modules fork'
# wget https://raw.githubusercontent.com/SoulInfernoDE/compile-kernel-from-source/v6.x/nogui/ashmemk6.tar.xz
# mkdir anboxashmem
# cd $CPATH/anboxashmem
# wget https://raw.githubusercontent.com/SoulInfernoDE/compile-kernel-from-source/v6.x/nogui/ashmemsourcefix6x.patch
# tar xvf $CPATH/ashmemk6.tar.xz -C $CPATH/anboxashmem/ --strip-components=1
# patch -p1 -i ashmemsourcefix6x.patch
# sudo cp -rT $CPATH/anboxashmem/ /usr/src/anbox-ashmem-1
# sudo cp $CPATH/anboxashmem/anbox.conf /etc/modules-load.d/
# sudo cp $CPATH/anboxashmem/99-anbox.rules /lib/udev/rules.d/
# sudo dkms install anbox-ashmem/1
# echo ''
# sudo modprobe ashmem_linux
# echo ''
sudo mkdir -p /dev/binder
# sudo mount -t binder binder /dev/binder
# echo ''
sudo lsmod | grep -e ashmem_linux -e binder_linux
echo ''
sudo ls -alh /dev/binder /dev/ashmem
echo ''
cd $CPATH
echo ''
echo ''
# Entering version manually to the target zip file at the top
# read -p "Which kernel version do you want to compile? (example: 6.0.3) " KERNEL_VERSION
# echo 'kernel version you entered: '$KERNEL_VERSION'_android'
wget 'https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-'$KERNEL_VERSION'.tar.xz'
tar xvf linux-* -C kernel/ --strip-components=1 # unpacking the tar.xz to the kernel folder
cd kernel # we open the kernel folder
# We are using the config file from our github repo for docker
mkdir -p /boot
# cp /boot/config-$(uname -r) ./.config # we copy your current configuration file from /boot/config to the kernel folder and rename it to .config
echo 'Downloading the ASHMEM source code removal patch from upstream'
wget -O remove_ashmem.patch https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=721412ed3d819e767cac2b06646bf03aa158aaec
echo ''
echo 'Reverting the removal patch code..'
interdiff -q remove_ashmem.patch /dev/null > enable_ashmem.patch
echo ''
echo 'Patching the kernel sources to bring back ASHMEM..'
patch -p1 -N -i enable_ashmem.patch
echo ''
echo 'DONE! ASHMEM is now selectable again in your kernel .config file! NOTE: THIS MAY BREAK ANYTIME AS ASHMEM IS REPLACED WITH MEMFD'
echo 'which is not supported by Anbox yet..'
echo ''
echo ''
make olddefconfig # we re-generate the copied config file to update new lines in newer kernel versions with the pre-defined default answer
echo 'Configuration file with standard defaults options: '$KERNEL_VERSION'_android has been created..'
# Downloading the merge fragments file - if you need this changed create a pull request
wget https://raw.githubusercontent.com/SoulInfernoDE/compile-kernel-from-source/v6.x/nogui/.config-fragment
# Using terminal script from torvalds to modify the needed lines into the .config file found in the kernel sources under kernel/scripts/kconfig/merge_config.sh
# Merge IP fragment CONFIG_ settings into the main .config file
$CPATH/kernel/scripts/kconfig/./merge_config.sh .config .config-fragment
echo 'merging new android options into the .config file:'
make olddefconfig # we have added the ANDROID lines at the end of the config file, however we re-generate the config file again to maintain the correct structure
echo 'You have' $CPUCORES 'cpu cores'
echo ''
# Start compiling
# read -r -p "
###############################################################
#                Ready to start compiling!                    #
# To manually compile enter: time nice make bindeb-pkg -j$CPUCORES    #
#                                                             #
# deb-file creation will start. Do you want to continue?      #
#                                                             #
#   - Make sure configuration changes are correct!            #
############################################################### 
# (y|Y)es (n|N)o # " input

# case $input in
#     [yY][eE][sS]|[yY])
# echo "Executing..!"
# ;;
#    [nN][oO]|[nN])
# echo "No, we stop here.."
# exit 1
#       ;;
#    *)
# echo "Invalid selection input.. ..aborting!"
# exit 1
# ;;
# esac

time nice make bindeb-pkg -j$CPUCORES # we start compiling process with: counting the time needed to compile, show less and nicer compile information, generate deb-files at the end and use x-cpu cores to speed up compiling procedure

# read -r -p "
###############################################################
# deb-files will be installed. Do you want to continue?       #
#                                                             #
#   - Make sure compiling finished successfully!              #
############################################################### 
# (y|Y)es (n|N)o # " install

# case $install in
#    [yY][eE][sS]|[yY])
# echo "Executing..!"
# ;;
#    [nN][oO]|[nN])
# echo "No, we stop here.."
# exit 1
#       ;;
#    *)
# echo "Invalid selection input.. ..aborting!"
# exit 1
# ;;
# esac

# Not installing the deb files instead we upload it to the cloud folder on gdrive
# cloud upload script goes here

########

# sudo dpkg -i $CPATH/linux-*.deb # we install the compiled *.deb kernel files
# echo ''
# echo 'If the script has an error for you, please report it on github. You can leave a screenshot if you like to in the issues section'
