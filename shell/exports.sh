# Sublime as default editor.
export BUNDLER_EDITOR="code"
export GEM_EDITOR="code"
export EDITOR="code -w"
export VISUAL="$EDITOR"

export HISTFILE="$HOME/.zsh_history"
export HISTCONTROL="ignoreboth:erasedups" # Erase duplicates in history
export HISTSIZE=10000 # Store 10k history entries

export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"

export GOPATH=~/go

# PATH
export PATH="$HOME/.bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="./bin:$PATH"
export PATH=$PATH:$GOPATH/bin

if [ $ITERM_SESSION_ID ]; then
  export PROMPT_COMMAND='echo -ne "\033];${PWD##*/}\007"; ':"$PROMPT_COMMAND";
fi
