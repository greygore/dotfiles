#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] &&  { echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1; }
source "$DOTFILES_ROOT/script/lib.sh"
source "$DOTFILES_ROOT/script/brew/lib.sh"

# Updated OSX binaries
brew_formula 'coreutils'
brew_formula 'findutils' '--default-names' # find, locate, updatedb, xargs
brew_formula 'gnu-sed' '--default-names' # sed
brew_formula 'git' '--with-gettext --with-pcre'

