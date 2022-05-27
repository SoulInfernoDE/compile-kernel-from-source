#!/bin/bash

# Save the number of your cores to the variable CPUCORES
CPUCORES=$(nproc)
# You can change this variable to compile in any other folder
CPATH=~/Downloads

echo "Kernel Pull Merge Script v0.1a"
echo 'Installing dependencies'
sudo apt install git dwarves build-essential fakeroot bc kmod cpio libxi-dev libncurses5-dev libgtk2.0-dev libglib2.0-dev libglade2-dev libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev dpkg-dev autoconf libdw-dev cmake zstd packagekit qt5ct libpackagekitqt5-dev nano
cd $CPATH
rm linux-*.tar.xz 2> /dev/null
mkdir kernel # We create a work directory folder
read -p "Which kernel version do you want to compile? (example: 5.17.5) " KERNEL_VERSION
echo 'kernel version you entered: '$KERNEL_VERSION'_android'
wget 'https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-'$KERNEL_VERSION'.tar.xz'
tar xvf linux-* -C kernel/ --strip-components=1 # unpacking the tar.xz to the kernel folder
cd kernel # we open the kernel folder
cp /boot/config-$(uname -r) ./.config # we copy your current configuration file from /boot/config to the kernel folder and rename it to .config
make olddefconfig # we re-generate the copied config file to update new lines in newer kernel versions with the pre-defined default answer
echo 'Configuration file with standard defaults options: '$KERNEL_VERSION'_android has been created..'
# Downloading the merge fragments file - if you need this changed create a pull request
wget https://raw.githubusercontent.com/SoulInfernoDE/compile-kernel-from-source/main/nogui/.config-fragment
# Using terminal script from torvalds to modify the needed lines into the .config file found in the kernel sources under kernel/scripts/kconfig/merge_config.sh
# Merge IP fragment CONFIG_ settings into the main .config file
./scripts/kconfig/merge_config.sh .config .config-fragment
echo 'merging new android options into the .config file:'
make olddefconfig # we have added the ANDROID lines at the end of the config file, however we re-generate the config file again to maintain the correct structure
echo 'You have' $CPUCORES 'cpu cores'
echo "Ready to start compiling! Enter 'time nice make bindeb-pkg' -j'YOUR NUMBER OF CORES HERE' to start compiling with multi-core mode.."
echo ''
read -r -p "
###############################################################
# deb-file creation will start. Do you want to continue?      #
#                                                             #
#   - Make sure configuration changes are correct!            #
############################################################### 
(y|Y)es (n|N)o # " input

case $input in
    [yY][eE][sS]|[yY])
 echo "Executing..!"
 ;;
    [nN][oO]|[nN])
 echo "No, we stop here.."
 exit 1
       ;;
    *)
 echo "Invalid selection input.. ..aborting!"
 exit 1
 ;;
esac

time nice make bindeb-pkg -j'$CPUCORES' # we start compiling process with: counting the time needed to compile, show less and nicer compile information, generate deb-files at the end and use x-cpu cores to speed up compiling procedure

read -r -p "
###############################################################
# deb-files will be installed. Do you want to continue?       #
#                                                             #
#   - Make sure compiling finished successfully!              #
############################################################### 
(y|Y)es (n|N)o # " install

case $install in
    [yY][eE][sS]|[yY])
 echo "Executing..!"
 ;;
    [nN][oO]|[nN])
 echo "No, we stop here.."
 exit 1
       ;;
    *)
 echo "Invalid selection input.. ..aborting!"
 exit 1
 ;;
esac

sudo dpkg -i $CPATH/linux-*.deb # we install the compiled *.deb kernel files
echo ''
echo 'If the script has an error for you, please report it on github. You can leave a screenshot if you like to in the issues section'
