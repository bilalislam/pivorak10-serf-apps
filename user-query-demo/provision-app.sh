#!/bin/bash

# sudo apt-get update
sudo apt-get install -y unzip
cd /tmp
wget https://releases.hashicorp.com/serf/0.7.0/serf_0.7.0_linux_amd64.zip > /dev/null 2>&1
unzip serf_0.7.0_linux_amd64.zip
sudo chmod +x serf
sudo mv serf /usr/local/bin

cd /tmp
cat <<EOF >serf-agent.conf
description "Serf agent"
start on runlevel [2345]
stop on runlevel [!2345]

exec /usr/local/bin/serf agent \\
  -log-level=debug \\
  -join 172.20.20.10 \\
  -config-dir=/etc/serf/conf.d \\
  -event-handler="query:load=uptime" \\
  -bind=$1 -node=$2 -tag role=app >> /var/log/upstart/serf-agent.log 2>&1
EOF
sudo mv serf-agent.conf /etc/init/serf-agent.conf

sudo mkdir -p /etc/serf/conf.d

sudo start serf-agent

echo $1

cat <<EOF >/etc/serf/handler.rb
#!/usr/bin/env ruby

require 'json'

ENV['SERF_EVENT_PAYLOAD'] = gets.to_s.chomp

case ENV['SERF_EVENT']
when 'user'
  # e.g. serf event deploy "{\\"version\\":\\"23424\\", \\"branch\\":\\"master\\"}"
  if ENV['SERF_USER_EVENT'] == 'deploy'
    data = JSON.parse(ENV['SERF_EVENT_PAYLOAD'])
    puts "\\ndeploys #{data['version']} from #{data['branch']}"
  end
when 'query'
  # e.g. serf event date
  # gives you current date for all node in the cluster
  puts \`date\` if ENV['SERF_QUERY_NAME'] == 'date'

  if ENV['SERF_QUERY_NAME'] == 'hello'
    puts \`echo "Hello, pivorakers!" | cowsay\`
  end
end
EOF
sudo chmod +x /etc/serf/handler.rb

cat <<EOF >/etc/serf/conf.d/config.json
{
  "event_handlers": [
    "/etc/serf/handler.rb"
  ]
}
EOF

sudo restart serf-agent
