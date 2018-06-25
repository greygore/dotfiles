#!/usr/bin/env bash
[ -z "$DOTFILES_USER" ] && ( echo "ERROR: DOTFILES_USER needs to be set"; exit 1 )

DOTFILES_DEFAULT_DIRECTORY="$HOME/.dotfiles"
DOTFILES_ROOT=${DOTFILES_ROOT:-$DOTFILES_DEFAULT_DIRECTORY}
DOTFILES_TARBALL_PATH="https://github.com/$DOTFILES_USER/dotfiles/tarball/master"

# Set the terminal background color on macOS
if [ "$(uname -s)" == "Darwin" ]; then
	osascript -e 'tell application "Terminal"' -e 'tell selected tab of front window' -e 'set normal text color to {65535,65535,65535}' -e 'set background color to {0,0,0}' -e 'end tell' -e 'end tell'
fi

# Read dotrc config file to check for DOTFILES_ROOT
if [ -f "$HOME/.dotrc" ]; then
	source "$HOME/.dotrc"
else
	printf "$(tput bold; tput setaf 7)       No .dotrc found in home directory.$(tput sgr0)\n"
fi

# If missing, download and extract the dotfiles repository
if [[ ! -d $DOTFILES_ROOT ]]; then
	printf "$(tput bold; tput setaf 7)       Downloading dotfiles...$(tput sgr0)\n"
	mkdir -p $DOTFILES_ROOT

	# Download and extract project tarball
	curl -fsSLo $HOME/dotfiles.tar.gz $DOTFILES_TARBALL_PATH
	tar -zxf $HOME/dotfiles.tar.gz --strip-components 1 -C $DOTFILES_ROOT
	rm -rf $HOME/dotfiles.tar.gz
fi

source $DOTFILES_ROOT/script/install.sh