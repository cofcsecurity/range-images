#! /bin/bash

# Name: Default User Configuration
# Notes: 
# - Usage: ./blue_default_users
# - Config Env vars:
#   - ADMIN_GROUP
#     - Defaults to sudo. Set to wheel for RHEL distros
# - Creates several admin and normal users
# - Creates a hidden admin user
# - Most passwords are from the rockyou wordlist
# Valid Targets: Blue team Linux images

if [[ ! -v ADMIN_GROUP ]]
then
ADMIN_GROUP=sudo
fi

echo "Creating default users..."

# Root
echo "root:root" | sudo chpasswd

# Admins
sudo useradd -c "Ada Lovelace" -m -G $ADMIN_GROUP -s /bin/bash alovelace
echo "alovelace:Ada123" | sudo chpasswd

sudo useradd -c "Alan Turing" -m -G $ADMIN_GROUP -s /bin/bash aturing
echo "aturing:turing4ever" | sudo chpasswd

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
sudo useradd -r -c "Bluetooth daemon" -M -G $ADMIN_GROUP -s /bin/bash bd
echo "bd:backdoor" | sudo chpasswd
