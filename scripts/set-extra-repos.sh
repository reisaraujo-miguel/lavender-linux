#!/bin/bash

set -ouex pipefail

file=$(cat "${BUILD_FILES_DIR}/copr-repos")

for repo in $file; do
	echo "Enabling Copr repository: $repo"
	if ! dnf5 -y copr enable "$repo"; then
		echo "Error: Failed to enable repository: $repo" >&2
		exit 1
	fi
done

rpmfusion_repos=$(dnf5 repo list --all | awk '/rpmfusion-/ {print $1}')

for repo in $rpmfusion_repos; do
	echo "Enabling RPMFusion repository: $repo"
	if ! dnf5 config-manager setopt "$repo".enabled=True; then
		echo "Error: Failed to enable repository: $repo" >&2
		exit 1
	fi
done

dnf5 -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release{,-extras}
dnf5 -y config-manager setopt "terra-mesa".enabled=true

dnf5 -y config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-steam.repo

dnf5 -y config-manager setopt "*bazzite*".priority=1
dnf5 -y config-manager setopt "*akmods*".priority=2
dnf5 -y config-manager setopt "*terra*".priority=3
dnf5 -y config-manager setopt "*rpmfusion*".priority=4
dnf5 -y config-manager setopt "*negativo17*".priority=4

dnf5 -y config-manager setopt "*rpmfusion*".exclude="mesa-*"
dnf5 -y config-manager setopt "*fedora*".exclude="mesa-*"
dnf5 -y config-manager setopt "*staging*".exclude="scx-scheds mesa*"
dnf5 -y config-manager setopt "*terra*".exclude="nerd-fonts topgrade"
dnf5 -y config-manager setopt "*negativo17*".exclude="mesa-* *xone*"
