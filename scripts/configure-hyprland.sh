#!/bin/bash

set -ouex pipefail

# set home
HOME=/tmp

chmod +x /usr/share/xdg/autostart/hyprland-portal.desktop

dnf5 remove -y gnome-shell gnome-session gnome-session-xsession gnome-classic-session gnome-session-wayland-session mutter

dnf5 autoremove -y

# install script from https://github.com/EisregenHaha/fedora-hyprland

t="/tmp/"
cd "$t"

dnf5 group install development-tools -y
dnf5 install cmake clang python3.11 python3.11-devel gammastep mate-polkit gtksourceviewmm3-devel python3-pip python3-devel gnome-bluetooth bluez-cups bluez gtk4-devel libadwaita-devel coreutils wl-clipboard xdg-utils cmake curl fuzzel rsync wget ripgrep gojq npm meson typescript gjs axel -y

wget https://github.com/sentriz/cliphist/releases/download/v0.5.0/v0.5.0-linux-amd64 -O cliphist
chmod +x cliphist
cp cliphist /usr/bin/cliphist

dnf5 install tinyxml python3-build python3-pillow python3-setuptools_scm python3-wheel hyprland hyprland-qtutils xrandr xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-hyprland pavucontrol wireplumber libdbusmenu-gtk3-devel libdbusmenu playerctl swww yad scdoc ydotool webp-pixbuf-loader gtk-layer-shell-devel gtk3 gtksourceview3 gtksourceview3-devel gobject-introspection upower brightnessctl ddcutil gammastep hyprpicker hyprutils hyprwayland-scanner hyprlock wlogout pugixml -y

dnf5 remove tinyxml2 -y

dnf5 install tinyxml2 tinyxml2-devel --releasever=41 -y

#dart-sass

cd $t
wget https://github.com/sass/dart-sass/releases/download/1.77.0/dart-sass-1.77.0-linux-x64.tar.gz
tar -xzf dart-sass-1.77.0-linux-x64.tar.gz
cd dart-sass
cp -rf ./* /usr/bin/

dnf5 install python3-pywayland python3-psutil hypridle wl-clipboard hyprlang-devel libwebp-devel file-devel libdrm-devel libgbm-devel pam-devel libsass-devel libsass cargo -y

# Install AnyRun
cd $t
git clone https://github.com/anyrun-org/anyrun.git # Clone the repository
cd anyrun                                          # Change the active directory to it

cargo build --release        # Build all the packages
cargo install --path anyrun/ # Install the anyrun binary

cp "$HOME/.cargo/bin/anyrun" /usr/bin/
mkdir -p /etc/skel/.config/anyrun/plugins                  # Create the config directory and the plugins subdirectory
cp target/release/*.so /etc/skel/.config/anyrun/plugins    # Copy all of the built plugins to the correct directory
cp examples/config.ron /etc/skel/.config/anyrun/config.ron # Copy the default config file

dnf5 install gnome-themes-extra adw-gtk3-theme qt5ct qt6-qtwayland qt5-qtwayland fontconfig jetbrains-mono-fonts gdouros-symbola-fonts lato-fonts starship swappy wf-recorder grim tesseract slurp appstream-util python3.12 python3.12-devel libsoup3-devel uv gobject-introspection-devel gjs-devel pulseaudio-libs-devel -y

# color-generation
dnf5 install python3 python3-regex unzip python3-gobject-devel libsoup-devel blueprint-compiler python3-libsass libxdp-devel libxdp libportal -y

dnf5 config-manager addrepo --from-repofile=https://download.opensuse.org/repositories/home:sp1rit:notekit/Fedora_Rawhide/home:sp1rit:notekit.repo

dnf5 install clatexmath-devel aylurs-gtk-shell kvantum kvantum-qt5 -y

git clone https://github.com/EisregenHaha/end4fonts
cd end4fonts/fonts

if [[ -d /etc/skel/.local/share/fonts/ ]]; then
	echo "The fonts directory already exists"
else
	mkdir /etc/skel/.local/share/fonts
fi

cp -R ./* /etc/skel/.local/share/fonts

# Install ReGreet
cd $t
dnf5 install greetd -y

useradd -M greeter

mkdir -p /etc/greetd/
chmod -R go+r /etc/greetd/

systemctl enable greetd.service

git clone https://github.com/rharish101/ReGreet.git
cd ReGreet

cargo build --all-features --release
cp target/release/regreet /usr/bin

wget https://github.com/rharish101/ReGreet/blob/main/systemd-tmpfiles.conf -O /etc/tmpfiles.d/regreet.conf

systemd-tmpfiles --create "$PWD/systemd-tmpfiles.conf"

cd /

# Setup dotfiles
git clone https://github.com/reisaraujo-miguel/dotfiles.git /tmp/dotfiles
bash /tmp/dotfiles/install.sh -c --no-backup -d /etc/skel -e nvim
