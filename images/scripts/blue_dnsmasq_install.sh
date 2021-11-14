#! /bin/bash

# Script to install dnsmasq

echo "Installing dnsmasq..."

sudo apt update

sudo apt install dnsmasq -y

# Dnsmasq configuration
CONFIG="
no-resolv
server=1.1.1.1
server=8.8.8.8
"

echo "Creating config file..."
echo "$CONFIG" | sudo tee /etc/dnsmasq.conf > /dev/null

# Range host configuration
HOSTS="
127.0.0.1	localhost
::1	localhost ip6-localhost ip6-loopback
fe00::0	ip6-localnet
ff00::0	ip6-mcastprefix
ff02::1	ip6-allnodes
ff02::2	ip6-allrouters

10.0.10.5 dns.blue
10.0.10.10 mongo.blue
10.0.10.15 chat.blue
10.0.10.20 work.blue

10.0.10.50 ad.blue
10.0.10.55 web.blue
"

echo "Creating hosts file..."
echo "$HOSTS" | sudo tee /etc/hosts > /dev/null

echo "Enabling service..."
sudo systemctl enable dnsmasq

echo "Done installing up dnsmasq."
