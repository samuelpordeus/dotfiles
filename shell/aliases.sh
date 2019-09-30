# Config
# ======
alias reload=". ~/.zshrc && echo 'ZSH reloaded!'"
alias dotfiles="code ~/.dotfiles"

# Shell
# =====
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

# Show/hide hidden files in Finder
# ================================
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Bundler
# =======
alias b="bundle"
alias bi="b install --jobs=2"
alias bu="b update"
alias be="b exec"
alias bo="b open"

# Ruby on Rails
# =====
alias rc="bin/rails c"
alias rs="bin/rails s"
alias s="bin/spring"
alias sr="bin/rspec"
alias st="bin/teaspoon"
alias rdm="bin/rake db:migrate"
alias rdr="bin/rake db:rollback"
alias rof="bin/rspec --only-failures"
alias rcp="DISABLE_SPRING=true dotenv -f .env.production.local bin/rails c"
alias killrb="ps aux | pgrep -lf 'rack|spring|rails|ruby|puma|sneakers|unicorn' | awk '{print $1}' | xargs kill -9"
alias bigclass="find . -name '*.rb' -not -path '*test*' -not -path '*spec*' | xargs wc -l | sort -rn | head"
alias longparams="ack 'def\s.+\((.*,.*,.*,.*)\)' --ignore-dir='spec' --ignore-dir='test'"
