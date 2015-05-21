!#/bin/bash

# Sensu 0.18

yum install openssl redis erlang -y

cd /tmp
wget http://sensuapp.org/docs/0.18/tools/ssl_certs.tar
tar -xvf ssl_certs.tar
cd ssl_certs
./ssl_certs.sh generate

rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
rpm -Uvh https://www.rabbitmq.com/releases/rabbitmq-server/v3.5.2/rabbitmq-server-3.5.2-1.noarch.rpm
chkconfig rabbitmq-server on
service rabbitmq-server start

mkdir -p /etc/rabbitmq/ssl
cp /tmp/sensu_ca/cacert.pem /etc/rabbitmq/ssl/
cp /tmp/server/cert.pem /etc/rabbitmq/ssl/
cp /tmp/server/key.pem /etc/rabbitmq/ssl/


cat <<EOT >> /etc/rabbitmq/rabbitmq.config
[
{rabbit, [
{ssl_listeners, [5671]},
{ssl_allow_poodle_attack, true},
{ssl_options, [{cacertfile,"/etc/rabbitmq/ssl/cacert.pem"},
                {certfile,"/etc/rabbitmq/ssl/cert.pem"},
                {keyfile,"/etc/rabbitmq/ssl/key.pem"},
                {verify,verify_peer},
                {fail_if_no_peer_cert,true}]}
      ]}
].
EOT

service rabbitmq-server restart

rabbitmqctl add_vhost /sensu

rabbitmqctl add_user sensu password

rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"

cat <<EOT >> /etc/yum.repos.d/sensu.repo

[sensu]
name=sensu-main
baseurl=http://repos.sensuapp.org/yum/el/$releasever/$basearch/
gpgcheck=0
enabled=1
EOT

yum install sensu -y

mkdir -p /etc/sensu/ssl
cp /tmp/ssl_certs/client/cert.pem /etc/sensu/ssl/
cp /tmp/ssl_certs/client/key.pem /etc/sensu/ssl/

cat <<EOT >> /etc/sensu/conf.d/rabbitmq.json

{
      "rabbitmq": {
    "ssl": {
      "cert_chain_file": "/etc/sensu/ssl/cert.pem",
      "private_key_file": "/etc/sensu/ssl/key.pem"
    },
    "host": "localhost",
    "port": 5671,
    "vhost": "/sensu",
    "user": "sensu",
    "password": "password"
  }
}
EOT

cat <<EOT >> /etc/sensu/conf.d/redis.json

{
  "redis": {
    "host": "localhost",
    "port": 6379
  }
}
EOT

cat <<EOT >> /etc/sensu/conf.d/api.json

{
  "api": {
    "host": "localhost",
    "port": 4567,
    "user": "sensu",
    "password": "password"
  }
}
EOT

cat <<EOT >> /etc/sensu/conf.d/client.json

{
  "client": {
    "name": "sensu-server",
    "address": "localhost",
    "subscriptions": [ "all" ]
  }
}
EOT

# Add a memory check
cat <<EOT >> /etc/sensu/conf.d/check_memory.json
{
  "checks": {
    "memory": {
      "command": "/etc/sensu/plugins/check-mem.sh -w 128 -c 64",
      "interval": 10,
      "subscribers": [
        "test"
      ]
    }
  }
}
EOT

cat <<EOT >> /etc/sensu/conf.d/default_handler.json
{
  "handlers": {
    "default": {
      "type": "pipe",
      "command": "cat"
    }
  }
}
EOT

chown -R sensu:sensu /etc/sensu

# Turn everything on
chkconfig sensu-server on
chkconfig sensu-client on
chkconfig sensu-api on
chkconfig redis on

service redis start
service sensu-server start
service sensu-client start
service sensu-api start


# Install/Configure uchiwa

yum install uchiwa -y

mv /etc/sensu/{uchiwa.json,uchiwa.json.old}
cat <<EOT >> /etc/sensu/uchiwa.json
{
    "sensu": [
        {
            "name": "Sensu",
            "host": "127.0.0.1",
            "ssl": false,
            "port": 4567,
            "user": "<api-user>",
            "pass": "<api-password>",
            "path": "",
            "timeout": 5000
        }
    ],
    "uchiwa": {
        "user": "<uchiwa-user>",
        "pass": "<uchiwa-password>",
        "port": 3000,
        "stats": 10,
        "refresh": 10000
    }
}
EOT

chown uchiwa sensu /etc/sensu/uchiwa.json

chkconfig uchiwa on
service uchiwa start

iptables -A INPUT -p tcp -m tcp --dport 3000 -j ACCEPT
service iptables save

# You can access Uchiwa in http://sensu-server-ip:3000

