# compile-kernel-from-source
Script to be able to automate compiling procedures. Eg. if you need to add .config options to your kernel sources like android (ASHMEM, BINDER, etc.)

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
