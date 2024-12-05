#!/bin/bash

set -ouex pipefail

# disable all repos
for repo in /etc/yum.repos.d/*.repo; do
	sed -i "s/^enabled=.*/enabled=0/" "$repo"
done
