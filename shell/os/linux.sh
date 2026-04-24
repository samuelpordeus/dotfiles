# Linux-only shell config. Sourced by zshrc when on Linux (primarily Ubuntu VPS).

# Network — primary interface varies; use `ip route` to find the default.
alias lip="ip -4 -o addr show scope global | awk '{print \$2, \$4}'"

# Clipboard — try xclip (X11), wl-copy (Wayland); gracefully no-op on headless VPS.
if command -v xclip >/dev/null 2>&1; then
  alias key="xclip -selection clipboard < ~/.ssh/id_rsa.pub && echo 'SSH key copied to clipboard!'"
elif command -v wl-copy >/dev/null 2>&1; then
  alias key="wl-copy < ~/.ssh/id_rsa.pub && echo 'SSH key copied to clipboard!'"
else
  alias key="cat ~/.ssh/id_rsa.pub"
fi

# System
alias update="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"
alias alert='notify-send "Back to work!" "Stuff is done." 2>/dev/null; printf "\a"'
