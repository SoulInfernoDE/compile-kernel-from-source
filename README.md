# compile-kernel-from-source
Scripts to be able to automate compiling procedures. Eg. if you need to add .config options to your kernel sources like android (ASHMEM, BINDER, etc.)

Can be used to address the anbox modules issue, explained in this thread: https://github.com/anbox/anbox-modules/issues/75#issuecomment-794079944

Everything is work in progress ..


Instructions:

1. Download the nogui or gui script and make it executable if it's not:

chmod +x cfs_gui.sh cfs_nogui.sh

2. execute it:

./cfs_gui.sh
or
./cfs_nogui.sh
or
./cfs_noguimerge.sh

Note:
You will be asked which version you want to compile which then will be pulled from kernel.org.
You can also look on https://kernel.org/ if you are unsure and want the latest kernel version compiled and installed.

3. After the kernel has been compiled you can install it with:
sudo dpkg -i ../linux-*.deb

4. After installing the kernel you may need to sign it for booting with UEFI / Secure Boot - adding this to the automation tool will be done when i have time. Base reading article is: https://github.com/jakeday/linux-surface/blob/3267e4ea1f318bb9716d6742d79162de8277dea2/SIGNING.md

These are the steps you need to take:
- Create a configuration file named MOK
- enroll the MOK file with a password you choose into your linux and bios
- sign your newly installed kernel with it
- reboot the system - you will get a blue MOKManager screen
- select enroll, enroll key and enter your password which you had choosen

-->> Your custom MOK signing key is now installed in your bios, your kernel is signed with it and your linux system is verifying it



Generate and sign your kernel with automation script:

1. Download the signkernel script and make it executable if it's not:

chmod +x cfs_signkernel.sh

2. execute it:
./cfs_signkernel.sh

3. - You will be asked to generate key files and enroll/import them into your linux / bios.
   - If you already created the key files once and did set a password, you can say "NO" and
     only sign your fresh installed custom kernel. Note that you need to do this also after
     creating your key files and before rebooting.
     Otherwise you cannot boot your unsigned kernel.


Please report any bugs or errors found..
