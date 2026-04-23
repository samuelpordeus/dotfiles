# AGENTS.md

This repository is my personal dotfiles setup.

## Goals
- Keep the repo simple and readable.
- Prefer small, targeted changes over big rewrites.
- Preserve the current symlink-based setup flow.

## Repo conventions
- Edit the source files in this repo, not the files under `$HOME`.
- When adding a new managed config, update both `setup.sh` and `README.md`.
- Keep shell config split under `shell/`; keep `zshrc` as the loader.
- Keep app-specific config in app-specific directories like `claude/`, `ghostty/`, and `pi/`.
- Prefer macOS/Homebrew-friendly paths unless told otherwise.

## Safety
- Do not read from or modify `shell/secrets.sh` unless explicitly asked.
- Never print, copy, or commit secrets.
- Call out any destructive or machine-specific change before making it.

## Validation
- For setup changes, validate with `bash -n setup.sh`.
- For shell loader changes, validate with `zsh -n zshrc` when relevant.
