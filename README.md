# compile-kernel-from-source
Scripts to be able to automate compiling procedures. Eg. if you need to add .config options to your kernel sources like android (ASHMEM, BINDER, etc.)

Can be used to address the anbox modules issue, explained in this thread: https://github.com/anbox/anbox-modules/issues/75#issuecomment-794079944

Everything is work in progress .. (Should be working though as expected now..)

# Explanation of the scripts:
createscriptenv.sh

Adds the ability to use my scripts directly in your bash/terminal by just typing the scripts name. Make sure you copy your/my scripts to your ~/.scripts folder. (I will be extending this script somehow sometime to update-check itself and offer a installation menu for my scripts. I really love creating workflow that enables to speed up things that beeing frequently used..)

cfs_nogui.sh and cfs_noguimerge.sh

It automates the steps to compile your kernel on ubuntu/debian based systems (such as linux mint for example) while asking
the user some questions interactively

cfs_gui.sh

Same as the no GUI version but you will get a graphical interface which lets you change your config file before you re-build your kernel.
Here you need to activate all those 'android' and 'ashmem' options yourself. Make sure to do so or you will miss the ashmem and binder modules in your kernel..

Change these configuration parameters manually in the gui version and save it:
CONFIG_ASHMEM=y
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ANDROID_BINDERFS=y
CONFIG_ANDROID_BINDER_DEVICES="binder,hwbinder,vndbinder,binderfs"
CONFIG_ANDROID_BINDER_IPC_SELFTEST=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
CONFIG_SYSTEM_REVOCATION_KEYS=""
CONFIG_LOCALVERSION="-android"

# Instructions:

1. Download the nogui/noguimerge (recommended version) or gui script and make it executable if it's not:

chmod +x cfs_gui.sh cfs_nogui.sh cfs_noguimerge.sh

2. execute it:

./cfs_gui.sh
or
./cfs_nogui.sh
or
./cfs_noguimerge.sh

# Note:
You will be asked which version you want to compile which then will be pulled from kernel.org.
You can also look on https://kernel.org/ if you are unsure and want the latest kernel version compiled and installed.

3. After the kernel has been compiled you can install it with:
sudo dpkg -i ../linux-*.deb

4. After installing the kernel you may need to sign it for booting with UEFI / Secure Boot.
-->> Go Here for a script which can assist you: https://github.com/SoulInfernoDE/compile-kernel-from-source#generate-mok-file-and-sign-your-kernel-with-automation-script
5. Base reading article is: https://github.com/jakeday/linux-surface/blob/3267e4ea1f318bb9716d6742d79162de8277dea2/SIGNING.md

::: Summary what will be done :::
These are the steps you need to take:
- Create a configuration file named MOK
- enroll the MOK file with a password you choose into your linux and bios
- sign your newly installed kernel with it
- reboot the system - you will get a blue MOKManager screen
- select enroll, enroll key and enter your password which you had choosen

-->> Your custom MOK signing key is now installed in your bios, your kernel is signed with it and your linux system is verifying it

# Kernel 5.18.x
Has the ASHMEM module removed completely. Therefore we need to reverse that changes until Anbox switches to MEMFD instead of ASHMEM.

Steps to do that:
- Download the patch file and apply it reversed
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=721412ed3d819e767cac2b06646bf03aa158aaec
- Save it to your kernel directory with the name enable_ashmem.patch
- Use this command to apply it before you build your kernel:
patch -R -p1 -f enable_ashmem.patch

- You can also create a reverse patch permanently with this command:
interdiff -q file.patch /dev/null > reversed.patch

commands:
1. wget -O remove_ashmem.patch https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=721412ed3d819e767cac2b06646bf03aa158aaec
2. interdiff -q remove_ashmem.patch /dev/null > enable_ashmem.patch
3. patch -p1 -i enable_ashmem.patch

Updated the scripts to patch ashmem module back into the sources. Now the script is untested to older versions >5.18.x.
But i guess it should still work as the patched files are already in older sources available.


# Generate MOK file and sign your kernel with automation script:

1. Download the signkernel script and make it executable if it's not:

chmod +x cfs_signkernel.sh

2. execute it:
./cfs_signkernel.sh

3. - You will be asked to generate key files and enroll/import them into your linux / bios.
   - If you already created the key files once and did set a password, you can say "NO" and
     only sign your fresh installed custom kernel. Note that you need to do this also after
     creating your key files and before rebooting.
     Otherwise you cannot boot your unsigned kernel.


# Please report any bugs or errors found..
