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
- each skill under `claude/skills/` → `~/.claude/skills/<name>` (the folder itself stays local, since Claude keeps its own synced skills there)

That means new top-level files or folders inside `claude/` or `claude/skills/` get linked automatically without changing `setup.sh`.

## Structure

```
shell/
  aliases.sh    — shared aliases (cross-platform)
  exports.sh    — env vars and PATH (Homebrew prefix auto-detected)
  plugins.sh    — oh-my-zsh plugins + fzf keybindings (macOS & Linux paths)
  asdf.sh       — asdf version manager
  others.sh     — direnv, misc tools
  secrets_1p.sh — loads API keys from 1Password (see Secrets below)
  secrets.sh    — optional local-only overrides (gitignored)
  os/
    macos.sh    — macOS-only aliases (pbcopy, defaults, /Applications, …)
    linux.sh    — Linux-only aliases (xclip, apt update, …)
claude/
  CLAUDE.md           — global Claude Code instructions (all projects)
  settings.json       — Claude Code settings
  skills/             — global Claude Code skills (available in every session)
  statusline-command.sh — status line script
```

## Secrets

API keys are stored in the 1Password document `dotfiles-secrets` (Private vault), not in the repo. On shell startup, `shell/secrets_1p.sh` fetches it with the 1Password CLI and evals it, so it needs `op` installed and signed in (it's skipped silently if `op` isn't available).

- `secrets` — opens the document in `nano`, saves it back to 1Password, and re-sources it in the current shell.
