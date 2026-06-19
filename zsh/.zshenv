# Skip global compinit
export skip_global_compinit=1

# XDG Base Directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Zsh config directory
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Python
export PYTHON_HISTORY="$XDG_STATE_HOME/python_history"
export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/python"
export PYTHONUSERBASE="$XDG_DATA_HOME/python"

# npm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

# Git
export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME/git/config"

# Hugging Face
export HF_HOME="$XDG_CACHE_HOME/huggingface"
export HF_ENDPOINT="https://hf-mirror.com"
export HF_ENABLE_PARALLEL_LOADING="YES"

# Editor
export EDITOR="nvim"
export VISUAL="nvim"

# Locale
export LANG="en_US.UTF-8"

# Cargo / Rust
export CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"
export RUSTUP_HOME="${RUSTUP_HOME:-$HOME/.rustup}"

# PATH

[[ -d "$HOME/.local/bin" ]] && path=("$HOME/.local/bin" $path)
[[ -d "$CARGO_HOME/bin" ]] && path=("$CARGO_HOME/bin" $path)

export PATH
