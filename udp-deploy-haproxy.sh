#!/bin/bash

# Author: Shi-Ken Don <shiken.don@gmail.com>
# Source: https://git.io/deploy-haproxy.sh
# License: MIT

EXPOSED_PORT=${EXPOSED_PORT:-25565}
BACKEND_HOST=${BACKEND_HOST:-1.2.3.4:25565}

set -e
sudo -V > /dev/null || apt -y install sudo

sudo apt -y install haproxy

if [[ ! -e /etc/haproxy/haproxy.cfg.bak ]]; then
  sudo /bin/cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bak
fi

sudo /bin/cp /etc/haproxy/haproxy.cfg.bak /etc/haproxy/haproxy.cfg

cat <<END | sudo tee -a /etc/haproxy/haproxy.cfg

listen minecraft
	bind :${EXPOSED_PORT}
	mode udp
	balance leastconn
	option udp-check
	server minecraft1 ${BACKEND_HOST} send-proxy
END

sudo systemctl enable haproxy
sudo systemctl restart haproxy
