#! /bin/bash

# Name: Default SSH Configuration
# Notes: 
# - Enables password and key authentication
# - Permit empty passwords
# - Permit root login
# Valid Targets: Blue team Linux images

echo "Configuring sshd..."

CONFIG="
PermitRootLogin yes

PubkeyAuthentication yes
PasswordAuthentication yes
PermitEmptyPasswords yes

ChallengeResponseAuthentication no

UsePAM yes

AcceptEnv LANG LC_*

Subsystem   sftp    /usr/lib/openssh/sftp-server
"

echo "$CONFIG" | sudo tee /etc/ssh/sshd_config > /dev/null

echo "Done configuring sshd."

sudo systemctl restart sshd

echo "restarted ssh service"
