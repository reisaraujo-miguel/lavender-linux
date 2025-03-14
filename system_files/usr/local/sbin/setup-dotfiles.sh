#!/bin/bash

if [ "$(id -u "$PAM_USER")" -lt 1000 ]; then
	exit 0
fi

USER_HOME=$(getent passwd "$PAM_USER" | cut -d: -f6)

if [ -d "$USER_HOME" ]; then
	bash "$USER_HOME/.config/dotfiles/install.sh" -d "$USER_HOME" -e nvim
	chown -R "$PAM_USER:$(id -gn "$PAM_USER")" "$USER_HOME/.*"
fi

exit 0
