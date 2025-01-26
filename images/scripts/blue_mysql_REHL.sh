#!/bin/bash

# Name: MySQL Setup for REHL
# Notes: 
# - Installs MySQL
# - Creates Database schema and adds fake data
# - Creates user account within the database for webserver
# - Environment Variables:
#   - MYSQL_ROOT_PASSWORD="root"
# Valid Targets: Blue team CentOS images

# Install MySQL server
sudo dnf update -y
sudo dnf install -y mysql-server

# Start and enable MySQL service
sudo systemctl start mysqld
sudo systemctl enable mysqld

# Set MySQL root password and secure installation
MYSQL_ROOT_PASSWORD="root" 

# Run MySQL commands directly to bypass mysql_secure_installation
sudo mysql -u root <<EOF
-- Set root password
ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY 'root';

-- Apply changes
FLUSH PRIVILEGES;
EOF

# Log in to MySQL as root and create the database and table
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" <<EOF
-- Create the 'employees' database
CREATE DATABASE employees;

-- Use the 'employees' database
USE employees;

-- Create 'employee' table with specified fields
CREATE TABLE employee (
    employeeID INT PRIMARY KEY AUTO_INCREMENT,
    fname VARCHAR(50) NOT NULL,
    lname VARCHAR(50) NOT NULL,
    position VARCHAR(50),
    bank_account_number VARCHAR(20)
);

-- Insert sample data into 'employee' table
INSERT INTO employee (fname, lname, position, bank_account_number) VALUES 
('John', 'Doe', 'Manager', '123456789'),
('Jane', 'Smith', 'Developer', '987654321'),
('Bob', 'Brown', 'Analyst', '192837465'),
('Alice', 'Johnson', 'Designer', '564738291'),
('Eve', 'Wilson', 'Developer', '827364510'),
('Charlie', 'Adams', 'Manager', '736281945'),
('Grace', 'Lee', 'Accountant', '293847561'),
('Frank', 'Taylor', 'Support', '657483920'),
('Helen', 'Moore', 'Engineer', '019283746'),
('Sam', 'Martin', 'Consultant', '876543210');

-- Confirm data insertion
SELECT * FROM employee;

-- Add user account for webserver and give perms for user
CREATE USER 'web_user'@'10.0.10.10' IDENTIFIED BY 'web'; -- edit default passwords here
GRANT SELECT, INSERT, UPDATE, DELETE ON employees.* TO 'web_user'@'10.0.10.10';
EOF

echo "MySQL installation, database, and table setup complete."
