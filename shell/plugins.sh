# Oh My ZSH plugins
plugins=(dotenv fzf git-auto-fetch)

# User configuration
source $ZSH/oh-my-zsh.sh

# fzf key-bindings + completion (common apt / brew install paths)
for f in \
  /usr/share/doc/fzf/examples/key-bindings.zsh \
  /usr/share/fzf/key-bindings.zsh \
  /opt/homebrew/opt/fzf/shell/key-bindings.zsh \
  /usr/local/opt/fzf/shell/key-bindings.zsh \
  /usr/share/doc/fzf/examples/completion.zsh \
  /usr/share/fzf/completion.zsh \
  /opt/homebrew/opt/fzf/shell/completion.zsh \
  /usr/local/opt/fzf/shell/completion.zsh; do
  [ -r "$f" ] && source "$f"
done
unset f
