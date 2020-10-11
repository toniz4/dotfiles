# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
stty stop undef		# Disable ctrl-s to freeze terminal.

autoload -U zcalc

# branch indicator
function precmd {
	vcs_info
}
autoload -Uz vcs_info

zstyle ':vcs_info:git:*' formats '%b%c%u '
#zstyle ':vcs_info:*:*' stagedstr         "%F{green} *%f"
#zstyle ':vcs_info:*:*' unstagedstr       "%F{red} *%f"
#zstyle ':vcs_info:git:*' check-for-changes true

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
PS1='%B%F{cyan}${vcs_info_msg_0_}%F{magenta}%0~%F{bwhite}%(?..%F{red}) \$ %f%b'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan"

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history


# Basic auto/tab complete:
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zmodload zsh/complist
_comp_options+=(globdots)		# Include hidden files.
autoload predict-on

# Aliases
source $HOME/.config/zsh/zshalias
#source $HOME/.config/zsh/.gitplugin.zsh

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        /bin/rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect '\x1b' zle-line-finish
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
	# initiate `vi insert` as keymap
	# (can be removed if `bindkey -V` has been set elsewhere)
    zle -K viins
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

source ~/.config/zsh/.zinit/bin/zinit.zsh

# zinit plugins
zinit wait lucid light-mode for \
 	atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
		zdharma/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start; FAST_HIGHLIGHT[chroma-man]=" \
        zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions \
        kutsan/zsh-system-clipboard \
		OMZP::git
