#!/bin/bash

sudo apt install --yes linux-headers-$(uname -r)
#git clone https://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux/+git/jammy
cd jammy
rm drivers/hid/hid-asus.c
cp ../hid-asus.c drivers/hid/
git fetch
git checkout Ubuntu-$(cat /boot/config-$(uname -r) | grep 'CONFIG_VERSION_SIGNATURE' | sed 's/CONFIG_VERSION_SIGNATURE="Ubuntu \(.\+\?\)-generic.\+/\1/')
sed -i 's/\(EXTRAVERSION =\).\?$/\1 -generic/' Makefile
cp /boot/config-$(uname -r) ./.config
cp /usr/src/linux-headers-$(uname -r)/Module.symvers ./
make oldconfig
make scripts prepare modules_prepare
make -C . M=drivers/hid hid-asus.o
make -C . M=drivers/hid hid-asus.ko
strip --strip-debug drivers/hid/hid-asus.ko
sudo cp drivers/hid/hid-asus.ko /lib/modules/$(uname -r)/kernel/drivers/hid
sudo depmod
sudo update-initramfs -c -k $(uname -r)
cd ..
#rm -r jammy

