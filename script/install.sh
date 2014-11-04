#!/usr/bin/env bash

SOURCE="${BASH_SOURCE[0]}"
# Resolve $SOURCE until the file is no longer a symlink
while [ -h "$SOURCE" ]; do 
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  # If $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DOTFILES_ROOT="$( cd -P "$( dirname "$SOURCE" )"/.. && pwd )"

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
	success 'Command line tools installed.'
fi

# Clean up git repo
if [ -e .git ]; then
	if [ -n "$(git status --porcelain)" ]; then
		if confirm 'You have uncommited changes. Are you sure you want to continue?'; then
			info 'Remember to commit your changes later then.'
		else
			exit 1
		fi
	elif [ -n "$(git log origin/master..HEAD)" ]; then
		if confirm 'You have local unpushed commits. Do you want to push them to master?'; then
			git push master origin
			success "Local changes pushed to remote."
		fi
	fi
# If there is no repo, create one and sync it from origin
else
	info 'Creating new git repository and syncing with remote...'
	if [ -z "$DOTFILES_USER" ]; then
		DOTFILES_GIT_REMOTE="git@github.com:$DOTFILES_USER/dotfiles.git"
	else
		question 'What is the github user for this dotfiles repository?'
		DOTFILES_GIT_REMOTE="git@github.com:$answer/dotfiles.git"
	fi
	git init
	git remote add origin ${DOTFILES_GIT_REMOTE}
	git fetch origin master
	git reset --hard FETCH_HEAD
	git clean -fd
	success 'Git repository created and synced with remote.'
fi

# Set up git config
if confim 'Would you like to configure git?'; then
	question ' (Git) What is your full name?'
	git_authorname=$answer
	question ' (Git) What is your email?'
	git_authoremail=$answer
	if [ "$(uname -s)" == "Darwin" ]; then
		git_credential='osxkeychain'
	else
		git_credential='cache'
	fi
	cp -f "$DOTFILES_ROOT/config/.gitconfig_master" "$HOME/.gitconfig"
	git config --global user.name "$git_authorname"
	git config --global user.email "$git_authoremail"
	git config --global credential.helper $git_credential
	git config --global core.excludesfile ~/.gitignore_global
	success 'created .gitconfig'
fi

# Link up dotfiles
if confirm 'Would you like to symlink your dotfiles?'; then
	overwriteAll=false
	backupAll=false
	skipAll=false
	for src in $(find config -maxdepth 1 -not -type d | grep -v _master$)
	do
		dst="$HOME/$(basename "${src}")"
		link_file "$DOTFILES_ROOT/$src" "$dst"
	done

	# Start new bash environment
	source ~/.bash_profile
fi

success 'Done!'