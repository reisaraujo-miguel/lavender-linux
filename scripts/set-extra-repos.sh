#!/bin/bash

set -ouex pipefail

# install new repos
function install_copr_repo() {
	local package_maintainer="$1"
	local package_name="$2"
	local repo_file="/etc/yum.repos.d/${package_maintainer}-${package_name}-fedora-${RELEASE}.repo"
	local repo_url="https://copr.fedorainfracloud.org/coprs/${package_maintainer}/${package_name}/repo/fedora-${RELEASE}/${package_maintainer}-${package_name}-fedora-${RELEASE}.repo"

	curl -Lo "$repo_file" "$repo_url"
}

install_copr_repo "atim" "lazygit"
install_copr_repo "vitallium" "neovim-default-editor"
install_copr_repo "dusansimic" "themes"

# enable rpmfusion-nonfree-steam
steam_repo="/etc/yum.repos.d/rpmfusion-nonfree-steam.repo"

[ ! -f "$steam_repo" ] && {
	echo "Steam repo file not found"
	exit 1
}

sed -i "s/^enabled=.*/enabled=1/" "$steam_repo"
