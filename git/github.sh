#!/bin/bash

clear

#Install git
yum install git -y

#Create folder and clone git
mkdir /root/scripts
cd /root/scripts
git clone https://github.com/john-arvid/centos-6.6.git

echo "Run this with your information"
echo "git config –-global user.name Your Name"
echo "git config –-global user.email youremail@mailsite.com"
