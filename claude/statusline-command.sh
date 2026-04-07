#!/usr/bin/env bash

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# Project name only (last segment of path)
if [ -n "$cwd" ]; then
  dir=$(basename "$cwd")
else
  dir="?"
fi

# Git branch
branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)

# Build output
out=""

# Directory segment (cyan)
out="${out}$(printf '\033[0;36m%s\033[0m' "$dir")"

# Git branch segment (magenta)
if [ -n "$branch" ]; then
  out="${out} $(printf '\033[0;35m\ue0a0 %s\033[0m' "$branch")"
fi

# Model segment (dim)
if [ -n "$model" ]; then
  out="${out} $(printf '\033[2m%s\033[0m' "$model")"
fi

# Context remaining
if [ -n "$remaining" ]; then
  remaining_int=$(printf '%.0f' "$remaining")
  used_int=$((100 - remaining_int))
  if [ "$remaining_int" -le 20 ]; then
    color='\033[0;31m'
  elif [ "$remaining_int" -le 50 ]; then
    color='\033[0;33m'
  else
    color='\033[0;32m'
  fi
  out="${out} $(printf "${color}%s%% ctx used\033[0m" "$used_int")"
fi

printf '%s' "$out"
