#!/bin/bash

set -ouex pipefail

<<<<<<< HEAD
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


# Make kitty the default terminal
if ! sed -i 's/^TerminalApplication=.*/TerminalApplication=kitty/' "$KDE_GLOBALS"; then
    echo "Failed to update TerminalApplication"
    exit 1
fi

sed -i 's/^TerminalService=.*/TerminalService=kitty.desktop/' "$KDE_GLOBALS"

TASKMANAGER_CONFIG="/usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml"

# Check if file exists
if [ ! -f "$TASKMANAGER_CONFIG" ]; then
    echo "Taskmanager config not found at $TASKMANAGER_CONFIG"
    exit 1
fi

# Change pinned terminal to kitty
if ! sed -i 's/org\.gnome\.Ptyxis\.desktop/kitty.desktop/g' "$TASKMANAGER_CONFIG"; then
    echo "Failed to update pinned terminal"
    exit 1
fi
=======
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
>>>>>>> 8b7d316 (refactor)

