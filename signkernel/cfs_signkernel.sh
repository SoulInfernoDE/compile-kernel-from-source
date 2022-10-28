#!/bin/bash

# Color
RED='\033[1;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BWHITE='\033[1;37m'
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

function bwhite {
    printf "${BWHITE}$@${NC}\n"
}

echo "Kernel Sign Script v0.1a"
echo 'Installing dependencies'
sudo apt install wget openssl sbsigntool mokutil

read -r -p "
################################################################
# custom kernel signing script v0.1a @github.com/SoulInfernoDE #
################################################################
# This will help you generate and install your own UEFI key    #
# into your linux and bios.    $(red 'Do you want to continue?')        #
#  $(green '- If you already generated your key, skip this step to')      #
#    $(green 'just sign your kernel with your previously generated MOK')  #
#    $(green 'file!')                                                     #
################################################################ 
(y|Y)es (n|N)o # " input

case $input in
    [yY][eE][sS]|[yY])
 echo "mokconfing.cnf will be pulled and encrypted with openssl..!"
;;
    [nN][oO]|[nN])
 echo "Signing your kernel.."
 echo ''
 echo '' 'Here is a printout of what is installed:'
 ls /boot/vmlinuz*-android
 echo ''
 read -p "Which kernel version should be signed? (example: 5.14.18) " KERNEL_VERSION
 echo ''
 echo 'You have entered this version: '$KERNEL_VERSION'-android'
 echo ''
 cd ~
 sudo sbsign --key MOK.priv --cert MOK.pem '/boot/vmlinuz-'$KERNEL_VERSION'-android' --output '/boot/vmlinuz-'$KERNEL_VERSION'-android'
 echo ''
 sudo update-grub
 echo ''
 echo $(green 'All done.. - please restart your computer!')
 echo ''
 exit 1
       ;;
    *)
 echo "Invalid selection input.. ..aborting!"
 exit 1
 ;;
esac

cd ~
wget https://raw.githubusercontent.com/SoulInfernoDE/compile-kernel-from-source/v6.x/signkernel/mokconfig.cnf 2> /dev/null
openssl req -config ./mokconfig.cnf -new -x509 -newkey rsa:2048 -nodes -days 36500 -outform DER -keyout "MOK.priv" -out "MOK.der"
echo ''
openssl x509 -in MOK.der -inform DER -outform PEM -out MOK.pem
echo ''
echo 'you will be asked for a password, which is used to encrypt and protect your key.'
echo 'It is also needed after restart in a blue window. You can choose whatever you like..'
sudo mokutil --import MOK.der
echo ''
echo $(bwhite 'Your generated key has been enrolled to your UEFI bios. Please re-run the script and select -NO- then sign the kernel before you reboot!')
echo ''
echo $(red 'After restart you will get a blue window which is called MOK Manager. Please select Import, Import Key, then enter your selected password you generated for your key!')
echo ''
