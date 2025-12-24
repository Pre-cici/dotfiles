fastfetch

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ======================================
#  Powerlevel10k Instant Prompt
# ======================================
if [[ -r "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --------------------------------------
# Zsh options
# --------------------------------------
export HISTFILE="$XDG_STATE_HOME/zsh/.zsh_history"
export HISTSIZE=5000
export SAVEHIST=5000

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8


setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
bindkey -v
export KEYTIMEOUT=1
WORDCHARS=${WORDCHARS//[\/]}

cursor_mode() {
    cursor_block=$'\e]50;CursorShape=0\a'
    cursor_beam=$'\e]50;CursorShape=1\a'

    function zle-keymap-select {
        if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
            echo -ne $cursor_block
        elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ $1 = 'beam' ]]; then
            echo -ne $cursor_beam
        fi
    }

    zle-line-init() {
        echo -ne $cursor_beam
    }

    zle -N zle-keymap-select
    zle -N zle-line-init
}

cursor_mode

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# --------------------------------------
# modules
# --------------------------------------
zstyle ':zim:completion' dumpfile "${XDG_CACHE_HOME}/zsh/.zcompdump"
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
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

## zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
# typeset -A ZSH_HIGHLIGHT_STYLES
# ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# --------------------------------------
#  Initialize Zim
# --------------------------------------
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


# --------------------------------------
#  Post-init Configuration
# --------------------------------------
## zsh-history-substring-search
zmodload -F zsh/terminfo +p:terminfo
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key

# ======================================
#  Lazy load Conda
# ======================================
export CONDA_BASE="$HOME/miniconda3"

_conda_lazy_load() {
  unset -f conda
  if [ -f "$CONDA_BASE/etc/profile.d/conda.sh" ]; then
    . "$CONDA_BASE/etc/profile.d/conda.sh"
  else
    export PATH="$CONDA_BASE/bin:$PATH"
  fi
  if [ "$#" -gt 0 ]; then
    command conda "$@"
  fi
}

conda() {
  _conda_lazy_load "$@"
}

# ======================================
#  yazi launcher (file manager)
# ======================================
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# ======================================
#  Lazy load NVM (Node.js)
# ======================================
# export NVM_DIR="$HOME/.nvm"
#
# load_nvm() {
#   if [ -s "$NVM_DIR/nvm.sh" ]; then
#     unset -f nvm node npm npx
#     . "$NVM_DIR/nvm.sh" --no-use
#   fi
# }
#
# nvm()  { load_nvm; nvm "$@"; }
# node() { load_nvm; node "$@"; }
# npm()  { load_nvm; npm "$@"; }
# npx()  { load_nvm; npx "$@"; }
#
# --------------------------------------
#  Aliases
# --------------------------------------
alias reload="source ~/.zshenv"
alias ll="ls -lh"
alias la="ls -A"
alias lla="ls -lha"
alias vim="nvim"
alias vi="nvim"

# --------------------------------------
#  Prompt (Powerlevel10k)
# --------------------------------------
[[ -f "${ZDOTDIR}/p10k.zsh" ]] && source "${ZDOTDIR}/p10k.zsh"
