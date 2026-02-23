fastfetch

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Prompt (Powerlevel10k)
[[ -f "${ZDOTDIR}/p10k.zsh" ]] && source "${ZDOTDIR}/p10k.zsh"


# mouse
function zle-keymap-select {
	if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
		echo -ne '\e[1 q'
	elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
		echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

# Use beam shape cursor on startup.
echo -ne '\e[5 q'

# Use beam shape cursor for each new prompt.
preexec() {
	echo -ne '\e[5 q'
}

_fix_cursor() {
	echo -ne '\e[5 q'
}
precmd_functions+=(_fix_cursor)

KEYTIMEOUT=1

# Zsh options
export HISTFILE="$XDG_STATE_HOME/zsh/.zsh_history"
# Ensure history directory exists
[[ -d ${HISTFILE:h} ]] || mkdir -p ${HISTFILE:h}

export HISTSIZE=5000
export SAVEHIST=5000
export HISTDUP=erase


setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY


bindkey -v
export KEYTIMEOUT=1
WORDCHARS=${WORDCHARS//[\/]}

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# modules

## Compeltion
zstyle ':zim:completion' dumpfile "${XDG_STATE_HOME}/zsh/.zcompdump"
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME}/zsh/zcompcache"


zstyle ':zim:*' case-sensitivity insensitive

## Git
zstyle ':zim:git' aliases-prefix 'g'

## Input
zstyle ':zim:input' double-dot-expand yes

## Termtitle
zstyle ':zim:termtitle' format '%1~'

## zsh-autosuggestions
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

# zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# Initialize Zim
export ZIM_HOME="${XDG_DATA_HOME}/zim"

# Download zimfw plugin manager if missing
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi

# Install missing modules and update init.zsh if missing/outdated
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi

# Initialize modules
source ${ZIM_HOME}/init.zsh


# Post-init Configuration
## zsh-history-substring-search
zmodload -F zsh/terminfo +p:terminfo
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history


# Lazy load Conda
export CONDA_BASE="$HOME/miniconda3"

_conda_lazy_load() {
  unfunction conda 2>/dev/null || unset -f conda 2>/dev/null

  if [ -f "$CONDA_BASE/etc/profile.d/conda.sh" ]; then
    . "$CONDA_BASE/etc/profile.d/conda.sh"
  else
    export PATH="$CONDA_BASE/bin:$PATH"
  fi

  conda "$@"
}

conda() {
  _conda_lazy_load "$@"
}


# yazi launcher (file manager)
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}


# zoxide
eval "$(zoxide init zsh)"

# fzf
if [[ ! "$PATH" == */home/hsppp/.config/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/hsppp/.config/fzf/bin"
fi
source <(fzf --zsh)

# Aliases
alias ls="ls --color"
alias ll="ls -lh"
alias la="ls -A"
alias lla="ls -lha"

alias nk="nvim"
alias nl='NVIM_APPNAME="nvim-lazy" nvim'
alias nn='NVIM_APPNAME="nvim-normal" nvim'
alias nv='NVIM_APPNAME="nvim-nvchad" nvim'
alias lc='nvim leetcode.nvim'

alias cd='z'
