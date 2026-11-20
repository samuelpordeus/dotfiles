# Secrets live in the 1Password document "dotfiles-secrets" (personal account, vault: Private).

SECRETS_OP_ARGS=(--vault Private --account RPUJGSDSRVFQNETYRAJG6F2S6Q)

if command -v op >/dev/null 2>&1; then
  eval "$(op document get dotfiles-secrets "${SECRETS_OP_ARGS[@]}" 2>/dev/null)"
fi

secrets() {
  local tmp
  tmp=$(mktemp) || return 1
  op document get dotfiles-secrets "${SECRETS_OP_ARGS[@]}" --out-file "$tmp" --force >/dev/null &&
    nano "$tmp" &&
    op document edit dotfiles-secrets "$tmp" --file-name secrets.sh "${SECRETS_OP_ARGS[@]}" >/dev/null &&
    source "$tmp" &&
    echo "dotfiles-secrets updated"
  rm -f "$tmp"
}
