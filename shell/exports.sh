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

# PATH
export GOPATH=~/go
export PATH="$HOME/.bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="./bin:$PATH"
export PATH=$PATH:$GOPATH/bin
export PATH="$PATH:/Users/samuelpordeus/.asdf/installs/elixir/1.10.2-otp-22/.mix/escripts"
export PATH="$BUN_INSTALL/bin:$PATH"

if [ $ITERM_SESSION_ID ]; then
  export PROMPT_COMMAND='echo -ne "\033];${PWD##*/}\007"; ':"$PROMPT_COMMAND";
fi
