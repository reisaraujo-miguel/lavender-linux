#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


#--- Remove unwanted software ---#

#### All my homies use neovim ####
REMOVE_PACKAGE_LIST="code"

rm /etc/profile.d/vscode-bluefin-profile.sh
rm -r /etc/skel/.config/Code/

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

#### Install kitty-terminfo ####
INSTALL_PACKAGE_LIST="$INSTALL_PACKAGE_LIST kitty-terminfo"

#### Install zsh packages ####
INSTALL_PACKAGE_LIST="$INSTALL_PACKAGE_LIST zsh-autosuggestions zsh-syntax-highlighting"

#### Package for flatpak Steam ####
INSTALL_PACKAGE_LIST="$INSTALL_PACKAGE_LIST steam-devices" # Coders also game


#### Actually install packages ####
sed -i "s/^enabled=.*/enabled=1/" /etc/yum.repos.d/rpmfusion-nonfree-steam.repo
rpm-ostree install $INSTALL_PACKAGE_LIST
sed -i "s/^enabled=.*/enabled=0/" /etc/yum.repos.d/rpmfusion-nonfree-steam.repo


#--- Install non rpm packages ---#
#HOME='/etc/skel'

# Create /usr/local folder
rm /usr/local
mkdir -p /usr/local

#### Install Kitty ####
KITTY_VERSION="0.36.4"

wget https://github.com/kovidgoyal/kitty/releases/download/v$KITTY_VERSION/kitty-$KITTY_VERSION-x86_64.txz
tar -xvf kitty-$KITTY_VERSION-x86_64.txz --directory=/usr/local --skip-old-files
rm kitty-$KITTY_VERSION-x86_64.txz

# Install LunarVim

#LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh) -y --install-dependencies


#--- Configure desktop ---#

FELUX_GITHUB_DOWNLOAD_URL=https://github.com/reisaraujo-miguel/felux/raw/refs/heads/main

#### Configure Kitty ####

# Change kitty icon
curl -L https://github.com/DinkDonk/kitty-icon/blob/main/kitty-dark.png?raw=true -o /usr/local/share/icons/hicolor/256x256/apps/kitty.png

# Add kitty default config and Catppuccin-Mocha theme
mkdir -p /etc/skel/.config/kitty
curl -L $FELUX_GITHUB_DOWNLOAD_URL/configs/kitty.conf -o /etc/skel/.config/kitty/kitty.conf
curl -L $FELUX_GITHUB_DOWNLOAD_URL/configs/current-theme.conf -o /etc/skel/.config/kitty/current-theme.conf

# Make kitty the default terminal
sed -i 's/^TerminalApplication=.*/TerminalApplication=kitty/' /usr/share/kde-settings/kde-profile/default/xdg/kdeglobals
sed -i 's/^TerminalService=.*/TerminalService=kitty.desktop/' /usr/share/kde-settings/kde-profile/default/xdg/kdeglobals

# Change pinned terminal to kitty
sed -i 's/org\.gnome\.Ptyxis\.desktop/kitty.desktop/g' /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml


#### Configure Global Theme ####
git clone --depth=1 https://github.com/catppuccin/kde catppuccin-kde
cd catppuccin-kde

curl -L $FELUX_GITHUB_DOWNLOAD_URL/scripts/install-catppuccin-theme.sh -o ./install.sh
./install.sh 2 4 1

cd ..
rm -r catppuccin-kde


#### configure zsh ####
curl -L $FELUX_GITHUB_DOWNLOAD_URL/configs/zshrc -o /etc/skel/.zshrc
curl -L $FELUX_GITHUB_DOWNLOAD_URL/configs/zshenv -o /etc/skel/.zshenv
mkdir -p /etc/skel/.config/zsh
curl -L $FELUX_GITHUB_DOWNLOAD_URL/configs/catppuccin.zsh-theme -o /etc/skel/.config/zsh/catppuccin.zsh-theme
