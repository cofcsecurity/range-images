#! /bin/bash

# Name: Samba Share All
# Notes: 
# - Installs Samba and configures as systemd service
# - Shares the entire file system with r/w access and no auth
# Valid Targets: Blue team RHEL based images


echo "Installing Samba..."

sudo yum install samba -y

# Enable autostart
sudo chkconfig smb on 

CONFIG="[global]
        log file = /var/log/samba/%m
        log level = 1
        server role = standalone server
[config]
        path = /etc
        read only = no
        guest ok = yes
        writable = yes
        guest account = root
"

echo "$CONFIG" | sudo tee /etc/samba/smb.conf  > /dev/null

echo "Done installing up Samba."
