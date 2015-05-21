!#/bin/bash

yum install -y gcc ruby ruby-devel

cd /tmp/
wget http://production.cf.rubygems.org/rubygems/rubygems-2.4.7.tgz
tar zxvf rubygems-2.4.7.tgz
cd rubygems-2.4.7.tgz
ruby setup.rb
cd..
rm -rf rubygems*

gem update --system

gem install sensu-plugin

cat <<EOT >> /etc/sensu/conf.d/check_cron.json
{
  "checks": {
    "cron": {
      "command": "/etc/sensu/plugins/check-procs.rb -p cron",
      "subscribers": [
        "production"
      ],
      "interval": 60
    }
  }
}
EOT





