# Fastfetch
(( $+commands[fastfetch] )) && fastfetch

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

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# -----------------------------------------------------------------------------
# Cursor shape
# -----------------------------------------------------------------------------

if [[ ${TERM:-dumb} != dumb ]]; then
  function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] || [[ $1 == 'block' ]]; then
      print -n $'\e[1 q'
    elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ -z ${KEYMAP} ]] || [[ $1 == 'beam' ]]; then
      print -n $'\e[5 q'
    fi
  }
  zle -N zle-keymap-select

  _fix_cursor() {
    print -n $'\e[5 q'
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook preexec _fix_cursor
  add-zsh-hook precmd _fix_cursor
  _fix_cursor
fi

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

export ZIM_HOME="${XDG_DATA_HOME}/zim"

if [[ ! -r "${ZIM_HOME}/zimfw.zsh" ]]; then
  _zimfw_version='1.20.0'
  _zimfw_tmp="${ZIM_HOME}/zimfw.zsh.tmp.$$"
  _zimfw_downloaded=0
  mkdir -p "${ZIM_HOME}"

  if (( ${+commands[curl]} )); then
    command curl -fsSL -o "${_zimfw_tmp}" \
      "https://github.com/zimfw/zimfw/releases/download/v${_zimfw_version}/zimfw.zsh" && _zimfw_downloaded=1
  elif (( ${+commands[wget]} )); then
    command wget -q -O "${_zimfw_tmp}" \
      "https://github.com/zimfw/zimfw/releases/download/v${_zimfw_version}/zimfw.zsh" && _zimfw_downloaded=1
  else
    print -u2 'Zim bootstrap requires curl or wget.'
  fi

  if (( _zimfw_downloaded )) && [[ -s "${_zimfw_tmp}" ]]; then
    command mv -f "${_zimfw_tmp}" "${ZIM_HOME}/zimfw.zsh"
  else
    command rm -f "${_zimfw_tmp}"
    print -u2 'Failed to download zimfw.'
  fi

  unset _zimfw_downloaded _zimfw_tmp _zimfw_version
fi

if [[ -r "${ZIM_HOME}/zimfw.zsh" && ! "${ZIM_HOME}/init.zsh" -nt "${ZIM_CONFIG_FILE:-${ZDOTDIR}/.zimrc}" ]]; then
  source "${ZIM_HOME}/zimfw.zsh" init
fi

_zim_loaded=0
if [[ -r "${ZIM_HOME}/init.zsh" ]]; then
  source "${ZIM_HOME}/init.zsh" && _zim_loaded=1
else
  print -u2 "Zim init file not found: ${ZIM_HOME}/init.zsh"
fi

if (( _zim_loaded && ${+parameters[FAST_HIGHLIGHT_STYLES]} )); then
  FAST_HIGHLIGHT_STYLES[comment]='fg=#908caa'
fi

# Zim's environment module sets larger defaults; keep the configured limits.
HISTSIZE=5000
SAVEHIST=5000
setopt SHARE_HISTORY
unsetopt INC_APPEND_HISTORY

# -----------------------------------------------------------------------------
# Post-init config
# -----------------------------------------------------------------------------

if (( _zim_loaded )); then
  zmodload -F zsh/terminfo +p:terminfo
  for key in '^[[A' '^P' "${terminfo[kcuu1]}"; do
    [[ -n ${key} ]] && bindkey "${key}" history-substring-search-up
  done
  for key in '^[[B' '^N' "${terminfo[kcud1]}"; do
    [[ -n ${key} ]] && bindkey "${key}" history-substring-search-down
  done
  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M vicmd 'j' history-substring-search-down
  unset key

  zmodload zsh/complist
  bindkey -M menuselect 'h' vi-backward-char
  bindkey -M menuselect 'j' vi-down-line-or-history
  bindkey -M menuselect 'k' vi-up-line-or-history
  bindkey -M menuselect 'l' vi-forward-char
fi
unset _zim_loaded

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
(( ${+commands[zoxide]} )) && eval "$(zoxide init zsh)"
(( ${+commands[zoxide]} )) && alias cd='z'

# direnv
export DIRENV_LOG_FORMAT=
(( ${+commands[direnv]} )) && eval "$(direnv hook zsh)"

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

(( ${+commands[fzf]} )) && source <(fzf --zsh)

# WSL-only tools
if grep -qi "microsoft" /proc/version 2>/dev/null || [[ -n "$WSL_DISTRO_NAME" ]]; then
  [[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

  export NVM_DIR="${XDG_CONFIG_HOME}/nvm"
  [[ -s "${NVM_DIR}/nvm.sh" ]] && source "${NVM_DIR}/nvm.sh"
fi

# ---- conda lazy loading ----
export CONDA_HOME="$HOME/miniconda3"

conda() {
  local conda_exe="$CONDA_HOME/bin/conda"
  local conda_setup

  if [[ ! -x "$conda_exe" ]]; then
    print -u2 "conda not found at $conda_exe"
    return 1
  fi

  unset -f conda
  conda_setup="$("$conda_exe" shell.zsh hook 2>/dev/null)"
  if [[ -n "$conda_setup" ]] && eval "$conda_setup" && (( ${+functions[conda]} )); then
    conda "$@"
  else
    path=("$CONDA_HOME/bin" $path)
    "$conda_exe" "$@"
  fi
}

activate() {
  conda activate "$@"
}

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------

alias nk='nvim'
alias nl='NVIM_APPNAME="nvim-lazy" nvim'
alias nn='NVIM_APPNAME="nvim-normal" nvim'
alias nv='NVIM_APPNAME="nvim-nvchad" nvim'
alias leet='nvim +"Leet"'

alias op='opencode --port'

# Obsidian CLI alias
alias ob='notesmd-cli'
alias obd='notesmd-cli daily'
alias obst='notesmd-cli search'
obnote() { notesmd-cli create "$1" --content "$2" --open; }
