#!/usr/bin/env zsh

# Execute code in the background to not affect the current session
(
    # <https://github.com/zimfw/zimfw/blob/master/login_init.zsh>
    setopt LOCAL_OPTIONS EXTENDED_GLOB
    autoload -U zrecompile
    local ZSHCONFIG="${ZDOTDIR:-$HOME/.config/zsh}/.zsh"

    # Compile zcompdump, if modified, to increase startup speed.
    zcompdump="${ZDOTDIR:-$HOME/.config/zsh}/.zcompdump"
    if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
        zrecompile -pq "$zcompdump"
    fi
    
	# zcompile .zshrc
    zrecompile -pq ${ZDOTDIR:-${HOME/.config/zsh}}/.zshrc
    zrecompile -pq ${ZDOTDIR:-${HOME/.config/zsh}}/.zprofile
    zrecompile -pq ${HOME}/.zshenv
    
	# recompile all zsh or sh
    for f in $ZSHCONFIG/**/*.*sh
    do
        zrecompile -pq $f
    done
) &!
