#!/bin/bash

set -ouex pipefail

export RELEASE
RELEASE="$(rpm -E %fedora)"
[ -z "$RELEASE" ] && { echo "Failed to determine Fedora release"; exit 1; }

export BUILD_FILES_DIR="/tmp/build_files"

#--- Branding ---#
BRANDING_SCRIPT="${BUILD_FILES_DIR}/scripts/branding.sh"

[ ! -x "$BRANDING_SCRIPT" ] && { echo "Branding script not found or not executable"; exit 1; }

"$BRANDING_SCRIPT"

#--- Branding ---#
sed -i 's/getaurora\.dev/github\.com\/reisaraujo-miguel\/felux/' /usr/lib/os-release
sed -i 's/ublue-os\/bluefin/reisaraujo-miguel\/felux/' /usr/lib/os-release

sed -i 's/Aurora-dx/Felux/' /usr/lib/os-release
sed -i 's/Aurora/Felux/' /usr/lib/os-release
sed -i 's/aurora-dx/felux/' /usr/lib/os-release
sed -i 's/aurora/felux/' /usr/lib/os-release

sed -i 's/Aurora-dx/Felux/' /etc/yafti.yml

sed -i 's/getaurora\.dev/github\.com\/reisaraujo-miguel\/felux/' /usr/share/kde-settings/kde-profile/default/xdg/kcm-about-distrorc
sed -i 's/Aurora-DX/Felux/' /usr/share/kde-settings/kde-profile/default/xdg/kcm-about-distrorc

sed -i 's/Aurora/Felux/' /usr/libexec/ublue-flatpak-manager

sed -i 's/aurora-dx/felux/' /usr/share/ublue-os/image-info.json
sed -i 's/ublue-os\/aurora-dx/reisaraujo-miguel\/felux/' /usr/share/ublue-os/image-info.json


#--- Remove unwanted software ---#
rm -f /etc/profile.d/vscode-bluefin-profile.sh || echo "Warning: VSCode profile script not found"
rm -rf /etc/skel/.config/Code/ || echo "Warning: VSCode config directory not found"

REMOVE_PKGS_FILE="${BUILD_FILES_DIR}/remove-pkgs"

[ ! -r "$REMOVE_PKGS_FILE" ] && { echo "Error: remove-pkgs file not found or not readable"; exit 1; }

mapfile -t remove_pkgs < "$REMOVE_PKGS_FILE"
rpm-ostree uninstall "${remove_pkgs[@]}"

#--- Install rpm packages ---#
REPO_FILE="/etc/yum.repos.d/rpmfusion-nonfree-steam.repo"

[ ! -f "$REPO_FILE" ] && { echo "Steam repo file not found"; exit 1; }

sed -i "s/^enabled=.*/enabled=1/" "$REPO_FILE"

INSTALL_PKGS_FILE="${BUILD_FILES_DIR}/install-pkgs"

[ ! -r "$INSTALL_PKGS_FILE" ] && { echo "Error: install-pkgs file not found or not readable"; exit 1; }

mapfile -t install_pkgs < "$INSTALL_PKGS_FILE"

MAX_RETRIES=3
retry=0
while [ $retry -lt $MAX_RETRIES ]; do
    if rpm-ostree install "${install_pkgs[@]}"; then
        break
    fi
    
	retry=$((retry + 1))
    [ $retry -lt $MAX_RETRIES ] && sleep 5
done

[ $retry -eq $MAX_RETRIES ] && { echo "Error: Package installation failed after $MAX_RETRIES attempts"; exit 1; }

sed -i "s/^enabled=.*/enabled=0/" "$REPO_FILE"

#--- Configure desktop ---#
rm /usr/local
mkdir -p /usr/local

execute_config_script() {
    local script_name="$1"
    local script_path="${BUILD_FILES_DIR}/scripts/${script_name}"
    
    if [ ! -x "$script_path" ]; then
        echo "Error: Configuration script ${script_name} not found or not executable"
        return 1
    fi
    
    echo "Executing ${script_name}..."
    "$script_path" || { echo "Error: ${script_name} failed"; return 1; }
}

# Execute configuration scripts in parallel
for script in "configure-kitty.sh" "configure-theme.sh" "configure-zsh.sh" "set-wallpaper.sh"; do
    execute_config_script "$script" &
done

wait

# Check if any background process failed
for job in $(jobs -p); do
    wait "$job" || { echo "Error: One or more configuration scripts failed"; exit 1; }
done

SYSTEM_FILES_DIR="${BUILD_FILES_DIR}/system_files"
if [ ! -d "$SYSTEM_FILES_DIR" ]; then
    echo "Error: System files directory not found"
    exit 1
fi

if [ -z "$(ls -A "$SYSTEM_FILES_DIR")" ]; then
    echo "Warning: System files directory is empty"
else
    cp -r "$SYSTEM_FILES_DIR"/* / || { echo "Error: Failed to copy system files"; exit 1; }
fi
