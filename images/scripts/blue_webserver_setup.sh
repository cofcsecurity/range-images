#!/bin/bash

# Update and install necessary packages
echo "Updating system and installing necessary packages..."
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y git 
sudo apt install -y python3 
sudo apt install -y python3-pip 
sudo apt install -y python3-venv 
sudo apt install -y pkg-config


REPO_URL="https://github.com/cofcsecurity/range-images"
DEST_DIR="/opt/webapp"
echo "Cloning repository from $REPO_URL..."
git clone "$REPO_URL" /tmp/repo_temp

# Move specific web app files and remove the rest
echo "Moving web app files to $DEST_DIR and cleaning up..."
sudo mkdir -p "$DEST_DIR"
sudo mv /tmp/repo_temp/images/Webserver\ files/* "$DEST_DIR"
sudo rm -rf /tmp/repo_temp

# Navigate to the Django project directory within the web app folder
cd "$DEST_DIR/cyberclubproject" || exit

# Set up a Python virtual environment
echo "Setting up virtual environment..."
sudo python3 -m venv venv
source venv/bin/activate

# Install the Django project's dependencies
REQUIREMENTS_FILE="requirments.txt"
if [ -f "$REQUIREMENTS_FILE" ]; then
    echo "Installing dependencies from $REQUIREMENTS_FILE..."
    pip install -r "$REQUIREMENTS_FILE"
else
    echo "Error: $REQUIREMENTS_FILE not found. Please check the file path."
    exit 1
fi

# Deactivate virtual environment for systemd use
deactivate

# Create a systemd service file for the Django app
SERVICE_FILE="/etc/systemd/system/django-webapp.service"
echo "Creating systemd service at $SERVICE_FILE..."

sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=Django Web Application
After=network.target

[Service]
User=$USER
WorkingDirectory=$DEST_DIR/cyberclubproject
ExecStart=$DEST_DIR/cyberclubproject/venv/bin/python3 manage.py runserver 0.0.0.0:8000
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable, and start the Django service
echo "Enabling and starting the Django service..."
sudo chown root /etc/systemd/system/django-webapp.service
sudo chmod 777 /etc/systemd/system/django-webapp.service

sudo systemctl daemon-reload
sudo systemctl enable django-webapp
sudo systemctl start django-webapp

echo "Django web app is now set to start on system boot and is running as a service."

