#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] &&  { echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1; }
source "$DOTFILES_ROOT/script/lib.sh"
source "$DOTFILES_ROOT/script/brew/lib.sh"

# Alfred
if [ -d "/Applications/Alfred 2.app" ]; then
	alfred_installed="Installed"
fi
brew_cask 'alfred'
# If not previously installed, open to allow linking later
if [ -z "$alfred_installed" ]; then
	open -a "Alfred 2"
fi

# Fonts
brew_cask 'caskroom/fonts/font-source-code-pro'

# Basic tools
brew_cask '1password'
brew_cask 'iterm2'
brew_cask 'caskroom/homebrew-versions/sublime-text3'

# Utilities
brew_cask 'caffeine'
brew_cask 'the-unarchiver'
brew_cask 'flux'
brew_cask 'key-codes'
brew_cask 'daisydisk'

# Menu
brew_cask 'battery-time-remaining'

# Browser
brew_cask 'firefox'
brew_cask 'google-chrome'

# Services
brew_cask 'crashplan'
brew_cask 'dropbox'
brew_cask 'evernote'
brew_cask 'github'

# Dev tools
brew_cask 'virtualbox'
brew_cask 'vagrant'
brew_cask 'sourcetree'
brew_cask 'pgadmin3'
brew_cask 'dash' # API Docs
brew_cask 'imageoptim'
brew_cask 'cyberduck' # Remote files
brew_cask 'kitematic' # Docker

# Communication
brew_cask 'skype'
brew_cask 'komanda' # IRC

# Apps
brew_cask 'libreoffice'
brew_cask 'ynab'
brew_cask 'gimp'
brew_cask 'vlc'
