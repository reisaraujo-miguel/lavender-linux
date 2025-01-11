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
install_copr_repo "pgdev" "ghostty"
install_copr_repo "kylegospo" "bazzite"
install_copr_repo "kylegospo" "bazzite-multilib"
install_copr_repo "kylegospo" "LatencyFleX"

# enable rpmfusion
for FILE in /etc/yum.repos.d/rpmfusion*; do
	sed -i "s/^enabled=.*/enabled=1/" "$FILE"
done
