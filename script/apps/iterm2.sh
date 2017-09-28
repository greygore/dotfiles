#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] && ( echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1 )
source "$DOTFILES_ROOT/script/lib.sh"

# Install the Solarized Dark theme for iTerm
info 'Opening iTerm to install the Solarized Dark theme. Close iTerm to continue.'
open -W "$DOTFILES_ROOT/init/Solarized Dark.itermcolors"

# Don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false
