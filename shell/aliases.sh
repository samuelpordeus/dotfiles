# Cross-platform aliases. OS-specific ones live in shell/os/{macos,linux}.sh.

# Config
alias reload=". ~/.zshrc && echo 'ZSH reloaded!'"
alias dotfiles="code ~/dotfiles"

# Shell
alias src="source ~/.zshrc"
alias ..="cd .."
alias ...="cd ../.."
alias grep="grep --color=auto"
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias hex="openssl rand -hex"
alias g="git"
alias fd="find . -type d -name"
alias ff="find . -type f -name"
alias ping="prettyping --nolegend"

# exa/eza — prefer eza (actively maintained), fall back to exa. Otherwise plain ls.
if command -v eza >/dev/null 2>&1; then
  alias ls="eza"
  alias tree="eza -T -I '.git|node_modules|bower_components|.DS_Store' --group-directories-first"
elif command -v exa >/dev/null 2>&1; then
  alias ls="exa"
  alias tree="exa -T -I '.git|node_modules|bower_components|.DS_Store' --group-directories-first"
fi

# Git helpers
alias git-setup='function _git_setup() { git stash && git switch main && git pull && git switch -c "sp/$1"; }; _git_setup'

# AWS
alias awslogin='saml2aws login --session-duration=14400 --force'
