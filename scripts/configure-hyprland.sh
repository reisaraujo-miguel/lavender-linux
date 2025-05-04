#!/bin/bash

set -ouex pipefail

# Install Hyprland

dnf5 install -y fuzzel hyprland hyprland-qtutils xdg-desktop-portal-hyprland playerctl swww scdoc brightnessctl hyprpicker hyprutils hyprwayland-scanner hyprlock wlogout hypridle hyprlang-devel libsass-devel libsass gnome-themes-extra qt5ct qt6-qtwayland blueprint-compiler python3-libsass aylurs-gtk-shell kvantum kvantum-qt5

# Install ReGreet
dnf5 install greetd -y

chmod -R go+r /etc/greetd/

systemctl enable greetd.service -f

cd /tmp

# install build dependencies
dnf5 install -y cargo cairo-devel pango-devel gdk-pixbuf2-devel cairo-gobject-devel

git clone https://github.com/rharish101/ReGreet.git
cd ReGreet

HOME=/tmp

cargo build --all-features --release
cp target/release/regreet /usr/bin

sed -i 's/greeter/greetd/g' ./systemd-tmpfiles.conf

cp ./systemd-tmpfiles.conf /etc/tmpfiles.d/regreet.conf

systemd-tmpfiles --create "$PWD/systemd-tmpfiles.conf"

cd /

# Setup dotfiles
git clone https://github.com/reisaraujo-miguel/dotfiles.git /tmp/dotfiles
bash /tmp/dotfiles/install.sh -c --no-backup -d /etc/skel -e nvim
