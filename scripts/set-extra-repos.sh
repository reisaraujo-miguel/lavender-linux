#!/bin/bash

set -ouex pipefail

file=${BUILD_FILES_DIR}/copr-repos

# Loop through each line in the file
while IFS= read -r repo; do
	# Skip empty lines and lines starting with #
	if [[ -z "$repo" || "$repo" == \#* ]]; then
		continue
	fi

	echo "Enabling Copr repository: $repo"
	dnf5 -y copr enable "$repo"
done <"$file"

# enable rpmfusion
for FILE in /etc/yum.repos.d/rpmfusion*; do
	sed -i "s/^enabled=.*/enabled=1/" "$FILE"
done
