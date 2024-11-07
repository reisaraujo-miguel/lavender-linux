#!/bin/bash

set -ouex pipefail

# install new repos
cp "$SYSTEM_FILES_DIR"/etc/yum.repos.d/* /etc/yum.repos.d/

# enable rpmfusion-nonfree-steam
steam_repo="/etc/yum.repos.d/rpmfusion-nonfree-steam.repo"

[ ! -f "$steam_repo" ] && { echo "Steam repo file not found"; exit 1; }
sed -i "s/^enabled=.*/enabled=1/" "$steam_repo"
