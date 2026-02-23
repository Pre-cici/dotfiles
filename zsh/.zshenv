export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export CONDARC="$XDG_CONFIG_HOME/conda/.condarc"

export PYTHON_HISTORY=$XDG_STATE_HOME/python_history
export PYTHONPYCACHEPREFIX=$XDG_CACHE_HOME/python
export PYTHONUSERBASE=$XDG_DATA_HOME/python

export EDITOR="nvim"
export VISUAL="nvim"

export PATH="$HOME/.local/bin:$PATH"

source "$HOME/.cargo/env"

# nvm
export NVM_DIR="$XDG_CONFIG_HOME/nvm"
source "$NVM_DIR/nvm.sh"


export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
