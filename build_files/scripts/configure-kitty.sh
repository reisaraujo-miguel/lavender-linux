#!/bin/bash

set -ouex pipefail

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

KDE_GLOBALS="/usr/share/kde-settings/kde-profile/default/xdg/kdeglobals"

# Check if file exists
if [ ! -f "$KDE_GLOBALS" ]; then
    echo "KDE globals file not found at $KDE_GLOBALS"
    exit 1
fi

# Create backup
cp "$KDE_GLOBALS" "${KDE_GLOBALS}.backup"

# Make kitty the default terminal
if ! sed -i 's/^TerminalApplication=.*/TerminalApplication=kitty/' "$KDE_GLOBALS"; then
    echo "Failed to update TerminalApplication"
    cp "${KDE_GLOBALS}.backup" "$KDE_GLOBALS"
    exit 1
fi
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

