#! /bin/bash

# NOTE: The LXDE install has an interactive step,
# thus this script is unsuitable for Packer builds.

# Name: LXDE + TightVNC Install
# Notes: 
#  - Usage: ./tightvnc_install.sh
#  - Environment vars:
#    - USER
#      - The user to setup xstartup for. If left blank
#        root will be assumed.
#    - LOCAL
#      - If set to true TightVNC will be configured to
#        listen on localhost only.
# Valid Targets: Debian based images

if [[ ! -v USER ]]
then
USER="root"
fi

if [ "$USER" = root ]
then
XPATH="/root/.vnc"
else
XPATH="/home/$USER/.vnc"
fi

echo "Setting up LXDE and TightVNC server..."

echo "Install requirements..."
sudo apt update
sudo apt install lxde lxdm xorg tightvncserver -y


# Create xstartup script
XSTARTUP="#!/bin/bash
xsetroot -solid grey
vncconfig -iconic &
x-terminal-emulator -geometry 80x24+10+10 -ls -title \"\$VNCDESKTOP Desktop\" &
startlxde &"

echo "Creating $XPATH/xstartup..."
if [ ! -d "$XPATH" ]; then
  mkdir $XPATH
fi

echo "$XSTARTUP" | sudo tee "${XPATH}/xstartup" > /dev/null
sudo chown -R $USER $XPATH
sudo chmod 700 "${XPATH}/xstartup"

# Set vnc password
echo "set-me" | vncpasswd -f > "${XPATH}/passwd"
sudo chmod 0600 "${XPATH}/passwd"

# Configure systemd to run TightVNC server

COMMAND="/usr/bin/tightvncserver -geometry 1290x800 :1"
if [ "$LOCAL" = true ]
then
COMMAND="/usr/bin/tightvncserver -localhost -geometry 1290x800 :1"
fi

SERVICE="[Unit]
Description=TightVNC Service
[Service]
ExecStart=su - $USER -c \"$COMMAND\"
Type=simple
Restart=always
[Install]
WantedBy=multi-user.target"

# Create service file
echo "Configuring as Systemd service..."
echo "$SERVICE" | sudo tee /etc/systemd/system/lxvnc.service > /dev/null
sudo chown root /etc/systemd/system/lxvnc.service
sudo chmod 777 /etc/systemd/system/lxvnc.service

# Enable service
echo "Enabling service..."
sudo systemctl enable lxvnc.service
sudo systemctl start lxvnc.service

echo "Done setting up VNC."
