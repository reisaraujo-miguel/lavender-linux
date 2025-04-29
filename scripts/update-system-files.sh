#!/bin/bash

set -ouex pipefail

if [[ -d "/ctx/system_files" ]]; then
	cp -r /ctx/system_files/* / || {
		echo "Failed to copy system files"
		exit 1
	}
else
	echo "Warning: System files directory not found"
fi

# consolidate just files
find /tmp/just -iname '*.just' -exec printf "\n\n" \; -exec cat {} \; >>/usr/share/ublue-os/just/60-custom.just
