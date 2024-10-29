#!/usr/bin/env zsh

# Load and initialize the completion system ignoring insecure directories with a
# cache time of 20 hours, so it should almost always regenerate the first time a
# shell is opened each day.
autoload -Uz compinit
_comp_path="${XDG_CACHE_HOME:-$HOME/.cache}/prezto/zcompdump"

# #q expands globs in conditional expressions
if [[ $_comp_path(#qNmh-20) ]]; then
  	# -C (skip function check) implies -i (skip security check).
  	compinit -C -d "$_comp_path"
else
  	mkdir -p "$_comp_path:h"
 	compinit -i -d "$_comp_path"
  	# Keep $_comp_path younger than cache time even if it isn't regenerated.
  	touch "$_comp_path"
fi

unset _comp_path

#----------------------------------------------------------#

# load brew autocomplete
if [ -d "/home/linuxbrew/.linuxbrew/share/zsh/site-functions" ]; then
    fpath+=(/home/linuxbrew/.linuxbrew/share/zsh/site-functions)
fi

#----------------------------------------------------------#

setopt INC_APPEND_HISTORY # To save every command before it is executed
setopt SHARE_HISTORY      # Share history between all sessions.
setopt APPEND_HISTORY     # Append history to the history file.
setopt COMPLETE_IN_WORD   # Complete from both ends of a word.
setopt ALWAYS_TO_END      # Move cursor to the end of a completed word.
setopt PATH_DIRS          # Perform path search even on command names with slashes.
setopt AUTO_MENU          # Show completion menu on a successive tab press.
setopt AUTO_LIST          # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH   # If completed parameter is a directory, add a trailing slash.
setopt EXTENDED_GLOB      # Needed for file modification glob modifiers with compinit.
unsetopt MENU_COMPLETE    # Do not autoselect the first completion entry.
unsetopt FLOW_CONTROL     # Disable start/stop characters in shell editor.
setopt interactivecomments  # Allow inline comments
setopt AUTO_CD              # Auto changes to a directory without typing cd.
setopt nonomatch

#----------------------------------------------------------#

export ZSHCONFIG=${ZDOTDIR:-$HOME/.config/zsh}/.zsh

# Standard style used by default for 'list-colors'
LS_COLORS=${LS_COLORS:-'di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'}

#----------------------------------------------------------#

# Defaults.
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# Use caching to make completion for commands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/prezto/zcompcache"

# Case-insensitive (all), partial-word, and then substring completion.
if zstyle -t ':prezto:module:completion:*' case-sensitive; then
  zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  setopt CASE_GLOB
else
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  unsetopt CASE_GLOB
fi

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# Fuzzy match mistyped completions.
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Increase the number of errors based on the length of the typed word. But make
# sure to cap (at 7) the max-errors to avoid hanging.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Array completion element sorting.
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Directories
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true

# History
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# Environment Variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

# Populate hostname completion. But allow ignoring custom entries from static
# */etc/hosts* which might be uninteresting.
zstyle -a ':prezto:module:completion:*:hosts' etc-host-ignores '_etc_host_ignores'

zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${=${=${${(f)"$(cat {/etc/ssh/ssh_,~/.ssh/}known_hosts(|2)(N) 2> /dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
  ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2> /dev/null))"}%%(\#${_etc_host_ignores:+|${(j:|:)~_etc_host_ignores}})*}
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2> /dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

# Don't complete uninteresting users...
zstyle ':completion:*:*:*:users' ignored-patterns \
  adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
  dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
  hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
  mailman mailnull mldonkey mysql nagios \
  named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
  operator pcap postfix postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'

# Ignore multiple entries.
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'

# Kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# Media Players
zstyle ':completion:*:*:mpg123:*' file-patterns '*.(mp3|MP3):mp3\ files *(-/):directories'
zstyle ':completion:*:*:mpg321:*' file-patterns '*.(mp3|MP3):mp3\ files *(-/):directories'
zstyle ':completion:*:*:ogg123:*' file-patterns '*.(ogg|OGG|flac):ogg\ files *(-/):directories'
zstyle ':completion:*:*:mocp:*' file-patterns '*.(wav|WAV|mp3|MP3|ogg|OGG|flac):ogg\ files *(-/):directories'

# Mutt
if [[ -s "$HOME/.mutt/aliases" ]]; then
  zstyle ':completion:*:*:mutt:*' menu yes select
  zstyle ':completion:*:mutt:*' users ${${${(f)"$(<"$HOME/.mutt/aliases")"}#alias[[:space:]]}%%[[:space:]]*}
fi

# SSH/SCP/RSYNC
zstyle ':completion:*:(ssh|scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

autoload -U colors
colors


#----------------------------------------------------------#

# Function to add to PATH if not already present
add_to_path() {
    if [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$PATH:$1"
    fi
}

# Add local bin to path
add_to_path "$HOME/.local/bin"

# Add npm
NPM_PACKAGES="$HOME/.npm-packages"
add_to_path "$NPM_PACKAGES/bin"
add_to_path "$HOME/.local/share/npm/bin"

# Add my scripts to path
if [ -d "$HOME/scripts" ]; then
    add_to_path "$HOME/scripts"
fi

# Add bun
if [ -d "$HOME/.bun" ]; then
    BUN_INSTALL="$HOME/.bun"
    add_to_path "$BUN_INSTALL/bin"

	# bun completions
	[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
fi

# Add deno
if [ -d "$HOME/.deno" ]; then
    add_to_path "$HOME/.deno/bin"
    . "$HOME/.deno/env"
fi

# Add android tools
if [ -d "$HOME/Android/Sdk" ]; then
    ANDROID_HOME="$HOME/Android/Sdk"
    add_to_path "$ANDROID_HOME/emulator"
    add_to_path "$ANDROID_HOME/platform-tools"
fi

# Add kitty
if [ -d "$HOME/.local/kitty.app" ]; then
    add_to_path "$HOME/.local/kitty.app/bin"
fi

# Add cargo
if [ -d "$HOME/.cargo" ]; then
    add_to_path "$HOME/.cargo/bin"
    . "$HOME/.cargo/env"
fi

# Add flutter
if [ -d "$HOME/.flutter" ]; then
    add_to_path "$HOME/.flutter/bin"
fi

# Add golang
if [ ! -z "$GOPATH" ]; then
    add_to_path "$GOPATH/bin"
fi

export PATH

#----------------------------------------------------------#

# Brew 
if [[ -o interactive ]] && [[ -d /home/linuxbrew/.linuxbrew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  if type brew &>/dev/null; then
    if [[ -w /home/linuxbrew/.linuxbrew ]]; then
      if [[ ! -L "$(brew --prefix)/share/zsh/site-functions/_brew" ]]; then
        brew completions link
      fi
    fi
  fi
fi

#----------------------------------------------------------#

export HISTSIZE=10000
export SAVEHIST=10000
export LSP_USE_PLISTS=true

#----------------------------------------------------------#

# Preserve MANPATH if you already defined it somewhere in your config.
# Otherwise, fall back to `manpath` so we can inherit from `/etc/manpath`.
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"

#----------------------------------------------------------#

alias ls="eza --icons auto"

#----------------------------------------------------------#

echo -ne "\033]0;${USER}@${HOST}\007"

#----------------------------------------------------------#

ZSH_THEME="catppuccin"
source ~/.config/zsh/theme/catppuccin.zsh-theme

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Configure autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)
# ZSH_AUTOSUGGEST_COMPLETION_IGNORE="\["
# ZSH_AUTOSUGGEST_HISTORY_IGNORE="\["

#----------------------------------------------------------#

# Must be at last
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
