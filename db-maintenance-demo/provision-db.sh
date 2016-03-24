#!/bin/bash

#sudo apt-get update
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
  -join=192.168.33.10 \\
  -bind=192.168.33.11 \\
  -node=db0 -tag role=db >> /var/log/serf.log 2>&1
EOF
sudo mv serf-agent.conf /etc/init/serf-agent.conf
sudo start serf-agent
