#!/bin/bash

# Install dependencies
yum install -y wget httpd php gcc glibc glibc-common gd gd-devel make net-snmp

# Download nagios and plugins to tmp folder
cd /tmp
wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.0.8.tar.gz
wget http://nagios-plugins.org/download/nagios-plugins-2.0.3.tar.gz

# Add user and group
useradd nagios
groupadd nagcmd
usermod -a -G nagcmd nagios

# Unpack the downloaded files
tar zxvf nagios-4.0.8.tar.gz
tar zxvf nagios-plugins-2.0.3.tar.gz

# Configure and install
cd nagios-4.0.8
./configure --with-command-group=nagcmd

make all
make install
make install-init
make install-config
make install-commandmode
make install-webconf

# Copy eventhandlers (not configured!)
cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/
chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers

# Check nagios config and start nagios
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
/etc/init.d/nagios start

# Start apache
/etc/init.d/httpd start

# Add user and password for web-access (need user input)
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

# Configure and install plugins
cd /tmp/nagios-plugins-2.0.3
./configure --with-nagios-user=nagios --with-nagios-group=nagios
make
make install

# Make sure nagios and apache starts on boot
chkconfig --add nagios
chkconfig --level 35 nagios on
chkconfig --add httpd
chkconfig --level 35 httpd on

# Open up for port 80 to the server
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables-save | sudo tee /etc/sysconfig/iptables
service iptables restart

chcon -R -t httpd_sys_content_t /usr/local/nagios

# Done?
