#!/bin/bash

# -------------------------------
# DEFINE COLORS FUNCTION SECTION-
#--------------------------------
# Colors
RED='\033[1;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

function red {
    printf "${RED}$@${NC}\n"
}

function green {
    printf "${GREEN}$@${NC}\n"
}

function yellow {
    printf "${YELLOW}$@${NC}\n"
}

function blue {
    printf "${BLUE}$@${NC}\n"
}
#-------------------------------
#
#---------------------
#- VARIABLES SECTION -
#---------------------
# Does save the number of your cores to the variable CPUCORES
CPUCORES=$(nproc)
# You can change this variable after --> = to compile in any other folder
CPATH=~/Downloads
#---------------------
echo $(yellow "Compile Kernel from Source Script v0.1a Ubuntu")
#
echo $(yellow 'Installing dependencies')
sudo apt install git dwarves build-essential fakeroot bc kmod cpio libxi-dev libncurses5-dev libgtk2.0-dev libglib2.0-dev libglade2-dev libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev dpkg-dev autoconf libdw-dev cmake zstd packagekit qt5ct libpackagekitqt5-dev nano patch patchutils
clear
cd $CPATH
rm -R -f oraclekernel 2> /dev/null
mkdir oraclekernel # We create a work directory folder
cd oraclekernel
read -p "$(yellow 'Which kernel version do you want to compile?') $(green '(example: linux-image-unsigned-5.13.0-1028-oracle)') " KERNEL_VERSION
echo ''
echo $(yellow 'kernel version you entered: '$KERNEL_VERSION'_android')
echo ''
apt source $KERNEL_VERSION
rm *.gz *.dsc # we remove the compressed files to be able to rename the folder to rename the source code folder to our KERNEL_VERSION variable
mv linux-* $KERNEL_VERSION # we rename the source code folder to KERNEL_VARIABLE for easier and bug free script transition
cd $KERNEL_VERSION # we open the downloaded kernel source code folder downloaded by apt
cp /boot/config-$(uname -r) ./.config # we copy your current configuration file from /boot/config to the kernel source code folder and rename it to .config
clear # clear text input for readability
echo $(yellow 'Downloading the ASHMEM source code removal patch from upstream')
echo ''
wget -O remove_ashmem.patch https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=721412ed3d819e767cac2b06646bf03aa158aaec
echo ''
echo $(yellow 'Reverting the removal patch code..')
echo ''
interdiff -q remove_ashmem.patch /dev/null > enable_ashmem.patch
echo $(yellow 'DONE! '$CPATH/oraclekernel/$KERNEL_VERSION/enable_ashmem.patch' has been created')
echo ''
echo $(yellow 'Patching the kernel sources with enable_ashmem.patch to bring back ASHMEM..')
echo ''
patch -p1 -N -i enable_ashmem.patch
echo ''
echo $(yellow 'DONE! ASHMEM is now selectable again in your kernel .config file! NOTE: THIS MAY BREAK ANYTIME AS ASHMEM IS REPLACED WITH MEMFD')
echo $(yellow 'which is not supported by Anbox yet..')
echo ''
yes "" | make oldconfig # we re-generate the copied config file to update new lines in newer kernel versions with the pre-defined default answer to match invalidated options with Y instead of M
echo ''
echo $(yellow 'Configuration file with standard defaults options: '$KERNEL_VERSION'_android has been created..')
echo ''
echo $(yellow 'Downloading the merge fragments file - if you need this changed create a pull request')
echo ''
wget https://raw.githubusercontent.com/SoulInfernoDE/compile-kernel-from-source/main/nogui/.config-fragment
# Using terminal script from torvalds to modify the needed lines into the .config file found in the kernel sources under kernel/scripts/kconfig/merge_config.sh
echo ''
echo $(green 'Merge .config-fragments file with ANDROID-CONFIG_ settings into the main .config file')
echo ''
./scripts/kconfig/merge_config.sh .config .config-fragment
echo $(yellow 'merging new android options into the .config file:')
echo ''
make olddefconfig # we have added the ANDROID lines at the end of the config file, however we re-generate the config file again to maintain the correct structure
echo ''
echo $(yellow 'You have '$CPUCORES' cpu cores')
echo ''
echo $(yellow 'Ready to start compiling! Manually enter anytime you want to restart compiling: time nice make bindeb-pkg -j'$CPUCORES'')
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
 echo $(green "Executing..!")
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
echo $(yellow 'If the script has an error for you, please report it on github. You can leave a screenshot if you like to in the issues section'
echo ''
echo 'If you are using uefi secure boot within your linux installation then you need to sign your kernel. You can download my script for automation here: Right-click and save-as'
echo 'https://raw.githubusercontent.com/SoulInfernoDE/compile-kernel-from-source/test/signkernel/cfs_signkernel.sh'')
