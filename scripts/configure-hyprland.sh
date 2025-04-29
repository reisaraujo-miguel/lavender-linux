#!/bin/bash

set -ouex pipefail

# Create required directories
mkdir -p /etc/skel/.config/hypr

chmod +x /usr/share/xdg/autostart/hyprland-portal.desktop
chmod +x /usr/libexec/bluefin-dx-groups
chmod +x /usr/libexec/bluefin-incus
chmod +x /usr/libexec/bluefin-dx-kvmfr-setup

# install script from https://github.com/EisregenHaha/fedora-hyprland

t="/tmp/"
rm -rf "$t"
mkdir -p "$t"
cd "$t"

sudo dnf4 group install "Development Tools" -y
sudo dnf install cmake clang -y
sudo dnf install python3.11 python3.11-devel -y
sudo dnf install gammastep mate-polkit -y
sudo dnf install gtksourceviewmm3-devel -y
sudo dnf install python3-pip python3-devel -y
sudo dnf install gnome-bluetooth bluez-cups bluez -y
sudo dnf install gtk4-devel libadwaita-devel -y
sudo dnf install coreutils wl-clipboard xdg-utils cmake curl fuzzel rsync wget ripgrep gojq npm meson typescript gjs axel -y

wget https://github.com/sentriz/cliphist/releases/download/v0.5.0/v0.5.0-linux-amd64 -O cliphist
chmod +x cliphist
sudo cp cliphist /usr/local/bin/cliphist

sudo dnf install tinyxml -y
sudo dnf install tinyxml2 tinyxml2-devel --releasever=41 -y
sudo dnf install python3-build python3-pillow python3-setuptools_scm python3-wheel -y
sudo dnf install hyprland hyprland-qtutils -y
sudo dnf install xrandr xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-hyprland -y

sudo dnf install pavucontrol wireplumber libdbusmenu-gtk3-devel libdbusmenu playerctl swww -y

sudo dnf install yad -y

sudo dnf install scdoc -y

sudo dnf install ydotool -y

sudo dnf install webp-pixbuf-loader gtk-layer-shell-devel gtk3 gtksourceview3 gtksourceview3-devel gobject-introspection upower -y

sudo dnf install brightnessctl ddcutil gammastep -y

sudo dnf install hyprpicker hyprutils hyprwayland-scanner hyprlock wlogout pugixml -y

#dart-sass

cd $t
wget https://github.com/sass/dart-sass/releases/download/1.77.0/dart-sass-1.77.0-linux-x64.tar.gz
tar -xzf dart-sass-1.77.0-linux-x64.tar.gz
cd dart-sass
sudo cp -rf ./* /usr/local/bin/

sudo dnf install python3-pywayland python3-psutil hypridle wl-clipboard hyprlang-devel libwebp-devel file-devel libdrm-devel libgbm-devel pam-devel libsass-devel libsass -y

sudo dnf install cargo -y

cd $t
git clone https://github.com/anyrun-org/anyrun.git # Clone the repository
cd anyrun                                          # Change the active directory to it

cargo build --release        # Build all the packages
cargo install --path anyrun/ # Install the anyrun binary

sudo cp "$HOME/.cargo/bin/anyrun" /usr/local/bin/
mkdir -p /etc/skel/.config/anyrun/plugins                  # Create the config directory and the plugins subdirectory
cp target/release/*.so /etc/skel/.config/anyrun/plugins    # Copy all of the built plugins to the correct directory
cp examples/config.ron /etc/skel/.config/anyrun/config.ron # Copy the default config file

sudo dnf install gnome-themes-extra adw-gtk3-theme qt5ct qt6-qtwayland qt5-qtwayland fontconfig jetbrains-mono-fonts gdouros-symbola-fonts lato-fonts fish foot starship -y

sudo dnf install swappy wf-recorder grim tesseract slurp -y

sudo dnf install appstream-util python3.12 python3.12-devel libsoup3-devel uv -y

sudo dnf install gobject-introspection-devel gjs-devel pulseaudio-libs-devel -y

# color-generation
sudo dnf install python3 python3-regex unzip -y
sudo dnf install python3-gobject-devel libsoup-devel blueprint-compiler -y
sudo dnf install python3-libsass libxdp-devel libxdp libportal -y
sudo dnf4 config-manager --add-repo https://download.opensuse.org/repositories/home:sp1rit:notekit/Fedora_Rawhide/home:sp1rit:notekit.repo -y
sudo dnf install clatexmath-devel -y
sudo dnf install aylurs-gtk-shell -y
sudo dnf install kvantum kvantum-qt5 -y

git clone https://github.com/EisregenHaha/end4fonts
cd end4fonts/fonts

if [[ -d /etc/skel/.local/share/fonts/ ]]; then
	echo "The fonts directory already exists"
else
	mkdir /etc/skel/.local/share/fonts
fi

cp -R ./* /etc/skel/.local/share/fonts

cd /
