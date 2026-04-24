# dotfiles

## Setup

### macOS

```sh
git clone git@github.com:samuelpordeus/dotfiles.git ~/dotfiles
~/dotfiles/setup.sh
```

### Ubuntu / Linux VPS (one-shot)

```sh
curl -fsSL https://raw.githubusercontent.com/samuelpordeus/dotfiles/main/install-linux.sh | bash
```

Installs apt deps (git, zsh, fzf, ripgrep, eza/exa, direnv, libnotify-bin), oh-my-zsh, powerlevel10k, asdf, then clones and links the dotfiles.

This symlinks everything into place:

- `~/.zshrc` — shell config (sources `zshrc` which loads everything from `shell/`)
- `~/.gitconfig` — git aliases and settings
- `~/.iex.exs` — Elixir/IEx config
- everything under `claude/` → `~/.claude/`
- everything under `pi/agent/` → `~/.pi/agent/`

That means new top-level files or folders inside `claude/` or `pi/agent/` get linked automatically without changing `setup.sh`.

## Structure

```
shell/
  aliases.sh    — shared aliases (cross-platform)
  exports.sh    — env vars and PATH (Homebrew prefix auto-detected)
  plugins.sh    — oh-my-zsh plugins + fzf keybindings (macOS & Linux paths)
  asdf.sh       — asdf version manager
  others.sh     — direnv, misc tools
  secrets.sh    — API keys (gitignored)
  os/
    macos.sh    — macOS-only aliases (pbcopy, defaults, /Applications, …)
    linux.sh    — Linux-only aliases (xclip, apt update, …)
claude/
  settings.json       — Claude Code settings
  commands/           — custom slash commands
  statusline-command.sh — status line script
pi/
  agent/
    settings.json     — Pi global settings
    AGENTS.md         — Pi global instructions
    agents/           — custom Pi subagents
    extensions/       — custom Pi extensions
```
