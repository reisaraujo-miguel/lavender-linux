#!/bin/bash

set -ouex pipefail

dnf5 config-manager setopt "terra.enabled=True"

cat <<EOF >/etc/yum.repos.d/adoptium.repo
[Adoptium]
name=Adoptium
baseurl=https://packages.adoptium.net/artifactory/rpm/${DISTRIBUTION_NAME:-$(
	. /etc/os-release
	echo $ID_LIKE
)}/\$releasever/\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.adoptium.net/artifactory/api/gpg/key/public
EOF

file=$(cat "/ctx/copr-repos")

for repo in $file; do
	echo "Enabling Copr repository: $repo"
	if ! dnf5 -y copr enable "$repo"; then
		echo "Error: Failed to enable repository: $repo" >&2
		exit 1
	fi
done
