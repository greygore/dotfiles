#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] &&  { echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1; }

# Install the Solarized Dark theme for iTerm
open "$DOTFILES_ROOT/init/Solarized Dark.itermcolors"

# Don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false
