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
