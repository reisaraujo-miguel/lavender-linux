#!/bin/bash

set -ouex pipefail

systemctl enable sddm.service --force

systemctl set-default graphical.target --force

# Enable Bluefin DX services
systemctl enable bluefin-dx-groups.service --force
systemctl enable incus-workaround.service --force
systemctl enable libvirt-workaround.service --force
systemctl enable swtpm-workaround.service --force

# Enable docker and podman
systemctl enable docker.socket --force
systemctl enable podman.socket --force

# Enable tailscaled
systemctl enable tailscaled.service --force

# Enable brew services
systemctl enable brew-setup.service --force
systemctl enable brew-upgrade.timer --force
systemctl enable brew-update.timer --force

# Enable podman services
systemctl --global enable podman-auto-update.timer --force
