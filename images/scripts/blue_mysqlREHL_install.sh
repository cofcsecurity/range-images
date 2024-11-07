#! /bin/bash

#
#
#
#
#
#
#
#
#
#

sudo yum update
sudo yum upgrade

# get package to be installed for MySQL
sudo wget https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
sudo rpm -Uvh mysql80-community-release-el7-3.noarch.rpm
sudo yum install mysql-server

# start MySQL Server
sudo systemctl start mysqld


