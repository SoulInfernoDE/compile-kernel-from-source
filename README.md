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

Note:
You will be asked which version you want to compile which then will be pulled from kernel.org.
You can also look on https://kernel.org/ if you are unsure and want the latest kernel version compiled and installed.

3. After the kernel has been compiled you can install it with:
4. sudo dpkg -i ../linux-*.deb
