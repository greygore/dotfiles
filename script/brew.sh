#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] && ( echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1 )
source "$DOTFILES_ROOT/script/lib.sh"
source "$DOTFILES_ROOT/script/brew/lib.sh"

# Initialize sudo password save
init_sudo; destroy_sudo

# Install Homebrew
if test ! $(which brew); then
	info "Installing homebrew..."
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" >> "$DOTFILES_ROOT/brew.log" 2>&1 \
	&& success 'Homebrew installed.' \
	|| fail 'Unable to install Homebrew'
fi

info 'Upgrading homebrew and existing formulas'
brew update >> "$DOTFILES_ROOT/brew.log" 2>&1 \
&& brew upgrade --all >> "$DOTFILES_ROOT/brew.log" 2>&1 \
&& success 'Homebrew and formulas upgraded.' \
|| fail 'Unable to upgrade homebrew and formulas'

info 'Installing homebrew cask...'
brew install caskroom/cask/brew-cask >> "$DOTFILES_ROOT/brew.log" 2>&1 \
&& success 'Installed homebrew cask' \
|| fail 'Unable to install homebrew cask'

if confirm 'Install brewed version of bash?' "$DOTFILES_DO_BREW_BASH" 'Installing brewed bash...'; then
	source "$DOTFILES_ROOT/script/brew/bash.sh"
fi

if confirm 'Install updated versions of built in tools?' "$DOTFILES_DO_BREW_TOOLS" 'Installing updated tools...'; then
	source "$DOTFILES_ROOT/script/brew/updated.sh"
fi

if confirm 'Install other brew formulas?' "$DOTFILES_DO_BREW_OTHER"; then
	source "$DOTFILES_ROOT/script/brew/formulas.sh"
fi

if confirm 'Install brew casks?' "$DOTFILES_DO_BREW_CASK"; then
	source "$DOTFILES_ROOT/script/brew/casks.sh"
fi

if confirm 'Install quicklook plugins?' "$DOTFILES_DO_BREW_QUICKLOOK"; then
	init_sudo
	source "$DOTFILES_ROOT/script/brew/quicklook.sh"
	destroy_sudo
fi

# Clean up brew working files
brew cleanup >> "$DOTFILES_ROOT/brew.log" 2>&1 \
&& brew cask cleanup >> "$DOTFILES_ROOT/brew.log" 2>&1 \
&& success 'Cleaned up brew and cask.' \
|| error 'Unable to clean up brew and cask'
