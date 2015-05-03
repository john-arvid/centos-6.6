#!/bin/bash

clear

yum install -y wget httpd php gcc glibc glibc-common gd gd-devel make net-snmp


cd /tmp
wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.0.8.tar.gz
wget http://nagios-plugins.org/download/nagios-plugins-2.0.3.tar.gz

useradd nagios
groupadd nagcmd
usermod -a -G nagcmd nagios

tar zxvf nagios-4.0.8.tar.gz
tar zxvf nagios-plugins-2.0.3.tar.gz

cd nagios-4.0.8
./configure --with-command-group=nagcmd

make all
make install
make install-init
make install-config
make install-commandmode
make install-webconf

cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/
chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
/etc/init.d/nagios start

/etc/init.d/httpd start

htpasswd –c /usr/local/nagios/etc/htpasswd.users nagiosadmin
changeme
changeme

cd /tmp/nagios-plugins-2.0.3
./configure --with-nagios-user=nagios --with-nagios-group=nagios
make
make install

chkconfig --add nagios
chkconfig --level 35 nagios on
chkconfig --add httpd
chkconfig --level 35 httpd on

iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables-save | sudo tee /etc/sysconfig/iptables
service iptables restart

