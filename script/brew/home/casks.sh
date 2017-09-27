#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] &&  { echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1; }
source "$DOTFILES_ROOT/script/lib.sh"
source "$DOTFILES_ROOT/script/brew/lib.sh"

# Services
brew_cask 'crashplan'

# Apps
brew_cask 'libreoffice'
brew_cask 'ynab'
brew_cask 'gimp'
