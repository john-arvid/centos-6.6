#!/bin/bash

clear


#Turn on network
ifup eth0

#Keep it on after reboot
chkconfig network on

#Add epel repo
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

#Enable epel repo and update
yum --enablerepo=epel update -y

#Install default packages
yum install puppet facter setroubleshoot wget -y

