!#/bin/bash

curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -L get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm reload
rvm requirements run
rvm install 2.2.2


gem update --system

gem install sensu-plugin

wget -O /etc/sensu/plugins/check-procs.rb http://sensuapp.org/docs/0.18/files/check-procs.rb
chmod +x /etc/sensu/plugins/check-procs.rb

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

wget -O /etc/sensu/plugins/cpu-metrics.rb http://sensuapp.org/docs/0.18/files/cpu-metrics.rb
chmod +x /etc/sensu/plugins/cpu-metrics.rb

cat <<EOT >> /etc/sensu/conf.d/cpu_metrics.json
{
  "checks": {
    "cpu_metrics": {
      "type": "metric",
      "command": "/etc/sensu/plugins/cpu-metrics.rb",
      "subscribers": [
        "production"
      ],
      "interval": 10,
      "handler": "debug"
    }
  }
}
EOT

wget -O /etc/sensu/plugins/check-data.rb http://sensuapp.org/docs/0.18/files/check-data.rb
chmod +x /etc/sensu/plugins/check-data.rb




