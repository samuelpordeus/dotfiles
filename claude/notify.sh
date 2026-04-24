#!/usr/bin/env bash
# Cross-platform desktop notification for Claude Code hooks.
# Usage: notify.sh "subtitle" "message"

subtitle="${1:-Claude Code}"
message="${2:-}"
title="Claude Code"

if command -v osascript >/dev/null 2>&1; then
  osascript -e "display notification \"$message\" with title \"$title\" subtitle \"$subtitle\"" 2>/dev/null || true
elif command -v notify-send >/dev/null 2>&1; then
  notify-send "$title" "$subtitle: $message" 2>/dev/null || true
elif command -v terminal-notifier >/dev/null 2>&1; then
  terminal-notifier -title "$title" -subtitle "$subtitle" -message "$message" 2>/dev/null || true
fi
exit 0
