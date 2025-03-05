#!/bin/bash

set -ouex pipefail

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
  e_pattern=$(echo "$pattern" | sed 's/[\/&]/\\&/g')

  local e_replacement
  e_replacement=$(echo "$replacement" | sed 's/[\/&]/\\&/g')

  sed -i "s/^${e_pattern}.*/${e_replacement}/" "$file"
}

# Change some lines on gschema
schemas_file=/usr/share/glib-2.0/schemas/zz0-bluefin-modifications.gschema.override

replace_line $schemas_file "favorite-apps" \
  "favorite-apps = ['org.mozilla.firefox.desktop', 'eu.betterbird.Betterbird.desktop', 'org.gnome.Nautilus.desktop', 'io.bassi.Amberol.desktop', 'org.libreoffice.LibreOffice.writer.desktop', 'org.gnome.Software.desktop', 'com.mitchellh.ghostty.desktop']"

replace_line $schemas_file "enabled-extensions" \
  "enabled-extensions = ['gsconnect@andyholmes.github.io', 'tailscale@joaophi.github.com', 'search-light@icedman.github.com', 'caffeine@patapon.info']"

replace_line $schemas_file "accent-color" "accent-color=\"purple\""

replace_line $schemas_file "color-scheme" "color-scheme=\"prefer-dark\""

replace_line $schemas_file "icon-theme" "icon-theme=\"MoreWaita\""

replace_line $schemas_file "button-layout" "button-layout=\":close\""

replace_line $schemas_file "terminal=" "terminal='ghostty'"

# Compile schemas
glib-compile-schemas /usr/share/glib-2.0/schemas/

# Download configs from Bazzite
curl -L --create-dirs -o /etc/scx_loader/config.toml https://raw.githubusercontent.com/ublue-os/bazzite/main/system_files/desktop/shared/etc/scx_loader/config.toml

curl -L --create-dirs -o /usr/lib/sysctl.d/10-map-count.conf https://raw.githubusercontent.com/ublue-os/bazzite/main/system_files/desktop/shared/usr/lib/sysctl.d/70-gaming.conf
