#! /bin/bash

# Script to install MongoDB
# Based on: https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/

echo Installing MongoDB

echo Fetching MongoDB apt key...
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list

sudo apt update -y
sudo apt install -y mongodb-org

sudo systemctl enable mongod
