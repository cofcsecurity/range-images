#! /bin/bash

# Name: Sudo Wordle
# Notes: 
# - Installs Wordle PAM module
# - Configures sudo to use this module
# Valid Targets: Blue team Ubuntu images

echo "Setting up Sudo Wordle..."

echo "Installing dictionary..."
sudo apt update
sudo apt install wamerican

echo "Installing PAM module..."

mkdir /tmp/pamwordle
cd /tmp/pamwordle

curl -O https://raw.githubusercontent.com/lukem1/pam-wordle/main/wordle.c

sudo apt install gcc libpam0g-dev -y
gcc -fPIC -c wordle.c

sudo ld -x --shared -o /lib/x86_64-linux-gnu/security/pam_wordle.so wordle.o

sudo rm -rf /tmp/pamwordle

echo "Configuring PAM..."

SUDO_CONFIG="
session    required   pam_env.so readenv=1 user_readenv=0
session    required   pam_env.so readenv=1 envfile=/etc/default/locale user_readenv=0
auth    required pam_unix.so
auth    required    pam_wordle.so
@include common-account
@include common-session-noninteractive
"

echo "$SUDO_CONFIG" | sudo tee /etc/pam.d/sudo > /dev/null

echo "Done configuring Sudo Wordle."
