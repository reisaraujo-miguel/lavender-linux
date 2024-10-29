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

rpm-ostree uninstall $(cat $BUILD_FILES_DIR/remove-pkgs)

#--- Install rpm packages ---#
sed -i "s/^enabled=.*/enabled=1/" /etc/yum.repos.d/rpmfusion-nonfree-steam.repo
rpm-ostree install $(cat $BUILD_FILES_DIR/install-pkgs)
sed -i "s/^enabled=.*/enabled=0/" /etc/yum.repos.d/rpmfusion-nonfree-steam.repo

#--- Configure desktop ---#
rm /usr/local
mkdir -p /usr/local

eval $BUILD_FILES_DIR/scripts/configure-kitty.sh

eval $BUILD_FILES_DIR/scripts/configure-theme.sh

eval $BUILD_FILES_DIR/scripts/configure-zsh.sh

eval $BUILD_FILES_DIR/scripts/set-wallpaper.sh

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
