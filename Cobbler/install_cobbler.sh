#!/bin/bash

# Install everything needed for cobbler, need testing repo to get working version of cobbler

yum install cobbler cobbler-web httpd -y --enablerepo=epel-testing

# Set Selinux in permissive mode
setenforce permissive

# Check that everything is ok with cobbler, wait for cobbler to start, if complaining about httpd.
cobbler check

# Fix everything that is needed for cobbler

setsebool -P cobbler_can_network_connect 1
cobbler get-loaders
yum install cman pykickstart debmirror selinux-policy-devel
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 69 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 25151 -j ACCEPT

service iptables save
