#!/bin/bash
# From https://www.digitalocean.com/community/tutorials/how-to-install-mediawiki-on-centos-7

yum install php-xml php-intl php-gd texlive php-xcache -y

cd /tmp/

curl -O http://releases.wikimedia.org/mediawiki/1.25/mediawiki-1.25.1.tar.gz

tar xvzf mediawiki-*.tar.gz

mv mediawiki-1.25.1/* /var/www/html

mysql -u root

CREATE DATABASE my_wiki;

GRANT INDEX, CREATE, SELECT, INSERT, UPDATE, DELETE, ALTER, LOCK TABLES ON my_wiki.* TO 'sammy'@'localhost' IDENTIFIED BY 'password';

FLUSH PRIVILEGES;

exit

