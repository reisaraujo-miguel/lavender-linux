#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

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
rm /usr/local
mkdir -p /usr/local

# Install LunarVim

#LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh) -y --install-dependencies


#--- Configure desktop ---#
BUILD_FILES_DIR="/tmp/build_files"

#### Configure Kitty ####

# Change kitty icon
mkdir -p /usr/local/share/icons/hicolor/256x256/apps/
curl -L https://github.com/DinkDonk/kitty-icon/blob/main/kitty-dark.png?raw=true -o /usr/local/share/icons/hicolor/256x256/apps/kitty.png

# Add kitty default config and Catppuccin-Mocha theme
mkdir -p /etc/skel/.config/kitty
cp $BUILD_FILES_DIR/configs/kitty.conf /etc/skel/.config/kitty/kitty.conf
cp $BUILD_FILES_DIR/configs/current-theme.conf /etc/skel/.config/kitty/current-theme.conf

# Make kitty the default terminal
sed -i 's/^TerminalApplication=.*/TerminalApplication=kitty/' /usr/share/kde-settings/kde-profile/default/xdg/kdeglobals
sed -i 's/^TerminalService=.*/TerminalService=kitty.desktop/' /usr/share/kde-settings/kde-profile/default/xdg/kdeglobals

# Change pinned terminal to kitty
sed -i 's/org\.gnome\.Ptyxis\.desktop/kitty.desktop/g' /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml

#### Configure Global Theme ####
git clone --depth=1 https://github.com/catppuccin/kde catppuccin-kde
cd catppuccin-kde
cp $BUILD_FILES_DIR/scripts/install-catppuccin-theme.sh ./install.sh
./install.sh 2 4 1
cd ..
rm -r catppuccin-kde

#### configure zsh ####
rm /etc/skel/.zshrc
rm /etc/skel/.zprofile
cp $BUILD_FILES_DIR/configs/zshenv /etc/skel/.zshenv

mkdir -p /etc/skel/.config/zsh/theme
cp $BUILD_FILES_DIR/configs/zsh/themes/catppuccin.zsh-theme /etc/skel/.config/zsh/theme/catppuccin.zsh-theme

cp $BUILD_FILES_DIR/configs/zsh/zlogin /etc/skel/.config/zsh/.zlogin
cp $BUILD_FILES_DIR/configs/zsh/zlogout /etc/skel/.config/zsh/.zlogout
cp $BUILD_FILES_DIR/configs/zsh/zprofile /etc/skel/.config/zsh/.zprofile
cp $BUILD_FILES_DIR/configs/zsh/zshrc /etc/skel/.config/zsh/.zshrc

mkdir -p /etc/wallpaper
cp $BUILD_FILES_DIR/wallpaper/cat-wallpaper.jpg /etc/wallpaper/cat-wallpaper.jpg
echo "[Containments][1][Wallpaper][org.kde.image][General]" >> /etc/skel/.config/plasmarc
echo "Image=/etc/wallpaper/cat-wallpaper.jpg" >> /etc/skel/.config/plasmarc
echo "PreviewImage=/etc/wallpaper/cat-wallpaper.jpg" >> /etc/skel/.config/plasmarc
echo "SlidePaths=/usr/share/wallpapers/" >> /etc/skel/.config/plasmarc
