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
cd $DOTFILES_ROOT

source "$DOTFILES_ROOT/script/lib.sh"

# Install command line tools
if [ "$(uname -s)" == "Darwin" ]; then
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
fi

# Set up public key
if [ ! -f ~/.ssh/id_rsa.pub ]; then
	info 'Generating new ssh key...'
	question ' (SSH) What is your email?'
	ssh_email=$answer
	question ' (SSH) Enter a passphrase:' 'password'
	ssh_passphrase=$answer
	ssh-keygen -q -t rsa -C "$ssh_email" -f ~/.ssh/id_rsa -N "$ssh_passphrase" > /dev/null \
	|| fail 'Unable to generate a new key'
	eval "$(ssh-agent -s)" > /dev/null || fail 'Unable to start ssh agent'
	ssh-add -A ~/.ssh/id_rsa > /dev/null 2>&1 || fail 'Unable to add new key to ssh'
	ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts 2> /dev/null
	if [ "$(uname -s)" == "Darwin" ]; then
		pbcopy < ~/.ssh/id_rsa.pub
		info 'Your public key has been copied to your clipboard.'
	else
		info "Your public key is: $(cat ~/.ssh/id_rsa.pub)"
	fi
	open https://www.github.com/settings/ssh
	pause 'Enter your public key to your Github account, then press any key to continue.'
fi

# Set up git config
if confirm 'Would you like to configure git?'; then
	cp -f "$DOTFILES_ROOT/config/.gitconfig_master" "$HOME/.gitconfig" \
	|| fail "Unable to copy master .gitconfig file to home directory"

	question ' (Git) What is your full name?'
	git_authorname=$answer
	question ' (Git) What is your email?'
	git_authoremail=$answer
	if [ "$(uname -s)" == "Darwin" ]; then
		git_credential='osxkeychain'
	else
		git_credential='cache'
	fi
	git config --global user.name "$git_authorname"
	git config --global user.email "$git_authoremail"
	git config --global credential.helper $git_credential
	git config --global core.excludesfile ~/.gitignore_global
	success 'Created .gitconfig.'
fi

# Clean up git repo
if [ -e "$DOTFILES_ROOT/.git" ]; then
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
elif confirm 'Would you like to create a git repository and sync it with the remote?'; then
	info 'Creating new git repository and syncing with remote...'
	if [ -z "$DOTFILES_USER" ]; then
		question 'What is the github user for this dotfiles repository?'
		DOTFILES_GIT_REMOTE="git@github.com:$answer/dotfiles.git"
	else
		DOTFILES_GIT_REMOTE="git@github.com:$DOTFILES_USER/dotfiles.git"
	fi
	git init > /dev/null \
	&& git remote add origin ${DOTFILES_GIT_REMOTE} > /dev/null 2>&1 \
	&& git fetch origin master > /dev/null 2>&1 \
	&& git reset --hard FETCH_HEAD > /dev/null \
	&& git clean -fd > /dev/null \
	&& success 'Git repository created and synced with remote.' \
	|| fail 'ERROR: Unable to create new git repository and sync with remote'
fi

# Link up dotfiles
if confirm 'Would you like to symlink your dotfiles?'; then
	overwriteAll=false
	backupAll=false
	skipAll=false

	# Link main files
	for src in $(find config -maxdepth 1 -not -type d | grep -v _master$)
	do
		dst="$HOME/$(basename "${src}")"
		link_file "$DOTFILES_ROOT/$src" "$dst"
	done

	# Link files in directories (only 1 deep)
	for dir in $(find config -maxdepth 1 -type d | grep config/.)
	do
		mkdir "$HOME/$(basename "$dir")"
		for src in $(find $dir -maxdepth 1 -not -type d | grep -v _master$)
		do
			dst="$HOME/$dir/$(basename "${src}")"
			link_file "$DOTFILES_ROOT/$src" "$dst"
		done
	done

	# Start new bash environment
	source ~/.bash_profile

	# Configure Terminal
	if [ -e "/Applications/Utilities/Terminal.app" ] && confirm 'Would you like to configure Terminal settings and set the theme?'; then
		source "$DOTFILES_ROOT/script/apps/terminal.sh" && success 'Terminal configured and themed.'
	fi
fi

success 'Done!'