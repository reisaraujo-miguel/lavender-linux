#!/bin/bash

set -ouex pipefail

export RELEASE="$(rpm -E %fedora)"

export BUILD_FILES_DIR="/tmp/build_files"

#--- Branding ---#
exec $BUILD_FILES_DIR/scripts/branding.sh

#--- Remove unwanted software ---#
rm /etc/profile.d/vscode-bluefin-profile.sh
rm -r /etc/skel/.config/Code/

rpm-ostree uninstall $(cat $BUILD_FILES_DIR/remove-pkgs)

#--- Install rpm packages ---#
sed -i "s/^enabled=.*/enabled=1/" /etc/yum.repos.d/rpmfusion-nonfree-steam.repo
rpm-ostree install $(cat $BUILD_FILES_DIR/install-pkgs)
sed -i "s/^enabled=.*/enabled=0/" /etc/yum.repos.d/rpmfusion-nonfree-steam.repo


# Create /usr/local folder
rm /usr/local
mkdir -p /usr/local

#--- Install non rpm packages ---#
#HOME='/etc/skel'

# Install LunarVim

#LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh) -y --install-dependencies

#--- Configure desktop ---#

exec $BUILD_FILES_DIR/scripts/configure-kitty.sh

exec $BUILD_FILES_DIR/scripts/configure-theme.sh

exec $BUILD_FILES_DIR/scripts/configure-zsh.sh

exec $BUILD_FILES_DIR/scripts/set-wallpaper.sh

