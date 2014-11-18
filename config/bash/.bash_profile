#!/usr/bin/env bash

# Load dotfiles run command
[ -r '.dotrc' ] && source '.dotrc'

# Check that DOTFILES_ROOT is set and a valid directory
if [ ! -z "$DOTFILES_ROOT" ]; then
	if [ ! -d $DOTFILES_ROOT ]; then
		echo "No dotfiles directory found at $DOTFILES_ROOT"
		exit 1
	fi
else
	if [ -d "$HOME/.dotfiles" ]; then
		export DOTFILES_ROOT="$HOME/.dotfiles"
	else
		echo 'ERROR: Can not find dotfiles directory'
		exit 1
	fi
fi

# Load bash dotfiles modules
files=( options exports aliases functions prompt path completions )
for file in ${files[@]}; do
	[ -r "$DOTFILES_ROOT/bash/$file" ] && source "$DOTFILES_ROOT/bash/$file"
done
unset files

# Add color to shell commands
if which brew > /dev/null && [ -f "$(brew --prefix)/etc/grc.bashrc" ]; then
	source "$(brew --prefix)/etc/grc.bashrc"
fi