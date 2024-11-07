# an install script to create a fake simple database with mySQL on REHL
# designed to help those learn to harded mySQL servers 

#!/bin/bash

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
EOF

echo "MySQL installation, database, and table setup complete."
