#!/bin/bash

set -ouex pipefail

# Change kitty icon
mkdir -p /usr/local/share/icons/hicolor/256x256/apps/
curl -L https://github.com/DinkDonk/kitty-icon/blob/main/kitty-dark.png?raw=true -o /usr/local/share/icons/hicolor/256x256/apps/kitty.png

# Add kitty default config and Catppuccin-Mocha theme
mkdir -p /etc/skel/.config/kitty
cp $BUILD_FILES_DIR/configs/kitty.conf /etc/skel/.config/kitty/kitty.conf
cp $BUILD_FILES_DIR/configs/current-theme.conf /etc/skel/.config/kitty/current-theme.conf

# Make kitty the default terminal
sed -i 's/^TerminalApplication=.*/TerminalApplication=kitty/' /usr/share/kde-settings/kde-profile/default/xdg/kdeglobals
sed -i 's/^TerminalService=.*/TerminalService=kitty.desktop/' /usr/share/kde-settings/kde-profile/default/xdg/kdeglobals

# Change pinned terminal to kitty
sed -i 's/org\.gnome\.Ptyxis\.desktop/kitty.desktop/g' /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml

