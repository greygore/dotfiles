#!/usr/bin/env bash

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd)

source "$DOTFILES_ROOT/script/lib.sh"

# Install command line tools
xcode-select -p > /dev/null 2>&1
if [ $? -eq 2 ]; then
	info 'Installing command line tools...'
	xcode-select --install  > /dev/null 2>&1
	while true
	do
		sleep 1
		xcode-select -p > /dev/null 2>&1
		if [ $? -ne 2 ]; then
			break
		fi
	done
	sleep 15
	success 'Command line tools installed'
fi

# Clean up git repo
if [ -e .git ]; then
	if [ -n "$(git status --porcelain)" ]; then
		user 'You have uncommited changes. Are you sure you want to continue?'
		read -n 1 confirm
		echo ''
		if [[ $confirm =~ ^[^Yy]?$ ]]; then
			exit
		fi
	elif [ -n "$(git log origin/master..HEAD)" ]; then
		user 'You have local unpushed commits. Are you sure you want to continue?'
		read -n 1 confirm
		echo ''
		if [[ $confirm =~ ^[^Yy]?$ ]]; then
			exit
		fi
	fi
fi

# Set up git config
user 'Would you like to configure git?'
read -n 1 confirm
echo ''
if [[ $confirm =~ ^[Yy]?$ ]]; then
	user ' - (Git) What is your full name?'
	read -e git_authorname
	user ' - (Git) What is your email?'
	read -e git_authoremail
	git_credential='cache'
	if [ "$(uname -s)" == "Darwin" ]; then
		git_credential='osxkeychain'
	fi
	cp -f "$DOTFILES_ROOT/config/.gitconfig_master" "$HOME/.gitconfig"
	git config --global user.name "$git_authorname"
	git config --global user.email "$git_authoremail"
	git config --global credential.helper $git_credential
	git config --global core.excludesfile ~/.gitignore_global
	success 'created .gitconfig'
fi

exit

# Link up dotfiles
user 'Would you like to symlink your dotfiles?'
read -n 1 confirm
if [[ $confirm =~ ^[^Yy]?$ ]]; then
	overwriteAll=false backupAll=false skipAll=false
	for src in $(find config -maxdepth 1 -not -type d | grep -v _master$)
	do
		dst="$HOME/$(basename "${src}")"
		link_file "$DOTFILES_ROOT/$src" "$dst"
	done
fi

# Start new bash environment
source ~/.bash_profile

success 'Done!'