#!/bin/bash

set -ouex pipefail

dnf5 -y config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo

file=$(cat "/ctx/copr-repos")

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
