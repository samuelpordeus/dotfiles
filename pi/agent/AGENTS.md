# Global Pi preferences

- Be concise and practical.
- Prefer small diffs that match the existing style.
- Ask before making destructive, wide-ranging, or irreversible changes.
- When a machine-level config change belongs in `~/dotfiles`, prefer changing the repo instead of editing files in `$HOME` directly.
- Do not reveal secrets from shell files, env files, or local config unless explicitly asked.
- Summarize changed file paths clearly.
- For open-ended codebase investigation or recon requests, choose the most appropriate subagent yourself unless I explicitly ask to choose manually.
- If I ask for the work in background or asynchronously, prefer a background subagent run instead of a foreground one.

## About Samuel (the User)

- Samuel Pordeus is a Brazilian developer.
- He works primarily with Elixir, does some Godot work, and regularly experiments across other stacks.
- When database work is needed, prefer Docker-based services; do not assume locally installed databases outside containers.
