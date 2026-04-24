#!/usr/bin/env bash
# One-shot dotfiles installer for Ubuntu/Debian Linux.
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/samuelpordeus/dotfiles/main/install-linux.sh | bash
set -euo pipefail

DOTFILES="$HOME/dotfiles"
REPO="https://github.com/samuelpordeus/dotfiles.git"

log() { printf '\n\033[1;34m==>\033[0m %s\n' "$*"; }

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This installer targets Debian/Ubuntu (apt). Aborting." >&2
  exit 1
fi

log "Installing system packages"
sudo apt-get update
sudo apt-get install -y \
  git curl zsh build-essential \
  libnotify-bin \
  fzf ripgrep \
  direnv \
  unzip ca-certificates

# exa was renamed to eza; install whichever is available.
if ! sudo apt-get install -y exa 2>/dev/null; then
  sudo apt-get install -y eza || log "Neither exa nor eza available; 'ls' alias may need adjustment."
fi

log "Installing oh-my-zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  log "  already present"
fi

log "Installing powerlevel10k theme"
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
  log "  already present"
fi

log "Installing asdf"
if [ ! -d "$HOME/.asdf" ]; then
  git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.14.0
else
  log "  already present"
fi

log "Cloning dotfiles"
if [ ! -d "$DOTFILES" ]; then
  git clone "$REPO" "$DOTFILES"
else
  log "  already present, pulling latest"
  git -C "$DOTFILES" pull --ff-only
fi

log "Linking configs"
bash "$DOTFILES/setup.sh"

log "Setting zsh as default shell"
if [ "${SHELL:-}" != "$(command -v zsh)" ]; then
  chsh -s "$(command -v zsh)" || log "  chsh failed; run manually: chsh -s \$(command -v zsh)"
fi

log "Done. Start a new shell or run: exec zsh"
