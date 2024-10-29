#!/bin/bash

set -ouex pipefail

# Make kitty the default terminal
sed -i 's/^TerminalApplication=.*/TerminalApplication=kitty/' /usr/share/kde-settings/kde-profile/default/xdg/kdeglobals
sed -i 's/^TerminalService=.*/TerminalService=kitty.desktop/' /usr/share/kde-settings/kde-profile/default/xdg/kdeglobals

# Change pinned terminal to kitty
sed -i 's/org\.gnome\.Ptyxis\.desktop/kitty.desktop/g' /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml

