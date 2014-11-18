#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] && ( echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1 )
source "$DOTFILES_ROOT/script/lib.sh"
source "$DOTFILES_ROOT/script/brew/lib.sh"

# Ask for sudo up front and keep alive for entire script
sudo -v; while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install Homebrew
if test ! $(which brew); then
	info "Installing homebrew..."
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install | sed 's/^.*sudo.*\-k/#&/g')" < /dev/null >> "$DOTFILES_ROOT/brew.log" 2>&1 \
	&& success 'Homebrew installed.' \
	|| fail 'Unable to install Homebrew'
fi

info 'Upgrading homebrew and existing formulas'
brew update >> "$DOTFILES_ROOT/brew.log" 2>&1 \
&& brew upgrade >> "$DOTFILES_ROOT/brew.log" 2>&1 \
&& success 'Homebrew and formulas upgraded.' \
|| fail 'Unable to upgrade homebrew and formulas'

# Patch homebrew to stop sudo timestamp invalidation
if grep '^[^#].*sudo.*\-k' "$(brew --prefix)/Library/Homebrew/build.rb" > /dev/null 2>&1; then
	sed -i '.backup' 's/^.*sudo.*\-k/#&/g' "$(brew --prefix)/Library/Homebrew/build.rb" > /dev/null 2>&1
fi

info 'Installing homebrew cask...'
brew install caskroom/cask/brew-cask >> "$DOTFILES_ROOT/brew.log" 2>&1 \
&& success 'Installed homebrew cask' \
|| fail 'Unable to install homebrew cask'

if confirm 'Install brewed version of bash?' $DOTFILES_DO_BREW_BASH 'Installing brewed bash...'; then
	source "$DOTFILES_ROOT/script/brew/bash.sh"
fi

if confirm 'Install updated versions of built in tools?' $DOTFILES_DO_BREW_TOOLS 'Installing updated tools...'; then
	source "$DOTFILES_ROOT/script/brew/updated.sh"
fi

if confirm 'Install other brew formulas?' $DOTFILES_DO_BREW_OTHER; then
	source "$DOTFILES_ROOT/script/brew/formulas.sh"
fi

if confirm 'Install brew casks?' $DOTFILES_DO_BREW_CASK; then
	source "$DOTFILES_ROOT/script/brew/casks.sh"
fi

if confirm 'Install quicklook plugins?' $DOTFILES_DO_BREW_QUICKLOOK; then
	source "$DOTFILES_ROOT/script/brew/quicklook.sh"
fi

# Add casks to Alfred's path
brew cask alfred link >> "$DOTFILES_ROOT/brew.log" 2>&1 \
&& success 'Added caskroom to Alfred scope.' \
|| error 'Unable to add caskroom to Alfred scope'

# Clean up brew working files
brew cleanup >> "$DOTFILES_ROOT/brew.log" 2>&1 \
&& brew cask cleanup >> "$DOTFILES_ROOT/brew.log" 2>&1 \
&& success 'Cleaned up brew and cask.' \
|| error 'Unable to clean up brew and cask'

# Remove sudo timestamp invalidation patch
if [ -f "$(brew --prefix)/Library/Homebrew/build.rb.backup" ]; then
	mv "$(brew --prefix)/Library/Homebrew/build.rb.backup" "$(brew --prefix)/Library/Homebrew/build.rb"
fi
