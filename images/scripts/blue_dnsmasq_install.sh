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
listen-address=127.0.0.1,10.0.10.5

# Range Hosts
address=/dns.blue/10.0.10.5
address=/mongo.blue/10.0.10.10
address=/chat.blue/10.0.10.15
address=/work.blue/10.0.10.20

address=/ad.blue/10.0.10.50
address=/web.blue/10.0.10.55
"

echo "Creating config file..."
echo "$CONFIG" | sudo tee /etc/dnsmasq.conf > /dev/null

echo "Enabling service..."
sudo systemctl enable dnsmasq

echo "Done installing up dnsmasq."
