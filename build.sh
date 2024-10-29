#!/bin/bash

set -ouex pipefail

export RELEASE="$(rpm -E %fedora)"

export BUILD_FILES_DIR="/tmp/build_files"

#--- Branding ---#
BRANDING_SCRIPT="${BUILD_FILES_DIR}/scripts/branding.sh"
[ ! -x "$BRANDING_SCRIPT" ] && { echo "Branding script not found or not executable"; exit 1; }
"$BRANDING_SCRIPT"

#--- Remove unwanted software ---#
rm /etc/profile.d/vscode-bluefin-profile.sh
rm -r /etc/skel/.config/Code/

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

cp -r $BUILD_FILES_DIR/system_files/* /
