#!/bin/bash

set -ouex pipefail

systemctl enable sddm

systemctl set-default multi-user.target

# Enable Bluefin DX services
systemctl enable bluefin-dx-groups.service
systemctl enable incus-workaround.service
systemctl enable libvirt-workaround.service
systemctl enable swtpm-workaround.service

# Enable docker and podman
systemctl enable docker.socket
systemctl enable podman.socket

# Enable tailscaled
systemctl enable tailscaled.service

# Enable brew services
systemctl enable brew-setup.service
systemctl enable brew-upgrade.timer
systemctl enable brew-update.timer

# Enable podman services
systemctl --global enable podman-auto-update.timer
