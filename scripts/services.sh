#!/bin/bash

set -ouex pipefail

systemctl enable docker.socket
systemctl enable podman.socket

systemctl enable swtpm-workaround.service
systemctl enable libvirt-workaround.service

systemctl enable bluefin-dx-groups.service

systemctl enable tailscaled.service

systemctl enable brew-setup.service
systemctl enable brew-upgrade.timer
systemctl enable brew-update.timer

systemctl --global enable podman-auto-update.timer
