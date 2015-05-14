
# Install required packages
yum install yum install gcc kernel-devel make -y

# You acctually need to reboot a linux server sometimes
reboot

# Click: Devices/Install Guest Additions... 
 
# Mount the ISO image with the guest additions
mkdir /media/cdrom
mount /dev/cdrom /media/cdrom
 
# Install guest additions
/cdrom/VBoxLinuxAdditions.run


# Make sure eth0 is on when rebooting
# /etc/sysconfig/network-scripts/ifcfg-eth0
# ONBOOT=yes
# ^Make this with sed later

