#! /bin/bash

# Name: MongoDB Install
# Notes: 
# - Based on https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/
# Valid Targets: Blue team Ubuntu Bionic images

echo "Installing MongoDB..."

echo "Fetching MongoDB apt key..."
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list

echo "apt update and install..."
sudo apt update
sudo apt install -y mongodb-org

CONFIG="systemLog:
   destination: file
   path: /var/log/mongodb/mongod.log
   logAppend: true
storage:
   dbPath: /var/lib/mongodb
   journal:
      enabled: true
processManagement:
   fork: false
net:
   bindIp: 0.0.0.0
   port: 27017"

echo "Creating config file..."
echo "$CONFIG" | sudo tee /etc/mongod.conf > /dev/null

echo "Enabling service..."
sudo systemctl enable mongod

echo "Done installing MongoDB."
