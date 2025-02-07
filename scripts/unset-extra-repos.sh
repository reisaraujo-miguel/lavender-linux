#!/bin/bash

set -ouex pipefail

repos=$(dnf5 repo list --json | jq -r '.[].id')

for repo in $repos; do
	echo "Disabling repository: $repo"
	if ! dnf5 config-manager setopt "$repo".enabled=False; then
		echo "Error: Failed to disable repository: $repo" >&2
		exit 1
	fi
done
