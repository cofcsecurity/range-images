#! /bin/bash

# Name: Default User Configuration
# Notes: 
# - Creates several admin and normal users
# - Creates a hidden admin user
# - Most passwords are from the rockyou wordlist
# Valid Targets: Blue team Linux images

echo "Creating default users..."

# Root
echo "root:root" | sudo chpasswd

# Admins
sudo useradd -c "Ada Lovelace" -m -G wheel -s /bin/bash alovelace
echo "alovelace:Ada123" | sudo chpasswd

sudo useradd -c "Alan Turing" -m -G wheel -s /bin/bash aturing
echo "aturing:turing4ever" | sudo chpasswd

sudo useradd -m -G wheel -s /bin/bash gold
echo "gold:range" | sudo chpasswd

# Normal Users
sudo useradd -c "Fred Brooks" -m -s /bin/bash fbrooks
echo "fbrooks:Brooks!" | sudo chpasswd

sudo useradd -c "Ron Rivest" -m -s /bin/bash rrivest
echo "rrivest:RSA123" | sudo chpasswd

sudo useradd -c "Grace Hopper" -m -s /bin/bash ghopper
echo "ghopper:!hopper23!" | sudo chpasswd

sudo useradd -c "Linus Torvalds" -m -s /bin/bash ltorvalds
echo "ltorvalds:linuxman" | sudo chpasswd

sudo useradd -c "Ida Rhodes" -m -s /bin/bash irhodes
echo "irhodes:Ida12101989" | sudo chpasswd

echo "Done creating default users."

# Hidden Users
sudo useradd -r -c "System Processes" -m -G wheel -s /bin/bash sysproc
echo "sysproc:backdoor" | sudo chpasswd
