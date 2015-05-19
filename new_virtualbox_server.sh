
# Install required packages
yum install gcc kernel-devel make -y

# You actually need to reboot a linux server sometimes
reboot

# Click: Devices/Install Guest Additions... 
 
# Mount the ISO image with the guest additions
mkdir /media/cdrom
mount /dev/cdrom /media/cdrom
 
# Install guest additions
/cdrom/VBoxLinuxAdditions.run

# Unmount guestadditions
umount /media/cdrom

# Add shared folder, Click: Devices/Shared Folder...
# Auto-Mount and Make Permanent




# Make sure eth0 is on when rebooting
# /etc/sysconfig/network-scripts/ifcfg-eth0
# ONBOOT=yes
# ^Make this with sed later

