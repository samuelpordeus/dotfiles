# dotfiles

## Setup

```sh
git clone git@github.com:samuelpordeus/dotfiles.git ~/dotfiles
~/dotfiles/setup.sh
```

This symlinks everything into place:

- `~/.zshrc` — shell config (sources `zshrc` which loads everything from `shell/`)
- `~/.gitconfig` — git aliases and settings
- `~/.iex.exs` — Elixir/IEx config
- everything under `ghostty/` → `~/.config/ghostty/`
- everything under `claude/` → `~/.claude/`
- everything under `pi/agent/` → `~/.pi/agent/`

That means new top-level files or folders inside `ghostty/`, `claude/`, or `pi/agent/` get linked automatically without changing `setup.sh`.

## Structure

```
shell/
  aliases.sh    — shell aliases
  exports.sh    — env vars and PATH
  plugins.sh    — oh-my-zsh plugins
  asdf.sh       — asdf version manager
  others.sh     — direnv, misc tools
  secrets.sh    — API keys (gitignored)
ghostty/
  config              — Ghostty terminal settings
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
