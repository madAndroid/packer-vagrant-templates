#!/bin/bash

# Removing leftover leases and persistent rules
echo "cleaning up dhcp leases"
rm /var/lib/dhcp/*

# Make sure Udev doesn't block our network
echo "cleaning up udev rules"
rm /etc/udev/rules.d/70-persistent-net.rules
mkdir /etc/udev/rules.d/70-persistent-net.rules
rm -rf /dev/.udev/
rm /lib/udev/rules.d/75-persistent-net-generator.rules

echo "Adding a 2 sec delay to the interface up, to make the dhclient happy"
echo "pre-up sleep 2" >> /etc/network/interfaces

# Prevent fsck on boot
rootfs=`mount | grep root | cut -d ' ' -f 1,1`
bootfs=`mount | grep boot | cut -d ' ' -f 1,1`
/sbin/tune2fs -c -1 $rootfs
/sbin/tune2fs -c -1 $bootfs

# Reboot machine after bootstrap so that the latest kernel is running.
# This makes life easier when we come to compile the VMWare guest tools.
# The sleep is to prevent packer running the next shell provisioner before
# the box has rebooted.
reboot
sleep 120
