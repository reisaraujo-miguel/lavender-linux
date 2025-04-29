#!/bin/bash

set -ouex pipefail

# install other dependencies
HOME=/etc/skel/

XDG_BIN_HOME=${XDG_BIN_HOME:-$HOME/.local/bin}
XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
BACKUP_DIR=${BACKUP_DIR:-/tmp/backup}

cd /tmp
export base
base="/tmp"

ask=false

function try { "$@" || sleep 0; }
function v() {
	echo -e "####################################################"
	echo -e "\e[34m[$0]: Next command:\e[0m"
	echo -e "\e[32m" "$@" "\e[0m"
	execute=true
	if $ask; then
		while true; do
			echo -e "\e[34mExecute? \e[0m"
			echo "  y = Yes"
			echo "  e = Exit now"
			echo "  s = Skip this command (NOT recommended - your setup might not work correctly)"
			echo "  yesforall = Yes and don't ask again; NOT recommended unless you really sure"
			read -r -p "====> " p
			case $p in
			[yY])
				echo -e "\e[34mOK, executing...\e[0m"
				break
				;;
			[eE])
				echo -e "\e[34mExiting...\e[0m"
				exit
				;;
			[sS])
				echo -e "\e[34mAlright, skipping this one...\e[0m"
				execute=false
				break
				;;
			"yesforall")
				echo -e "\e[34mAlright, won't ask again. Executing...\e[0m"
				ask=false
				break
				;;
			*) echo -e "\e[31mPlease enter [y/e/s/yesforall].\e[0m" ;;
			esac
		done
	fi
	if $execute; then
		x "$@"
	else
		echo -e "\e[33m[$0]: Skipped " "$@" "\e[0m"
	fi
}
# When use v() for a defined function, use x() INSIDE its definition to catch errors.
function x() {
	if "$@"; then cmdstatus=0; else cmdstatus=1; fi # 0=normal; 1=failed; 2=failed but ignored
	while [ $cmdstatus == 1 ]; do
		echo -e "\e[31m[$0]: Command \"\e[32m" "$@" "\e[31m\" has failed."
		echo -e "You may need to resolve the problem manually BEFORE repeating this command."
		echo -e "[Tip] If a certain package is failing to install, try installing it separately in another terminal.\e[0m"
		echo "  r = Repeat this command (DEFAULT)"
		echo "  e = Exit now"
		echo "  i = Ignore this error and continue (your setup might not work correctly)"
		read -r -p " [R/e/i]: " p
		case $p in
		[iI])
			echo -e "\e[34mAlright, ignore and continue...\e[0m"
			cmdstatus=2
			;;
		[eE])
			echo -e "\e[34mAlright, will exit.\e[0m"
			break
			;;
		*)
			echo -e "\e[34mOK, repeating...\e[0m"
			if "$@"; then cmdstatus=0; else cmdstatus=1; fi
			;;
		esac
	done
	case $cmdstatus in
	0) echo -e "\e[34m[$0]: Command \"\e[32m" "$@" "\e[34m\" finished.\e[0m" ;;
	1)
		echo -e "\e[31m[$0]: Command \"\e[32m" "$@" "\e[31m\" has failed. Exiting...\e[0m"
		exit 1
		;;
	2) echo -e "\e[31m[$0]: Command \"\e[32m" "$@" "\e[31m\" has failed but ignored by user.\e[0m" ;;
	esac
}
function showfun() {
	echo -e "\e[34m[$0]: The definition of function \"$1\" is as follows:\e[0m"
	printf "\e[32m"
	type -a "$1"
	printf "\e[97m"
}
function remove_bashcomments_emptylines() {
	mkdir -p "$(dirname "$2")"
	cmd "$1" | sed -e '/^[[:blank:]]*#/d;s/#.*//' -e '/^[[:space:]]*$/d' >"$2"
}

function backup_configs() {
	local backup_dir="$BACKUP_DIR"
	mkdir -p "$backup_dir"
	echo "Backing up $XDG_CONFIG_HOME to $backup_dir/config_backup"
	rsync -av --progress "$XDG_CONFIG_HOME/" "$backup_dir/config_backup/"

	echo "Backing up $HOME/.local to $backup_dir/local_backup"
	rsync -av --progress "$HOME/.local/" "$backup_dir/local_backup/"
}

# Not for Arch(based) distro.
install-Rubik() {
	x mkdir -p "$base/cache/Rubik"
	x cd "$base/cache/Rubik"
	try git init -b main
	try git remote add origin https://github.com/googlefonts/rubik.git
	x git pull origin main && git submodule update --init --recursive
	x mkdir -p /usr/share/fonts/TTF/
	x cp fonts/variable/Rubik*.ttf /usr/share/fonts/TTF/
	x mkdir -p /usr/share/licenses/ttf-rubik/
	x cp OFL.txt /usr/share/licenses/ttf-rubik/LICENSE
	x fc-cache -fv
	x gsettings set org.gnome.desktop.interface font-name 'Rubik 11'
	x cd "$base"
}

# Not for Arch(based) distro.
install-Gabarito() {
	x mkdir -p "$base/cache/Gabarito"
	x cd "$base/cache/Gabarito"
	try git init -b main
	try git remote add origin https://github.com/naipefoundry/gabarito.git
	x git pull origin main && git submodule update --init --recursive
	x mkdir -p /usr/share/fonts/TTF/
	x cp fonts/ttf/Gabarito*.ttf /usr/share/fonts/TTF/
	x mkdir -p /usr/share/licenses/ttf-gabarito/
	x cp OFL.txt /usr/share/licenses/ttf-gabarito/LICENSE
	x fc-cache -fv
	x cd "$base"
}

# Not for Arch(based) distro.
install-OneUI() {
	x mkdir -p "$base/cache/OneUI4-Icons"
	x cd "$base/cache/OneUI4-Icons"
	try git init -b main
	try git remote add origin https://github.com/end-4/OneUI4-Icons.git
	# try git remote add origin https://github.com/mjkim0727/OneUI4-Icons.git
	x git pull origin main && git submodule update --init --recursive
	x mkdir -p /usr/share/icons
	x cp -r OneUI /usr/share/icons
	x cp -r OneUI-dark /usr/share/icons
	x cp -r OneUI-light /usr/share/icons
	x cd "$base"
}

# Not for Arch(based) distro.
install-uv() {
	x bash <(curl -LJs "https://astral.sh/uv/install.sh")
}

# Both for Arch(based) and other distros.
install-python-packages() {
	export UV_NO_MODIFY_PATH=1
	ILLOGICAL_IMPULSE_VIRTUAL_ENV=$XDG_STATE_HOME/ags/.venv
	x mkdir -p "$ILLOGICAL_IMPULSE_VIRTUAL_ENV"
	# we need python 3.12 https://github.com/python-pillow/Pillow/issues/8089
	x uv venv --prompt .venv "$ILLOGICAL_IMPULSE_VIRTUAL_ENV" -p 3.11
	x source "$ILLOGICAL_IMPULSE_VIRTUAL_ENV/bin/activate"
	x uv pip install -r /ctx/requirements.txt

	x mkdir -p "$base/cache/blueprint-compiler" && cd "$base/cache/blueprint-compiler"
	try git init -b main
	try git remote add origin https://github.com/end-4/ii-blueprint-compiler.git
	x git pull origin main && git submodule update --init --recursive
	x meson setup build --prefix="$VIRTUAL_ENV"
	x meson compile -C build
	x meson install -C build
	x cd -

	x mkdir -p "$base/cache/gradience" && cd "$base/cache/gradience"
	try git init -b main
	try git remote add origin https://github.com/end-4/ii-gradience.git
	x git pull origin main && git submodule update --init --recursive
	x uv pip install -r requirements.txt
	x meson setup build --prefix="$VIRTUAL_ENV"
	x meson compile -C build
	x meson install -C build
	x cd -

	x deactivate # We don't need the virtual environment anymore
	for i in "glib-2.0" "gradience"; do
		x rsync -av "$ILLOGICAL_IMPULSE_VIRTUAL_ENV"/share/$i/ "$XDG_DATA_HOME"/$i/
	done
}

v install-Rubik
v install-Gabarito
v install-OneUI
v install-uv
v install-python-packages

if [[ -z "${ILLOGICAL_IMPULSE_VIRTUAL_ENV}" ]]; then
	printf "\n\e[31m[%s]: \!! Important \!! : Please ensure environment variable \e[0m \$ILLOGICAL_IMPULSE_VIRTUAL_ENV \e[31m is set to proper value (by default \"~/.local/state/ags/.venv\"), or AGS config will not work. We have already provided this configuration in ~/.config/hypr/hyprland/env.conf, but you need to ensure it is included in hyprland.conf, and also a restart is needed for applying it.\e[0m\n", "$0"
fi
