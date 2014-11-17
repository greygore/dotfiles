#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] &&  { echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1; }
source "$DOTFILES_ROOT/script/lib.sh"
source "$DOTFILES_ROOT/script/brew/lib.sh"

# QuickLook plugins
brew_quicklook 'qlcolorcode' # Code syntax
brew_quicklook 'qlstephen' # Extensionless text files
brew_quicklook 'qlmarkdown'
brew_quicklook 'quicklook-json'
brew_quicklook 'qlprettypatch' # Diff
brew_quicklook 'quicklook-csv'
brew_quicklook 'betterzipql' # Archives
brew_quicklook 'webp-quicklook'
brew_quicklook 'suspicious-package' # OSX Installer Packages
