#!/bin/bash

echo "Install LAMP first"

# Download nagiosql
cd /tmp/
wget http://vorboss.dl.sourceforge.net/project/nagiosql/nagiosql/NagiosQL%203.2.0/nagiosql_320_service_pack_2_additional_fixes_only.zip
wget http://kent.dl.sourceforge.net/project/nagiosql/nagiosql/NagiosQL%203.2.0/nagiosql_320.tar.gz

# Unpack nagiosql
unzip nagiosql_320_service_pack_2_additional_fixes_only.zip
tar zxvf nagiosql_320.tar.gz

# Rename folder
mv /tmp/NagiosQL_3.2.0_SP2 /tmp/nagiosqlsp2


mkdir /etc/nagiosql
mkdir /etc/nagiosql/hosts
mkdir /etc/nagiosql/services
mkdir /etc/nagiosql/backup
mkdir /etc/nagiosql/backup/hosts
mkdir /etc/nagiosql/backup/services

# Edit /usr/local/nagios/etc/nagios.cfg
# Comment out all cfg_file and cfg_dir
# Add these (the END means comment block)
: <<'END'
cfg_file=/etc/nagiosql/contacttemplates.cfg
cfg_file=/etc/nagiosql/contactgroups.cfg
cfg_file=/etc/nagiosql/contacts.cfg
cfg_file=/etc/nagiosql/timeperiods.cfg
cfg_file=/etc/nagiosql/commands.cfg
cfg_file=/etc/nagiosql/hostgroups.cfg
cfg_file=/etc/nagiosql/servicegroups.cfg
cfg_file=/etc/nagiosql/hosttemplates.cfg
cfg_file=/etc/nagiosql/servicetemplates.cfg
cfg_file=/etc/nagiosql/servicedependencies.cfg
cfg_file=/etc/nagiosql/serviceescalations.cfg
cfg_file=/etc/nagiosql/hostdependencies.cfg
cfg_file=/etc/nagiosql/hostescalations.cfg
cfg_file=/etc/nagiosql/hostextinfo.cfg
cfg_file=/etc/nagiosql/serviceextinfo.cfg
cfg_dir=/etc/nagiosql/hosts
cfg_dir=/etc/nagiosql/services
END

# Change permissions
chmod 664 /usr/local/nagios/etc/cgi.cfg
chmod 664 /usr/local/nagios/etc/nagios.cfg
chmod -R 6755 /etc/nagiosql
chown -R apache.nagios /etc/nagiosql
chown nagios.apache /usr/local/nagios/bin/nagios
chmod 750 /usr/local/nagios/bin/nagios

# Update nagiosql files
rsync -av /tmp/nagiosqlsp2/ /tmp/nagiosql32/
mkdir /usr/local/nagios/share/webadmin
mv /tmp/nagiosql32/* /usr/local/nagios/share/webadmin/

# SELINUX
chcon -R -t httpd_sys_content_t /usr/local/nagios/share/



