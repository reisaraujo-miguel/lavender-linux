#!/bin/bash

set -ouex pipefail

echo '::group:: === Download System Config Files From Bluefin ==='

curl -Lo /usr/lib/sysctl.d/docker-ce.conf "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/system_files/dx/usr/lib/sysctl.d/docker-ce.conf"

curl -Lo /usr/lib/systemd/system/bluefin-dx-groups.service "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/system_files/dx/usr/lib/systemd/system/bluefin-dx-groups.service"

curl -Lo /usr/lib/systemd/system/incus-workaround.service "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/system_files/dx/usr/lib/systemd/system/incus-workaround.service"

curl -Lo /usr/lib/systemd/system/libvirt-workaround.service "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/system_files/dx/usr/lib/systemd/system/libvirt-workaround.service"

curl -Lo /usr/lib/systemd/system/swtpm-workaround.service "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/system_files/dx/usr/lib/systemd/system/swtpm-workaround.service"

curl -Lo /usr/lib/tmpfiles.d/incus-workaround.conf "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/system_files/dx/usr/lib/tmpfiles.d/incus-workaround.conf"

curl -Lo /usr/lib/tmpfiles.d/libvirt-workaround.conf "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/system_files/dx/usr/lib/tmpfiles.d/libvirt-workaround.conf"

curl -Lo /usr/lib/tmpfiles.d/swtpm-workaround.conf "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/system_files/dx/usr/lib/tmpfiles.d/swtpm-workaround.conf"

curl -Lo /usr/libexec/bluefin-dx-groups "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/system_files/dx/usr/libexec/bluefin-dx-groups"

curl -Lo /usr/libexec/bluefin-dx-kvmfr-setup "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/system_files/dx/usr/libexec/bluefin-dx-kvmfr-setup"

curl -Lo /usr/libexec/bluefin-incus "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/system_files/dx/usr/libexec/bluefin-incus"

echo '::endgroup::'

if [[ -d "$SYSTEM_FILES_DIR" ]]; then
	cp -r "$SYSTEM_FILES_DIR"/* / || {
		echo "Failed to copy system files"
		exit 1
	}
else
	echo "Warning: System files directory not found"
fi

replace_line() {
	local file="$1"
	local pattern="$2"
	local replacement="$3"

	local e_pattern
	e_pattern=$(echo "$pattern" | perl -pe 's/([\/&])/\\$1/g')

	local e_replacement
	e_replacement=$(echo "$replacement" | perl -pe 's/([\/&])/\\$1/g')

	sed -i "s/^${e_pattern}.*/${e_replacement}/" "$file"
}

# Change some lines on gschema
SCHEMAS_FOLDER=/usr/share/glib-2.0/schemas/

replace_line "$SCHEMAS_FOLDER/zz0-01-bazzite-desktop-silverblue-dash.gschema.override" "favorite-apps" \
	"favorite-apps = ['org.mozilla.firefox.desktop', 'eu.betterbird.Betterbird.desktop', 'org.gnome.Nautilus.desktop', 'io.bassi.Amberol.desktop', 'org.libreoffice.LibreOffice.writer.desktop', 'org.gnome.Software.desktop', 'com.mitchellh.ghostty.desktop']"

replace_line "$SCHEMAS_FOLDER/zz0-03-bazzite-desktop-silverblue-extensions.gschema.override" "enabled-extensions" \
	"enabled-extensions = ['gsconnect@andyholmes.github.io', 'tailscale@joaophi.github.com', 'search-light@icedman.github.com', 'caffeine@patapon.info']"

replace_line "$SCHEMAS_FOLDER/zz0-04-bazzite-desktop-silverblue-theme.gschema.override" "\[org.gnome.desktop.interface\]" \
	"\[org.gnome.desktop.interface\]\nicon-theme=\"MoreWaita\""

replace_line "$SCHEMAS_FOLDER/zz0-04-bazzite-desktop-silverblue-theme.gschema.override" "button-layout" "button-layout=\":close\""

replace_line "$SCHEMAS_FOLDER/zz0-00-bazzite-desktop-silverblue-global.gschema.override" "terminal=" "terminal='ghostty'"

# Compile schemas
glib-compile-schemas "$SCHEMAS_FOLDER"

# Download dotfiles

git clone https://github.com/reisaraujo-miguel/my-dot-files.git /tmp/dotfiles
bash /tmp/dotfiles/install.sh -d /etc/skel -e nvim
