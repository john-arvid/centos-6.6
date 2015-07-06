#!/bin/bash

yum install httpd mysql-server php php-mysql -y

service httpd start
service mysqld start

chkconfig httpd on
chkconfig mysqld on

/usr/bin/mysql_secure_installation
