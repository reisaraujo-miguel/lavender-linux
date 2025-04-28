#!/bin/bash

set -ouex pipefail

# Create required directories
mkdir -p /etc/skel/.config/hypr
mkdir -p /etc/skel/.config/waybar
mkdir -p /etc/skel/.config/dunst
mkdir -p /etc/skel/.config/rofi

chmod +x /usr/share/xdg/autostart/hyprland-portal.desktop
chmod +x /usr/libexec/bluefin-dx-groups
chmod +x /usr/libexec/bluefin-incus
chmod +x /usr/libexec/bluefin-dx-kvmfr-setup
