#!/bin/bash

clear

#Install packages
yum install munin munin-node rrdtool httpd -y

#Set password
htpasswd -cm /etc/munin/munin-htpasswd muninadmin
changeme
changeme

#Start munin-node
/etc/init.d/munin-node start

#Keep it running after reboot
chkconfig munin-node on

#Restart httpd service
service httpd restart
