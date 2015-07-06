#!/bin/bash

yum install httpd php php-mysql -y

service httpd start

chkconfig httpd on


# Install mariadb
echo "# MariaDB 10.0 CentOS repository list - created 2015-07-06 13:32 UTC
# http://mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.0/centos6-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1" >> /etc/yum.repos.d/MariaDB.repo

yum install MariaDB-server MariaDB-client --nogpgcheck -y

service mysql start

chkconfig mysql on

# Lag bruker etc
