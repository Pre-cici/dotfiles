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

if grep -qi "microsoft" /proc/version 2>/dev/null || [ -n "$WSL_DISTRO_NAME" ]; then
    # For WSL (Windows Subsystem for Linux)
    source "$HOME/.cargo/env"  # For Rust
    export NVM_DIR="$XDG_CONFIG_HOME/nvm"
    source "$NVM_DIR/nvm.sh"  # For nvm
elif [[ "$(uname)" == "Darwin" ]]; then
    # For macOS
    # If you're using Homebrew, you generally don't need to manually source env files for Rust or nvm.
    # But if needed, you can add custom paths here.
    export PATH="$PATH:/opt/homebrew/bin"
fi
