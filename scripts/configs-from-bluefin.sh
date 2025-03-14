#!/bin/bash

set -ouex pipefail

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
