#!/bin/bash

set -ouex pipefail

if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root"
    exit 1
fi

original_permissions=$(stat -c "%a" /usr/lib/os-release)

# Create temporary file
temp_file=$(mktemp)
sed -e 's/getaurora\.dev/github\.com\/reisaraujo-miguel\/felux/' \
    -e 's/ublue-os\/bluefin/reisaraujo-miguel\/felux/' \
    -e 's/\bAurora-dx\b/Felux/g' \
    -e 's/\bAurora\b/Felux/g' \
    -e 's/\baurora-dx\b/felux/g' \
    -e 's/\baurora\b/felux/g' \
    /usr/lib/os-release > "$temp_file"

# Validate changes before replacing
if grep -q "aurora\|Aurora" "$temp_file"; then
    echo "Error: Branding replacement incomplete" >&2
    rm "$temp_file"
    exit 1
fi

mv "$temp_file" /usr/lib/os-release
chmod "$original_permissions" /usr/lib/os-release

check_and_modify() {
    local file="$1"
    local pattern="$2"
    local replacement="$3"
    
    if [ -f "$file" ]; then
		original_permissions=$(stat -c "%a" "$file")
        
		# Create temporary file 
		local temp_file
		temp_file=$(mktemp)
		
		# Perform replacement 
		if ! sed "s@${pattern}@${replacement}@g" "$file" > "$temp_file"; then 
			echo "Error: Pattern replacement failed" >&2 
			rm "$temp_file"
			return 1
		fi 
		
		# Validate changes 
		if grep -q "$pattern" "$temp_file"; then 
			echo "Warning: Pattern still exists after replacement in $file" >&2
			rm "$temp_file" 
			return 1 
		fi 

		# Apply changes atomically 
		mv "$temp_file" "$file"
		chmod "$original_permissions" "$file"
    else
        echo "Warning: File $file not found, skipping modification"
		return 1
    fi
}

check_and_modify "/etc/yafti.yml" "\bAurora-dx\b" "Felux"

check_and_modify "/usr/share/kde-settings/kde-profile/default/xdg/kcm-about-distrorc" "getaurora\.dev" "github\.com\/reisaraujo-miguel\/felux" 
check_and_modify "/usr/share/kde-settings/kde-profile/default/xdg/kcm-about-distrorc" "\bAurora-DX\b" "Felux"

check_and_modify "/usr/share/ublue-os/image-info.json" "\baurora-dx\b" "felux" 
check_and_modify "/usr/share/ublue-os/image-info.json" "ublue-os\/aurora-dx" "reisaraujo-miguel\/felux"

check_and_modify "/usr/share/applications/system-update.desktop" "Aurora" "Felux"
check_and_modify "/usr/share/ublue-os/motd/tips/10-tips.md" "Aurora" "Felux"
check_and_modify "/usr/libexec/ublue-flatpak-manager" "Aurora" "Felux"
