!#/bin/bash

yum install -y rrdtool rrdtool-devel perl rrdtool-perl libgcrypt-devel gcc make gcc-c++ perl-ExtUtils-CBuilder perl-ExtUtils-MakeMaker perl-ExtUtils-Embed
cd /tmp
curl -s -L http://collectd.org/files/collectd-5.4.2.tar.bz2 | tar jx
cd collectd-5.4.2
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --libdir=/usr/lib --mandir=/usr/share/man --enable-cpu --enable-curl --enable-df --enable-exec --enable-load --enable-logfile --enable-memory --enable-network --enable-nginx --enable-syslog  --enable-rrdtool --enable-uptime --enable-write_graphite
make
make install
cp contrib/redhat/init.d-collectd /etc/init.d/collectd
chmod 755 /etc/init.d/collectd
chown root:root /etc/init.d/collectd
/etc/init.d/collectd start
chkconfig collectd on


# Add to /etc/collectd.conf
LoadPlugin syslog

LoadPlugin "logfile"
<Plugin "logfile">
  LogLevel "info"
  File "/var/log/collectd.log"
  Timestamp true
</Plugin>

LoadPlugin cpu
LoadPlugin interface
LoadPlugin load
LoadPlugin memory
LoadPlugin rrdtool

LoadPlugin write_graphite
<Plugin "write_graphite">
 <Carbon>
   Host "127.0.0.1"
   Port "2003"
   Prefix "collectd."
   #Postfix ""
   Protocol "tcp"
   EscapeCharacter "_"
   SeparateInstances true
   StoreRates false
   AlwaysAppendDS false
 </Carbon>
</Plugin>

/etc/init.d/collectd restart
