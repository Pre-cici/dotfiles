export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export PYTHON_HISTORY=$XDG_STATE_HOME/python_history
export PYTHONPYCACHEPREFIX=$XDG_CACHE_HOME/python
export PYTHONUSERBASE=$XDG_DATA_HOME/python

export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc

export GIT_CONFIG_GLOBAL=$XDG_CONFIG_HOME/git/config

export HF_HOME=$XDG_CACHE_HOME/huggingface
export HF_ENDPOINT=https://hf-mirror.com
export HF_ENABLE_PARALLEL_LOADING="YES"

export EDITOR="nvim"
export VISUAL="nvim"

export LANG=en_US.UTF-8

export PATH="$HOME/.local/bin:$PATH"

case "$OSTYPE" in
  darwin*)
    export PATH="/opt/homebrew/bin:$PATH"
    ;;
  linux*)
    if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
    ;;
esac
