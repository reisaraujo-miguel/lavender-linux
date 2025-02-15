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

# Remove Bluefin gschema override
rm /usr/share/glib-2.0/schemas/zz0-bluefin-modifications.gschema.override

# Compile schemas
glib-compile-schemas /usr/share/glib-2.0/schemas/

# Download configs from Bazzite

curl -L --create-dirs -o /etc/scx_loader/config.toml https://raw.githubusercontent.com/ublue-os/bazzite/main/system_files/desktop/shared/etc/scx_loader/config.toml

curl -L --create-dirs -o /usr/lib/sysctl.d/10-map-count.conf https://raw.githubusercontent.com/ublue-os/bazzite/main/system_files/desktop/shared/usr/lib/sysctl.d/70-gaming.conf
