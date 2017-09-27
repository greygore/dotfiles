#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] &&  { echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1; }
source "$DOTFILES_ROOT/script/lib.sh"
source "$DOTFILES_ROOT/script/brew/lib.sh"

# Window Management
brew_cask 'displaylink' # USB video drivers

# Dev tools
brew_cask 'phpstorm'

# Apps
brew_cask 'hipchat'
