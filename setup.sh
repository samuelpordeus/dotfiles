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

# Link every top-level item from a repo directory into a target directory.
# This keeps the app-specific layout explicit while avoiding one link() call
# per new file or folder.
link_dir_contents() {
  local src_dir="$1" dst_dir="$2"
  local item name

  mkdir -p "$dst_dir"

  shopt -s nullglob dotglob
  for item in "$src_dir"/*; do
    name="$(basename "$item")"
    link "$item" "$dst_dir/$name"
  done
  shopt -u nullglob dotglob
}

# Shell
link "$DOTFILES/zshrc" "$HOME/.zshrc"
link "$DOTFILES/gitconfig" "$HOME/.gitconfig"
link "$DOTFILES/iex.exs" "$HOME/.iex.exs"

# Claude Code
link_dir_contents "$DOTFILES/claude" "$HOME/.claude"

# Pi
link_dir_contents "$DOTFILES/pi/agent" "$HOME/.pi/agent"

echo "Done!"
