#!/usr/bin/env bash

set -Eeuo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
STOW_PACKAGES=(zsh git nvim fastfetch tmux fzf)

log() {
  printf '\n==> %s\n' "$*"
}

warn() {
  printf 'warning: %s\n' "$*" >&2
}

run_as_root() {
  if [[ $EUID -eq 0 ]]; then
    "$@"
  elif command -v sudo >/dev/null 2>&1; then
    sudo "$@"
  else
    printf 'error: sudo is required to install system packages\n' >&2
    exit 1
  fi
}

install_macos_packages() {
  if ! command -v brew >/dev/null 2>&1; then
    log "Installing Homebrew"
    NONINTERACTIVE=1 /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi

  log "Installing macOS packages"
  brew install \
    stow git curl zsh neovim tmux fzf zoxide fastfetch \
    fd bat tree direnv yazi
}

install_apt_packages() {
  local packages=(
    stow git curl zsh neovim tmux fzf zoxide fastfetch
    fd-find bat tree direnv yazi
  )
  local available=()
  local package

  log "Refreshing APT package metadata"
  run_as_root apt-get update

  for package in "${packages[@]}"; do
    if apt-cache show "$package" >/dev/null 2>&1; then
      available+=("$package")
    else
      warn "$package is not available from the configured APT repositories; skipping"
    fi
  done

  log "Installing Debian/Ubuntu packages"
  run_as_root apt-get install -y "${available[@]}"

  # Debian-based distributions rename these commands to avoid name conflicts.
  mkdir -p "$HOME/.local/bin"
  if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
    ln -sfn "$(command -v fdfind)" "$HOME/.local/bin/fd"
  fi
  if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
    ln -sfn "$(command -v batcat)" "$HOME/.local/bin/bat"
  fi
}

install_linux_packages() {
  if command -v apt-get >/dev/null 2>&1; then
    install_apt_packages
  elif command -v dnf >/dev/null 2>&1; then
    log "Installing Fedora packages"
    run_as_root dnf install -y \
      stow git curl zsh neovim tmux fzf zoxide fastfetch \
      fd-find bat tree direnv yazi
  elif command -v pacman >/dev/null 2>&1; then
    log "Installing Arch Linux packages"
    run_as_root pacman -Syu --needed --noconfirm \
      stow git curl zsh neovim tmux fzf zoxide fastfetch \
      fd bat tree direnv yazi
  else
    printf 'error: supported Linux package manager not found (apt, dnf, or pacman)\n' >&2
    exit 1
  fi
}

case "$(uname -s)" in
  Darwin)
    install_macos_packages
    ;;
  Linux)
    install_linux_packages
    ;;
  *)
    printf 'error: unsupported operating system: %s\n' "$(uname -s)" >&2
    exit 1
    ;;
esac

command -v stow >/dev/null 2>&1 || {
  printf 'error: GNU Stow was not installed successfully\n' >&2
  exit 1
}

log "Initializing Git submodules"
git -C "$DOTFILES_DIR" submodule update --init --recursive

log "Linking dotfiles into $HOME"
stow --dir="$DOTFILES_DIR" --target="$HOME" --restow "${STOW_PACKAGES[@]}"

TPM_DIR="$HOME/.local/share/tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR/.git" ]]; then
  log "Installing tmux plugin manager"
  mkdir -p "$(dirname "$TPM_DIR")"
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  log "tmux plugin manager is already installed"
fi

log "Dotfiles setup complete"
