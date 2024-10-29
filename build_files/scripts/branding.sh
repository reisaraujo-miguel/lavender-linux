#!/bin/bash

set -ouex pipefail
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root"
    exit 1
fi

backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        cp "$file" "${file}.bak-$(date +%Y%m%d%H%M%S)"
    else
        echo "Warning: File $file not found"
        return 1
    fi
}
# Backup files before modification
backup_file /usr/lib/os-release
sed -i 's/getaurora\.dev/github\.com\/reisaraujo-miguel\/felux/' /usr/lib/os-release
sed -i 's/ublue-os\/bluefin/reisaraujo-miguel\/felux/' /usr/lib/os-release

sed -i 's/\bAurora-dx\b/Felux/g' /usr/lib/os-release
sed -i 's/\bAurora\b/Felux/g' /usr/lib/os-release
sed -i 's/\baurora-dx\b/felux/g' /usr/lib/os-release
sed -i 's/\baurora\b/felux/g' /usr/lib/os-release

sed -i 's/Aurora-dx/Felux/' /etc/yafti.yml

sed -i 's/getaurora\.dev/github\.com\/reisaraujo-miguel\/felux/' /usr/share/kde-settings/kde-profile/default/xdg/kcm-about-distrorc
sed -i 's/Aurora-DX/Felux/' /usr/share/kde-settings/kde-profile/default/xdg/kcm-about-distrorc

sed -i 's/aurora-dx/felux/' /usr/share/ublue-os/image-info.json
sed -i 's/ublue-os\/aurora-dx/reisaraujo-miguel\/felux/' /usr/share/ublue-os/image-info.json

check_and_modify() {
    local file="$1"
    local pattern="$2"
    local replacement="$3"
    
    if [ -f "$file" ]; then
        sed -i "s@${pattern}@${replacement}@g" "$file"
    else
        echo "Warning: File $file not found, skipping modification"
    fi
}
check_and_modify "/usr/share/applications/system-update.desktop" "Aurora" "Felux"
check_and_modify "/usr/share/ublue-os/motd/tips/10-tips.md" "Aurora" "Felux"
check_and_modify "/usr/libexec/ublue-flatpak-manager" "Aurora" "Felux"
