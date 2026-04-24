# VS Code as default editor.
export EDITOR="code -w"
export VISUAL="$EDITOR"

# General exports
export HISTFILE="$HOME/.zsh_history"
export HISTCONTROL="ignoreboth:erasedups" # Erase duplicates in history
export HISTSIZE=1000000 # Max 1kk history entries
export SAVEHIST=1000000 # Save 1kk history entries
export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"
export ERL_AFLAGS="-kernel shell_history enabled"
export AWS_DEFAULT_REGION=us-east-1
export ZSH=$HOME/.oh-my-zsh
export WORKER=true
export CONSOLE_LOG_LEVEL="error"

# PATH
export GOPATH=~/go
export PATH="$HOME/.bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="./bin:$PATH"
export PATH=$PATH:$GOPATH/bin
export PATH="$PATH:$HOME/.asdf/installs/elixir/1.10.2-otp-22/.mix/escripts"
# Homebrew: prefer Apple Silicon, fall back to Linuxbrew, then Intel macOS
for brew_prefix in /opt/homebrew /home/linuxbrew/.linuxbrew /usr/local; do
  if [ -x "$brew_prefix/bin/brew" ]; then
    export PATH="$brew_prefix/bin:$brew_prefix/sbin:$PATH"
    break
  fi
done
unset brew_prefix
export PATH="$PATH:$HOME/.local/bin"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

if [ $ITERM_SESSION_ID ]; then
  export PROMPT_COMMAND='echo -ne "\033];${PWD##*/}\007"; ':"$PROMPT_COMMAND";
fi
