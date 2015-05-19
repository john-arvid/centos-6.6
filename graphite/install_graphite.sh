!#/bin/bash

yum install graphite-web graphite-web-selinux mysql mysql-server MySQL-python -y

/etc/init.d/mysqld start
mysql_secure_installation

# Create graphite db, username and password
mysql -e "CREATE DATABASE graphite;" -u root -p
mysql -e "GRANT ALL PRIVILEGES ON graphite.* TO 'graphite'@'localhost' IDENTIFIED BY 'graphitePW01Vxzsigavms';" -u root -p
mysql -e 'FLUSH PRIVILEGES;' -u root -p

vi /etc/graphite-web/local_settings.py

DATABASES = {
 'default': {
 'NAME': 'graphite',
 'ENGINE': 'django.db.backends.mysql',
 'USER': 'graphite',
 'PASSWORD': 'graphitePW01Vxzsigavms',
 }
}

/usr/lib/python2.6/site-packages/graphite/manage.py syncdb

/etc/init.d/httpd start

yum install python-carbon python-whisper -y

/etc/init.d/carbon-cache start

vi /etc/carbon/storage-schemas.conf

[server_load]
priority = 100
pattern = ^servers\.
retentions = 60:43200,900:350400

