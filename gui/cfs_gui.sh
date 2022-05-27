#!/bin/bash

# Save the number of your cores to the variable CPUCORES
CPUCORES=$(nproc)
# You can change this variable to compile in any other folder
CPATH=~/Downloads

echo "Kernel Pull Script v0.1a"
echo 'Installing dependencies'
sudo apt install git dwarves build-essential fakeroot bc kmod cpio libxi-dev libncurses5-dev libgtk2.0-dev libglib2.0-dev libglade2-dev libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev dpkg-dev autoconf libdw-dev cmake zstd packagekit qt5ct libpackagekitqt5-dev nano
cd $CPATH
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
echo 'Please modify the created configuration to enable android modules beeing built within the kernel'
echo 'Installing dependencies for the graphical .config file configuration menu'
echo 'Please use XCONFIG to change the neccessary configuration before building from source'
echo 'You need to modify the Android section to yes. Use the Menu and select "Find" Search for this entries:"'
echo 'CONFIG_ASHMEM=y CONFIG_ANDROID=y CONFIG_ANDROID_BINDER_IPC=y CONFIG_ANDROID_BINDERFS=y CONFIG_ANDROID_BINDER_DEVICES="binder,hwbinder,vndbinder,binderfs" CONFIG_ANDROID_BINDER_IPC_SELFTEST=y
CONFIG_SYSTEM_TRUSTED_KEYS="" CONFIG_SYSTEM_REVOCATION_KEYS="" CONFIG_LOCALVERSION="-android"'
make xconfig
echo '"If you need this graphical menu again just enter this anytime here:"'
echo 'make xconfig'
echo 'You have'
nproc && echo 'cpu cores'
echo "Ready to start compiling! Enter "'time nice make bindeb-pkg LOCALVERSION=-android -j''YOUR NUMBER OF CORES HERE'" to start compiling with multi-core mode.."
# echo 'Please add "LOCALVERSION=-android" only the first time you compile a kernel! Otherwise your kernel files will have'
echo '"-android-android-android' added and so on..." "This is because the make command reads the installed version number also.."' 
echo''

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
