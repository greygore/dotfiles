#!/usr/bin/env bash

if [ -z "$DOTFILES_USER" ]; then
	echo "ERROR: You need to set DOTFILES_USER"
	exit 1
fi

DOTFILES_DEFAULT_DIRECTORY="$HOME/.dotfiles"
DOTFILES_DIRECTORY=${DOTFILES_DIRECTORY-$DOTFILES_DEFAULT_DIRECTORY}
DOTFILES_TARBALL_PATH="https://github.com/$DOTFILES_USER/dotfiles/tarball/master"

# If missing, download and extract the dotfiles repository
if [[ ! -d $DOTFILES_DIRECTORY ]]; then
	printf "$(tput bold; tput setaf 7)       Downloading dotfiles...$(tput sgr0)\n"
	mkdir $DOTFILES_DIRECTORY

	# Download and extract project tarball
	curl -fsSLo $HOME/dotfiles.tar.gz $DOTFILES_TARBALL_PATH
	tar -zxf $HOME/dotfiles.tar.gz --strip-components 1 -C $DOTFILES_DIRECTORY
	rm -rf $HOME/dotfiles.tar.gz
fi

source $DOTFILES_DIRECTORY/script/install.sh