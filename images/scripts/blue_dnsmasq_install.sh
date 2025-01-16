#! /bin/bash

# Name: dnsmasq Install
# Notes: 
# - Forwards to Cloudflare and Google DNS
# - Entries for range instances (*.blue)
# Valid Targets: Blue team debian based images

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
address=/web.blue/10.0.10.10
address=/codb.blue/10.0.10.20
address=/cofs.blue/10.0.10.30
address=/mail.blue/10.0.10.40
address=/windb.blue/10.0.10.50
address=/ad.blue/10.0.10.60
address=/mtone.blue/10.0.10.70
address=/mttwo.blue/10.0.10.80


"

echo "Creating config file..."
echo "$CONFIG" | sudo tee /etc/dnsmasq.conf > /dev/null

echo "Enabling service..."
sudo systemctl enable dnsmasq

echo "Done installing up dnsmasq."
