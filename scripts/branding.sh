#!/bin/bash

set -ouex pipefail

if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root"
    exit 1
fi

sed -i -e 's/projectbluefin\.io/github\.com\/reisaraujo-miguel\/felux/' \
    -e 's/ublue-os\/bluefin/reisaraujo-miguel\/felux/' \
    -e 's/\bBluefin-dx\b/Felux/g' \
    -e 's/\bBluefin\b/Felux/g' \
    -e 's/\bbluefin-dx\b/felux/g' \
    -e 's/\bbluefin\b/felux/g' \
    /usr/lib/os-release

# Validate changes before replacing
if grep -Eq "bluefin|Bluefin" /usr/lib/os-release; then
    echo "Error: Branding replacement incomplete" >&2
    exit 1
fi

check_and_modify() {
    local file="$1"
    local pattern="$2"
    local replacement="$3"

    if [ -f "$file" ]; then
        # Perform replacement
        if ! sed -i "s@${pattern}@${replacement}@g" "$file"; then
            echo "Error: Pattern replacement failed" >&2
            return 1
        fi

        # Validate changes
        if grep -Eq "$pattern" "$file"; then
            echo "Warning: Pattern still exists after replacement in $file" >&2
            return 1
        fi
    else
        echo "Warning: File $file not found, skipping modification"
        return 1
    fi
}

check_and_modify "/usr/share/ublue-os/image-info.json" "\bbluefin-dx\b" "felux"
check_and_modify "/usr/share/ublue-os/image-info.json" "ublue-os\/bluefin-dx" "reisaraujo-miguel\/felux"

check_and_modify "/usr/share/applications/system-update.desktop" "Bluefin" "Felux"
check_and_modify "/usr/share/ublue-os/motd/tips/10-tips.md" "Bluefin" "Felux"
check_and_modify "/usr/libexec/ublue-flatpak-manager" "Bluefin" "Felux"
check_and_modify "/usr/share/ublue-os/motd/20-bluefin.md" "Bluefin" "Felux"
check_and_modify "/usr/share/ublue-os/motd/template.md" "Bluefin" "Felux"
