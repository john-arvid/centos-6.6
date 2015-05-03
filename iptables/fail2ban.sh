#!/bin/bash

clear

#Install fail2ban
yum install fail2ban -y

#Copy config file
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

#Restart service
service fail2ban restart

#Keep service running after reboot
chkconfig fail2ban on