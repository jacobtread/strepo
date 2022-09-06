#!/bin/bash
# SETUP SCRIPT FOR DRIVE-PI
# SOURCED: https://strepo.jacobtread.com/drivepi/setup.sh

# Update the system repositories and run upgrades
apt-get update && apt-get upgrade -y

# systemd-resolve conflicts with dnsmasq so it must be disabled
systemctl disable systemd-resolved
systemctl stop systemd-resolved
unlink /etc/resolv.conf
echo nameserver 8.8.8.8 | tee /etc/resolv.conf

# Install network manager, samba and dnsmasq
apt-get install -y network-manager samba dnsmasq

systemctl start NetworkManager
systemctl enable NetworkManager

# Stop dnsmasq network manager starts it for us
systemctl stop dnsmasq
# Prevent dnsmasq from starting on its own
systemctl disable dnsmasq

# Append hosts file entry
echo -e "\n\n127.0.0.1 drivepi.local" >> /etc/hosts
# Setup dnsmasq config
echo "address=/.local/10.42.0.1" > /etc/NetworkManager/dnsmasq-shared.d/hosts.conf

# Allow samba through the firewall
ufw allow samba

# Move to bin directory
cd /bin || exit
mkdir drivepi
cd drivepi || exit

# Download drivepi server
curl -o server https://strepo.jacobtread.com/drivepi/server
# Download the environment variables file
curl -o .env https://strepo.jacobtread.com/drivepi/env

# Replace the local samba config with the drivepi config
curl -o /etc/samba/smb.conf https://strepo.jacobtread.com/drivepi/smb.conf

# Restart samba
service smbd restart

# Execute permission on server
chmod +x server

# Reboot to apply changes
reboot