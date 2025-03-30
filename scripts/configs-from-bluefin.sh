#!/bin/bash

set -ouex pipefail

# docker conf
curl -Lo /usr/lib/sysctl.d/docker-ce.conf "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/system_files/dx/usr/lib/sysctl.d/docker-ce.conf"

# bluefin-dx-groups service
curl -Lo /usr/lib/systemd/system/bluefin-dx-groups.service "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/system_files/dx/usr/lib/systemd/system/bluefin-dx-groups.service"
# bluefin-dx-groups script
curl -Lo /usr/libexec/bluefin-dx-groups "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/system_files/dx/usr/libexec/bluefin-dx-groups"

# incus-workaround service
curl -Lo /usr/lib/systemd/system/incus-workaround.service "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/system_files/dx/usr/lib/systemd/system/incus-workaround.service"
# incus-workaround conf
curl -Lo /usr/lib/tmpfiles.d/incus-workaround.conf "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/system_files/dx/usr/lib/tmpfiles.d/incus-workaround.conf"
# bluefin incus script
curl -Lo /usr/libexec/bluefin-incus "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/system_files/dx/usr/libexec/bluefin-incus"

# libvirt-workaround service
curl -Lo /usr/lib/systemd/system/libvirt-workaround.service "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/system_files/dx/usr/lib/systemd/system/libvirt-workaround.service"
# libvirt-workaround conf
curl -Lo /usr/lib/tmpfiles.d/libvirt-workaround.conf "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/system_files/dx/usr/lib/tmpfiles.d/libvirt-workaround.conf"

# swtpm-workaround service
curl -Lo /usr/lib/systemd/system/swtpm-workaround.service "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/system_files/dx/usr/lib/systemd/system/swtpm-workaround.service"
# swtpm-workaround conf
curl -Lo /usr/lib/tmpfiles.d/swtpm-workaround.conf "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/system_files/dx/usr/lib/tmpfiles.d/swtpm-workaround.conf"

# bluefin-dx bluefin-dx-kvmfr-setup
curl -Lo /usr/libexec/bluefin-dx-kvmfr-setup "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/system_files/dx/usr/libexec/bluefin-dx-kvmfr-setup"

# just scripts
mkdir -p /tmp/just

curl -Lo /tmp/just/bluefin-apps.just "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/just/bluefin-apps.just"
curl -Lo /tmp/just/bluefin-system.just "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/just/bluefin-system.just"

sed -i 's/bluefin-cli/lavender-cli/' /tmp/just/bluefin-system.just
