# fastfetch
fastfetch

# Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Prompt
[[ -f "${ZDOTDIR}/p10k.zsh" ]] && source "${ZDOTDIR}/p10k.zsh"

# -----------------------------------------------------------------------------
# Shell behavior
# -----------------------------------------------------------------------------

KEYTIMEOUT=1
bindkey -v
WORDCHARS=${WORDCHARS//[\/]}

# History
export HISTFILE="$XDG_STATE_HOME/zsh/history"
[[ -d ${HISTFILE:h} ]] || mkdir -p "${HISTFILE:h}"

export HISTSIZE=5000
export SAVEHIST=5000

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# -----------------------------------------------------------------------------
# Cursor shape
# -----------------------------------------------------------------------------

function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 == 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ -z ${KEYMAP} ]] || [[ $1 == 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

echo -ne '\e[5 q'

preexec() {
  echo -ne '\e[5 q'
}

_fix_cursor() {
  echo -ne '\e[5 q'
}
precmd_functions+=(_fix_cursor)

# -----------------------------------------------------------------------------
# Zim
# -----------------------------------------------------------------------------

zstyle ':zim:completion' dumpfile "${XDG_STATE_HOME}/zsh/.zcompdump"
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME}/zsh/zcompcache"
zstyle ':zim:*' case-sensitivity insensitive
zstyle ':zim:git' aliases-prefix 'g'
zstyle ':zim:input' double-dot-expand yes
zstyle ':zim:termtitle' format '%1~'

ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

export ZIM_HOME="${XDG_DATA_HOME}/zim"

if [[ ! -e "${ZIM_HOME}/zimfw.zsh" ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o "${ZIM_HOME}/zimfw.zsh" \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p "${ZIM_HOME}" && wget -nv -O "${ZIM_HOME}/zimfw.zsh" \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi

if [[ ! "${ZIM_HOME}/init.zsh" -nt "${ZIM_CONFIG_FILE:-${ZDOTDIR}/.zimrc}" ]]; then
  source "${ZIM_HOME}/zimfw.zsh" init
fi

source "${ZIM_HOME}/init.zsh"

# -----------------------------------------------------------------------------
# Post-init config
# -----------------------------------------------------------------------------

zmodload -F zsh/terminfo +p:terminfo
for key in '^[[A' '^P' "${terminfo[kcuu1]}"; do
  bindkey "${key}" history-substring-search-up
done
for key in '^[[B' '^N' "${terminfo[kcud1]}"; do
  bindkey "${key}" history-substring-search-down
done
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
unset key

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------

function y() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")" || return 1
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [[ -n "$cwd" && "$cwd" != "$PWD" ]] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

proxy_on() {
  export http_proxy="http://127.0.0.1:7890"
  export https_proxy="http://127.0.0.1:7890"
  export HTTP_PROXY="$http_proxy"
  export HTTPS_PROXY="$https_proxy"
  echo "Proxy enabled"
}

proxy_off() {
  unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
  echo "Proxy disabled"
}

# -----------------------------------------------------------------------------
# Tools
# -----------------------------------------------------------------------------

# zoxide
eval "$(zoxide init zsh)"

# fzf
export FZF_DEFAULT_OPTS_FILE="$XDG_CONFIG_HOME/fzf/config"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# fzf file
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target,dist,build,.venv,venv,__pycache__
  --preview 'if [ -d {} ]; then tree -C {} | head -200; else bat -n --color=always {}; fi'
  --bind 'ctrl-/:change-preview-window(right,60%|down,50%|hidden|)'
"

# fzf command
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --header 'CTRL-Y 复制命令'
"

# fzf dir
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target,dist,build,.venv,venv,__pycache__
  --preview 'tree -C {} | head -200'
"

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

fcd() {
  local dir
  dir=$(fd --type d --hidden --follow --exclude .git . | fzf) || return
  cd "$dir"
}

fe() {
  local file
  file=$(fd --type f --hidden --follow --exclude .git . | fzf --preview 'bat -n --color=always {}') || return
  nvim "$file"
}

source <(fzf --zsh)

# WSL-only tools
if grep -qi "microsoft" /proc/version 2>/dev/null || [[ -n "$WSL_DISTRO_NAME" ]]; then
  [[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

  export NVM_DIR="${XDG_CONFIG_HOME}/nvm"
  [[ -s "${NVM_DIR}/nvm.sh" ]] && source "${NVM_DIR}/nvm.sh"
fi

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------

alias ls='ls -G'
alias ll='ls -lh'
alias la='ls -A'
alias lla='ls -lha'

alias nk='nvim'
alias nl='NVIM_APPNAME="nvim-lazy" nvim'
alias nn='NVIM_APPNAME="nvim-normal" nvim'
alias nv='NVIM_APPNAME="nvim-nvchad" nvim'
alias leet='nvim +"Leet"'

alias cd='z'

# -----------------------------------------------------------------------------
# Mamba
# -----------------------------------------------------------------------------

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE='/opt/homebrew/bin/mamba'
export MAMBA_ROOT_PREFIX='/Users/hsp/.local/share/mamba'
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
  eval "$__mamba_setup"
else
  alias mamba="$MAMBA_EXE"
fi
unset __mamba_setup
# <<< mamba initialize <<<
