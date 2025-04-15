#!/bin/bash

set -ouex pipefail

systemctl enable docker.socket
systemctl enable podman.socket

systemctl enable swtpm-workaround.service
systemctl enable libvirt-workaround.service

systemctl enable bluefin-dx-groups.service

systemctl enable rpm-ostree-countme.service

systemctl enable tailscaled.service

systemctl enable dconf-update.service

# Updater
if systemctl cat -- uupd.timer &>/dev/null; then
	systemctl enable uupd.timer
else
	systemctl enable rpm-ostreed-automatic.timer
	systemctl enable flatpak-system-update.timer
	systemctl --global enable flatpak-user-update.timer
fi

systemctl enable brew-setup.service
systemctl enable brew-upgrade.timer
systemctl enable brew-update.timer

systemctl --global enable podman-auto-update.timer

systemctl enable ublue-system-setup.service
systemctl --global enable ublue-user-setup.service
