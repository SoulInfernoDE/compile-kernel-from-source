# For which linux distributions are these scripts ?

Actually only for Ubuntu / Debian based linux systems
I have not planned to update the scripts for other linux systems like manjaro, kali etc..

# What is this !?
If you want to have the latest linux kernel running you often need to compile it yourself as the standard kernels are most of the time not up to date.

Also if you want to add something to your kernel then you need to recompile it with the compile options enabled for it. (For example android module like 'binder')
It makes sense to try a new stable kernel version in combination with the new module so you can profit from all the new features and updates of the newer kernel version..

You have two options to do so:

- Compile the kernel yourself step by step which needs some knowledge about it and time from start to finish..
- You could use these scripts if you like to which will type the terminal commands automated for you one after another

If you compile the kernel yourself you most likely want to update later on the same way. Thus you need to retype everything from start to finish.
The script makes it easier to redo everything very fast.

# Will this burn my computer or destroy my linux system !?
Most likely not. Linux is able to have multiple kernels installed at the same time!
If your kernel doesn't boot your linux system, restart your computer and select advanced options in grub bootmenu. Then just select the older kernel that works for you. Now you can delete unused kernels and try again if you like to..


# I need this script for other linux distros!
- You may want to have a look at the script itself with a text editor together with the wiki website of your linux distribution
- You could create a issue here and nicely ask for it - if more people are interested in it for other distros i MAY do it in my spare time...
- You could fork this repo and recreate it for your distro and pull request the new script back to here so we get a script collection from the community

# compile-kernel-from-source contains:
Scripts to be able to automate compiling procedures. Eg. if you need to add .config options to your kernel sources like android (ASHMEM, BINDER, etc.)

Can be used to address the anbox modules issue, explained in this thread: https://github.com/anbox/anbox-modules/issues/75#issuecomment-794079944

Everything is work in progress .. (Should be working though as expected now..)

# Explanation of the scripts:
createscriptenv.sh

Adds the ability to use my scripts directly in your bash/terminal by just typing the scripts name. Make sure you copy your/my scripts to your ~/.scripts folder. (I will be extending this script somehow sometime to update-check itself and offer a installation menu for my scripts. I really love creating workflow that enables to speed up things that beeing frequently used..)

cfs_nogui.sh (deprecated) and cfs_noguimerge.sh

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

# Kernel 5.18+ and 6.x+
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

Updated the scripts to patch ashmem module back into the sources. It checks if ashmem code is still present and skips the patchset if not needed.

-->> Maybe broken with latest kernels now. Dirty patches and fixes may be found at the repo from [@choff](https://github.com/choff) (Thank you so much for tracking / fixing ashmem!)

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
