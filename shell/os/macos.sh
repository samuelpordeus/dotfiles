# macOS-only shell config. Sourced by zshrc when on Darwin.

# Network
alias lip="ipconfig getifaddr en0"

# Clipboard
alias key="cat ~/.ssh/id_rsa.pub | pbcopy; echo 'SSH key copied to clipboard!'"

# System
alias update="sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup"
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
alias alert='osascript -e "display notification \"Stuff is done.\" with title \"Back to work!\""; tput bel'

# Apps
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"
alias google-chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias love="/Applications/love.app/Contents/MacOS/love"

# Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
