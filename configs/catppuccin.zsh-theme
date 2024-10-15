# Prompt:
# %F => Foreground color codes
# %f => Reset foreground
# %K => Background color codes
# %k => Reset background
# %B => Set bold font
# %b => Unset bold font
# %1~ => Current dir
# %(x.true.false) => Specifies a ternary expression
#   ! => True if the shell is running with root privileges
#   ? => True if the exit status of the last command was success
#
# Git:
# %a => Current action (rebase/merge)
# %b => Current branch
# %c => Staged changes
# %u => Unstaged changes
#
# Terminal:
# \n => Newline/Line Feed (LF)

setopt PROMPT_SUBST

autoload -U add-zsh-hook
autoload -Uz vcs_info

# Use True color (24-bit) if available. 
if [[ "${terminfo[colors]}" -ge 256 ]]; then
	# Mauve
	mauve="#c6a0f6"
	fg_mauve="%F{$mauve}"
    bg_mauve="%K{$mauve}"
	
	# Crust
	crust="#181926"
	fg_crust="%F{$crust}"
	bg_crust="%K{$crust}"
    
	# Overlay0
	overlay0="#6e738d"
	fg_overlay0="%F{$overlay0}"
    bg_overlay0="%K{$overlay0}"
    	
	# Subtext0
	subtext0="#a5adcb"
	fg_subtext0="%F{$subtext0}"
	bg_subtext0="%K{$subtext0}"	

	# Red
	red="#ed8796"
	fg_red="%F{$red}"
    bg_red="%K{$red}"	

	# Yellow
	yellow="#eed49f"
	fg_yellow="%F{$yellow}"
    bg_yellow="%K{$yellow}"	
	
	# Green
	green="#a6da95"
	fg_green="%F{$green}"
    bg_green="%K{$green}"

	# Text
	text="#cad3f5"
	fg_text="%F{$text}"
	bg_text="%K{$text}"
else
	# Mauve
	mauve="purple"
	fg_mauve="%F{$mauve}"
    bg_mauve="%K{$mauve}"
	
	# Crust
	crust="black"
	fg_crust="%F{$crust}"
	bg_crust="%K{$crust}"
    
	# Overlay0
	overlay0="white"
	fg_overlay0="%F{$overlay0}"
    bg_overlay0="%K{$overlay0}"
    	
	# Subtext0
	subtext0="white"
	fg_subtext0="%F{$subtext0}"
	bg_subtext0="%K{$subtext0}"	

	# Red
	red="red"
	fg_red="%F{$red}"
    bg_red="%K{$red}"	

	# Yellow
	yellow="yellow"
	fg_yellow="%F{$yellow}"
    bg_yellow="%K{$yellow}"	
	
	# Green
	green="green"
	fg_green="%F{$green}"
    bg_green="%K{$green}"

	# Text
	text="white"
	fg_text="%F{$text}"
	bg_text="%K{$text}"
fi

# Reset color.
reset_fg="%f"
reset_bg="%k"

# VCS style formats.
FMT_UNTRACKED="%{$reset_background%} %{$fg_red%}%{$reset_text%} "
FMT_UNSTAGED="%{$reset_fg%} %{$fg_yellow%} "
FMT_STAGED="%{$reset_fg%} %{$fg_green%} "

FMT_ACTION="(%{$fg_green%}%a%{$reset_fg%})"

FMT_VCS_STATUS="%{$fg_subtext0%}  %b%u%c%{$reset_fg%}"

zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true

zstyle ':vcs_info:*' unstagedstr    "${FMT_UNSTAGED}"
zstyle ':vcs_info:*' stagedstr      "${FMT_STAGED}"
zstyle ':vcs_info:*' actionformats  "${FMT_VCS_STATUS} ${FMT_ACTION}"
zstyle ':vcs_info:*' formats        "${FMT_VCS_STATUS}"
zstyle ':vcs_info:*' nvcsformats    ""

zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

# Check for untracked files.
+vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
            git status --porcelain | grep --max-count=1 '^??' &> /dev/null; then
        hook_com[unstaged]="${FMT_UNTRACKED}${hook_com[unstaged]}"
    fi
}

# Executed before each prompt.
add-zsh-hook precmd vcs_info

USER_NAME=$'%{$fg_mauve%}%{$fg_crust%}%B%{$bg_mauve%}%n@%m%f%b%{$fg_overlay0%} %{$reset_fg%}%{$reset_bg%}'

DIR=$'%{$bg_overlay0%}%{$fg_crust%} %B %1~%b%{$reset_bg%}%{$fg_overlay0%}%{$reset_fg%}'

GIT_INFO=$'%B${vcs_info_msg_0_}%b'

INPUT_LINE=$'\n%(?.%{$fg_text%}.%{$fg_red%})%(!.#.$)%{$reset_fg%} '

PROMPT="${USER_NAME}${DIR}${GIT_INFO}${INPUT_LINE}"

