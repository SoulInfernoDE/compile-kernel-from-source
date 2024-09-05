____________________________________
UM790PRO VERSION
____________________________________
# For which linux distributions are these scripts ?

Actually only for Ubuntu / Debian based linux systems
I have not planned to update the scripts for other linux systems like manjaro, kali etc..

# What is this !?
If you want to have the latest linux kernel running you often need to compile it yourself as the standard kernels are most of the time not up to date.
This one is specifically polished for minisforum um790pro but may work also for others (better to change .config-fragment LOCALVERSION=-global-generic or something like that)

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
Scripts to be able to automate compiling procedures. Eg. if you need to add .config options to your kernel sources like android (BINDER, etc.)


Everything is work in progress .. (Should be working though as expected now..)

# Explanation of the scripts:

pullukuu

It automates the steps to compile your kernel on ubuntu/debian based systems without tools like ukuu (such as linux mint for example which is what i play around with at the moment) while asking
the user some questions interactively

# Instructions:

1. Download the pullukuu and signukuu script and make it executable if it's not:

chmod +x pullukuu signukuu

2. execute it:

./pullukuu

and if you have secure boot you need to sign your kernel after building and installing it

./signukuu

# Note:
You will be asked which version you want to compile which then will be pulled from kernel.org.
You can also look on https://kernel.org/ if you are unsure and want the latest kernel version compiled and installed.

3. After the kernel has been compiled you can also manually install it with:
sudo dpkg -i ../linux-*.deb

4. After installing the kernel you may need to sign it for booting with UEFI / Secure Boot.
-->> Go Here for a script which can assist you: [https://github.com/SoulInfernoDE/compile-kernel-from-source#generate-mok-file-and-sign-your-kernel-with-automation-script](https://github.com/SoulInfernoDE/compile-kernel-from-source/tree/um790pro?tab=readme-ov-file#generate-mok-file-and-sign-your-kernel-with-automation-script)
5. Base reading article is: https://github.com/jakeday/linux-surface/blob/3267e4ea1f318bb9716d6742d79162de8277dea2/SIGNING.md

::: Summary what will be done :::
These are the steps you need to take:
- Create a configuration file named MOK
- enroll the MOK file with a password you choose into your linux and bios
- sign your newly installed kernel with it
- reboot the system - you will get a blue MOKManager screen
- select enroll, enroll key and enter your password which you had choosen

-->> Your custom MOK signing key is now installed in your bios, your kernel is signed with it and your linux system is verifying it



# Generate MOK file and sign your kernel with automation script:

1. Download the signkernel script and make it executable if it's not:

chmod +x signukuu

2. execute it:
./signukuu

3. - You will be asked to generate key files and enroll/import them into your linux / bios.
   - If you already created the key files once and did set a password, you can say "NO" and
     only sign your fresh installed custom kernel. Note that you need to do this also after
     creating your key files and before rebooting.
     Otherwise you cannot boot your unsigned kernel.


# Please report any bugs or errors found..
