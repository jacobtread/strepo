#!/bin/bash
# POST-SETUP SCRIPT FOR DRIVE-PI
# SOURCED: https://strepo.jacobtread.com/drivepi/post.sh

# Enable the drivepi service
service drivepi enable
service drivepi start

# RASPBIAN NETWORK FIX ( https://gist.github.com/jjsanderson/ab2407ab5fd07feb2bc5e681b14a537a)
# --------------------------------------------------------------------
# Tell dhcpcd to ignore wlan0
echo "denyinterfaces wlan0" >> /etc/dhcpcd.conf
# Configure Network Manager to control wlan0 and assume dhcp duties
echo -e "[main]\nplugins=ifupdown,keyfile\ndhcp=internal\n\n[ifupdown]\nmanaged=true" > /etc/NetworkManager/NetworkManager.conf
# Ensure radio is enabled
nmcli radio wifi on
# --------------------------------------------------------------------

