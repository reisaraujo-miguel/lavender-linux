#!/bin/bash

set -ouex pipefail

# Make kitty the default terminal
sed -i 's/^TerminalApplication=.*/TerminalApplication=kitty/' /usr/share/kde-settings/kde-profile/default/xdg/kdeglobals
sed -i 's/^TerminalService=.*/TerminalService=kitty.desktop/' /usr/share/kde-settings/kde-profile/default/xdg/kdeglobals

TASKMANAGER_CONFIG="/usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml"

# Check if file exists
if [ ! -f "$TASKMANAGER_CONFIG" ]; then
    echo "Taskmanager config not found at $TASKMANAGER_CONFIG"
    exit 1
fi

# Create backup
cp "$TASKMANAGER_CONFIG" "${TASKMANAGER_CONFIG}.backup"

# Change pinned terminal to kitty
if ! sed -i 's/org\.gnome\.Ptyxis\.desktop/kitty.desktop/g' "$TASKMANAGER_CONFIG"; then
    echo "Failed to update pinned terminal"
    cp "${TASKMANAGER_CONFIG}.backup" "$TASKMANAGER_CONFIG"
    exit 1
fi

