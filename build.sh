#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

#--- Remove unwanted software ---#

#### All my homies use neovim ####
REMOVE_PACKAGE_LIST="code"

#### Remove Ptyxis ####
# I don't like software redundancy. Kitty will be de default terminal,
# Ptyxis can be installed as flatpak. When Ptyxis fully support ligatures
# and font features I'll consider swicthing.
REMOVE_PACKAGE_LIST="$REMOVE_PACKAGE_LIST ptyxis"


#### Actually remove packages ####
rpm-ostree uninstall $REMOVE_PACKAGE_LIST


#--- Install rpm packages ---#

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

#### Install neovim ####
INSTALL_PACKAGE_LIST="neovim cargo" # cargo is a LunarVim dependency

#### Install some packages necessary for LSP ####
INSTALL_PACKAGE_LIST="$INSTALL_PACKAGE_LIST clang-tools-extra"

#### Install Git Delta ####
INSTALL_PACKAGE_LIST="$INSTALL_PACKAGE_LIST git-delta"

#### Install kitty ####
INSTALL_PACKAGE_LIST="$INSTALL_PACKAGE_LIST kitty"

#### Install zsh packages ####
INSTALL_PACKAGE_LIST="$INSTALL_PACKAGE_LIST zsh-autosuggestions zsh-syntax-highlighting"

#### Package for flatpak Steam ####
INSTALL_PACKAGE_LIST="$INSTALL_PACKAGE_LIST steam-devices" # Coders also game

#### cli utilities ####
INSTALL_PACKAGE_LIST="$INSTALL_PACKAGE_LIST eza"

#### Actually install packages ####
sed -i "s/^enabled=.*/enabled=1/" /etc/yum.repos.d/rpmfusion-nonfree-steam.repo
rpm-ostree install $INSTALL_PACKAGE_LIST
sed -i "s/^enabled=.*/enabled=0/" /etc/yum.repos.d/rpmfusion-nonfree-steam.repo


#--- Install non rpm packages ---#
#HOME='/etc/skel'

# Create /usr/local folder
#rm /usr/local
#mkdir -p /usr/local

# Install LunarVim

#LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh) -y --install-dependencies

