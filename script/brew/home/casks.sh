#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] &&  { echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1; }
source "$DOTFILES_ROOT/script/lib.sh"
source "$DOTFILES_ROOT/script/brew/lib.sh"

# Services
brew_cask 'backblaze'

# Utilities
brew_cask 'flux'

# Services
brew_cask 'dropbox'
brew_cask 'evernote'

# Communication
brew_cask 'skype'
brew_cask 'komanda' # IRC

# Apps
brew_cask 'libreoffice'
brew_cask 'ynab'
brew_cask 'gimp'
brew_cask 'vlc'
