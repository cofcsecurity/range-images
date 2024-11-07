#!/bin/bash

# Define variables
SHARE_NAME="shared_folder"
SHARE_PATH="/srv/samba/$SHARE_NAME"
SAMBA_USER="sambauser"
USER_PASSWORD="password"  # Replace with your desired password
LAN_SUBNET="192.168.1.0/24"  # Replace with your LAN subnet

# Install Samba
echo "Installing Samba..."
sudo dnf install -y samba samba-client samba-common

# Enable and start the Samba service
echo "Enabling and starting Samba service..."
sudo systemctl enable smb nmb
sudo systemctl start smb nmb

# Create the shared directory
echo "Creating shared directory at $SHARE_PATH..."
sudo mkdir -p $SHARE_PATH
sudo chmod 2775 $SHARE_PATH

# Add a user for Samba
echo "Creating Samba user $SAMBA_USER..."
sudo useradd -M -s /sbin/nologin $SAMBA_USER
echo -e "$USER_PASSWORD\n$USER_PASSWORD" | sudo smbpasswd -a $SAMBA_USER
sudo smbpasswd -e $SAMBA_USER

# Set permissions for the shared directory
echo "Setting permissions for shared directory..."
sudo chown -R $SAMBA_USER:smbgroup $SHARE_PATH
sudo chmod -R 2770 $SHARE_PATH

# Configure Samba
echo "Configuring Samba..."
sudo bash -c "cat > /etc/samba/smb.conf <<EOL
[global]
   workgroup = WORKGROUP
   security = user
   map to guest = Bad User

[$SHARE_NAME]
   path = $SHARE_PATH
   valid users = @$SAMBA_USER
   guest ok = no
   writable = yes
   browsable = yes
   create mask = 0775
   directory mask = 0775
EOL"

# Adjust firewall to allow Samba traffic
echo "Configuring firewall to allow Samba traffic..."
sudo firewall-cmd --permanent --add-service=samba
sudo firewall-cmd --reload

# Restart Samba services to apply changes
echo "Restarting Samba service..."
sudo systemctl restart smb nmb

echo "Samba file share setup completed."
echo "You can access the share using the following path: \\\\server-ip\\$SHARE_NAME"
