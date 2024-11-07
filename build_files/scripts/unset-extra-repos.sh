#!/bin/bash

set -ouex pipefail

# get the list of repos installed
repolist="$(ls "$SYSTEM_FILES_DIR"/etc/yum.repos.d/) rpmfusion-nonfree-steam.repo"

# disable all repos
for repo in $repolist; do
	[ ! -f "/etc/yum.repos.d/$repo" ] && { echo "Repo file not found"; exit 1; }
	sed -i "s/^enabled=.*/enabled=0/" "/etc/yum.repos.d/$repo"
done
