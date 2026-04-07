#!/usr/bin/env zsh

# Set name of the theme to load @ ~/.oh-my-zsh/themes/ or ~/.oh-my-zsh/custom/themes/
ZSH_THEME="powerlevel10k/powerlevel10k"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: 'mm/dd/yyyy'|'dd.mm.yyyy'|'yyyy-mm-dd'
HIST_STAMPS='dd/mm/yyyy'

# Loading our .dotfiles (aliases, functions, exports, extras)
# ~/.extra can be used for settings you don't want to commit.
for file in ~/dotfiles/shell/*; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;
