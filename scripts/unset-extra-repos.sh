#!/bin/bash

set -ouex pipefail

# disable all repos
find /etc/yum.repos.d/ -type f -name "*.repo" -exec sed -i "s/^enabled=.*/enabled=0/" {} +

if find /etc/yum.repos.d/ -type f -name "*.repo" -exec grep -q "^enabled=[^0]" {} +; then
    echo "Error: Some files have 'enabled' set to a value other than 0." >&2
    exit 1
else
    echo "All files are correctly set to 'enabled=0'."
fi
