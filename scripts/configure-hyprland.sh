#!/bin/bash

set -ouex pipefail

# set home
HOME=/tmp

chmod +x /usr/share/xdg/autostart/hyprland-portal.desktop

# Install Hyprland

dnf5 install fuzzel hyprland hyprland-qtutils xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-hyprland playerctl swww yad scdoc ydotool upower brightnessctl hyprpicker hyprutils hyprwayland-scanner hyprlock wlogout hypridle hyprlang-devel libsass-devel libsass gnome-themes-extra adw-gtk3-theme qt5ct qt6-qtwayland qt5-qtwayland blueprint-compiler python3-libsass aylurs-gtk-shell kvantum kvantum-qt5 -y

# Install ReGreet
dnf5 install greetd -y

chmod -R go+r /etc/greetd/

systemctl enable greetd.service

cd /tmp

git clone https://github.com/rharish101/ReGreet.git
cd ReGreet

cargo build --all-features --release
cp target/release/regreet /usr/bin

sed -i 's/greeter/greetd/g' ./systemd-tmpfiles.conf

cp ./systemd-tmpfiles.conf /etc/tmpfiles.d/regreet.conf

systemd-tmpfiles --create "$PWD/systemd-tmpfiles.conf"

cd /

# Setup dotfiles
git clone https://github.com/reisaraujo-miguel/dotfiles.git /tmp/dotfiles
bash /tmp/dotfiles/install.sh -c --no-backup -d /etc/skel -e nvim
