#! /bin/bash

# (Insecurely) configures default blue team users.
# Passwords are from the rockyou wordlist.

# Admins
sudo useradd -c "Ada Lovelace" -m -G sudo -s /bin/bash alovelace
echo "alovelace:Ada123" | sudo chpasswd

sudo useradd -c "Alan Turing" -m -G sudo -s /bin/bash aturing
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