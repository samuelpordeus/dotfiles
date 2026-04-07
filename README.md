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
- `~/.claude/settings.json`, `commands/`, `statusline-command.sh` — Claude Code config

## Structure

```
shell/
  aliases.sh    — shell aliases
  exports.sh    — env vars and PATH
  plugins.sh    — oh-my-zsh plugins
  asdf.sh       — asdf version manager
  others.sh     — direnv, misc tools
  secrets.sh    — API keys (gitignored)
claude/
  settings.json       — Claude Code settings
  commands/           — custom slash commands
  statusline-command.sh — status line script
```
