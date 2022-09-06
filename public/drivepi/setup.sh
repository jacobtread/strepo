#!/bin/bash
# SETUP SCRIPT FOR DRIVE-PI
# SOURCED: https://strepo.jacobtread.com/drivepi/setup.sh

# Variables to reduce repeated
repo="https://strepo.jacobtread.com/drivepi/"
path=/bin/drivepi

# Update the system repositories and run upgrades
apt-get update && apt-get upgrade -y

# systemd-resolve conflicts with dnsmasq so it must be disabled
# and replaced with the default 8.8.8.8 dns name server
# -------------------------------------------------------------
systemctl disable systemd-resolved
systemctl stop systemd-resolved
unlink /etc/resolv.conf
echo nameserver 8.8.8.8 | tee /etc/resolv.conf
# -------------------------------------------------------------

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

# Create drivepi paths
mkdir $path
cd $path || exit

# Download server environment config and additional scripts
curl -o server $repo/server
curl -o .env $repo/env
curl -o start.sh $repo/start.sh
curl -o post.sh $repo/post.sh

# Download and replace configurations for samba and daemon service
curl -o /etc/samba/smb.conf $repo/smb.conf
curl -o /etc/systemd/system/drivepi.service $repo/drivepi.service

# Execute permission on server
chmod +x server

# Reboot to apply changes
reboot