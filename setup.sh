#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"

echo "Setting up dotfiles..."

# Helper to create a symlink, backing up any existing file
link() {
  local src="$1" dst="$2"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -e "$dst" ]; then
    echo "  Backing up $dst -> ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "  $dst -> $src"
}

# Shell
link "$DOTFILES/zshrc" "$HOME/.zshrc"
link "$DOTFILES/gitconfig" "$HOME/.gitconfig"
link "$DOTFILES/iex.exs" "$HOME/.iex.exs"
link "$DOTFILES/ghostty/config" "$HOME/.config/ghostty/config"

# Claude Code
link "$DOTFILES/claude/settings.json" "$HOME/.claude/settings.json"
link "$DOTFILES/claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"
link "$DOTFILES/claude/commands" "$HOME/.claude/commands"

echo "Done!"
