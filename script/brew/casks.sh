#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] &&  { echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1; }
source "$DOTFILES_ROOT/script/lib.sh"
source "$DOTFILES_ROOT/script/brew/lib.sh"

# Alfred
if [ -d "/Applications/Alfred 3.app" ]; then
	alfred_installed="Installed"
fi
init_sudo
brew_cask 'alfred'
destroy_sudo
# If not previously installed, open to allow linking later
if [ -z "$alfred_installed" ]; then
	sleep 5
	open -a "Alfred 3"
fi

# Fonts
brew_cask 'caskroom/fonts/font-source-code-pro'

# Basic tools
brew_cask '1password'
brew_cask 'iterm2'
brew_cask 'atom'

# Utilities
brew_cask 'keepingyouawake'
brew_cask 'the-unarchiver'
brew_cask 'flux'
brew_cask 'key-codes'
brew_cask 'daisydisk'

# Window Management
brew_cask 'moom' # Move and resize windows

# Browser
brew_cask 'firefox'
brew_cask 'google-chrome'

# Services
brew_cask 'dropbox'
brew_cask 'evernote'
brew_cask 'github-desktop'

# Dev tools
init_sudo
brew_cask 'virtualbox'
destroy_sudo
brew_cask 'vagrant'
brew_cask 'sourcetree'
brew_cask 'pgadmin4'
brew_cask 'sequel-pro' # MySQL GUI
brew_cask 'dash' # API Docs
brew_cask 'imageoptim'
brew_cask 'cyberduck' # Remote files
brew_cask 'kitematic' # Docker

# Communication
brew_cask 'skype'
brew_cask 'komanda' # IRC

# Apps
brew_cask 'spotify'
brew_cask 'vlc'

# QuickLook plugins
brew_cask 'qlcolorcode' # Code syntax
brew_cask 'qlstephen' # Extensionless text files
brew_cask 'qlmarkdown'
brew_cask 'quicklook-json'
brew_cask 'qlprettypatch' # Diff
brew_cask 'quicklook-csv'
brew_cask 'betterzipql' # Archives
brew_cask 'webpquicklook'
brew_cask 'suspicious-package' # OSX Installer Packages

# Context specific casks
if [ -z "$DOTFILES_INSTALL_CONTEXT" && -d "$DOTFILES_ROOT/script/brew/$DOTFILES_INSTALL_CONTEXT/" ]; then
  source "$DOTFILES_ROOT/script/brew/$DOTFILES_INSTALL_CONTEXT/casks.sh"
fi
