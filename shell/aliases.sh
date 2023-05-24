# Config
# ======
alias reload=". ~/.zshrc && echo 'ZSH reloaded!'"
alias dotfiles="code ~/.dotfiles"

# Shell
# =====
alias src="source ~/.zshrc"
alias ..="cd .."
alias ...="cd ../.."
alias grep="grep --color=auto"
alias ls="exa"
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias lip="ipconfig getifaddr en0"
alias key="cat ~/.ssh/id_rsa.pub | pbcopy; echo 'SSH key copied to clipboard!'"
alias hex="openssl rand -hex"
alias cat="bat"
alias g="git"
alias fd="find . -type d -name"
alias ff="find . -type f -name"
alias ping="prettyping --nolegend"
alias tree="exa -T -I '.git|node_modules|bower_components|.DS_Store' --group-directories-first"
alias update="sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; brew upgrade; brew cask upgrade"
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
alias alert='osascript -e "display notification \"Stuff is done.\" with title \"Back to work!\""; tput bel'
alias awslogin='saml2aws login --session-duration=14400 --force'

# Show/hide hidden files in Finder
# ================================
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"