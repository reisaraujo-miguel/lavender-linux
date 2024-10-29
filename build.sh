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

#--- Remove unwanted software ---#
rm -f /etc/profile.d/vscode-bluefin-profile.sh || echo "Warning: VSCode profile script not found"
rm -rf /etc/skel/.config/Code/ || echo "Warning: VSCode config directory not found"

mapfile -t remove_pkgs < "$BUILD_FILES_DIR/remove-pkgs"
rpm-ostree uninstall "${remove_pkgs[@]}"

#--- Install rpm packages ---#
REPO_FILE="/etc/yum.repos.d/rpmfusion-nonfree-steam.repo"
[ ! -f "$REPO_FILE" ] && { echo "Steam repo file not found"; exit 1; }
sed -i "s/^enabled=.*/enabled=1/" "$REPO_FILE"

mapfile -t install_pkgs < "$BUILD_FILES_DIR/install-pkgs"
rpm-ostree install "${install_pkgs[@]}"

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

execute_config_script "configure-kitty.sh"
execute_config_script "configure-theme.sh"
execute_config_script "configure-zsh.sh"
execute_config_script "set-wallpaper.sh"

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
