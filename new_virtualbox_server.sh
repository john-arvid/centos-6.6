
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
