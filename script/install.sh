#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] &&  { echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1; }
source "$DOTFILES_ROOT/script/lib.sh"

# Ask for sudo up front and keep alive for entire script
sudo -v; while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install command line tools
if is_osx; then
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
	password ' (SSH) Enter a passphrase:'
	ssh_passphrase=$answer
	ssh-keygen -q -t rsa -C "$ssh_email" -f ~/.ssh/id_rsa -N "$ssh_passphrase" > /dev/null \
	|| fail 'Unable to generate a new key'
	eval "$(ssh-agent -s)" > /dev/null || fail 'Unable to start ssh agent'
	ssh-add -A ~/.ssh/id_rsa > /dev/null 2>&1 || fail 'Unable to add new key to ssh'
	ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts 2> /dev/null
	if is_osx; then
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
	if is_osx; then
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
overwriteAll=false
backupAll=false
skipAll=false
if confirm 'Would you like to symlink your dotfiles?'; then
	# Link main files
	for src in $(find config -maxdepth 1 -not -type d | grep -v _master$)
	do
		dst="$HOME/$(basename "${src}")"
		link_file "$DOTFILES_ROOT/$src" "$dst"
	done

	# Link files in directories (only 1 deep)
	for dir in $(find config -maxdepth 1 -type d | grep config/)
	do
		mkdir -p "$HOME/$(basename "$dir")"
		for src in $(find $dir -maxdepth 1 -not -type d | grep -v _master$)
		do
			dst="$HOME/$(basename "$dir")/$(basename "${src}")"
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

info 'Installing user binaries and scripts...'
mkdir -p ~/bin
for src in $(find bin -maxdepth 1 -not -type d)
do
	dst="$HOME/bin/$(basename "${src}")"
	link_file "$DOTFILES_ROOT/$src" "$dst"
done

# OSX Settings
if is_osx && confirm 'Would you like to customize your OS X environment?'; then
	source "$DOTFILES_ROOT/script/osx.sh" && success 'OS X environment customized.'
	source "$DOTFILES_ROOT/script/apps/mail.sh" && success 'Mail.app configured.'
	source "$DOTFILES_ROOT/script/apps/safari.sh" && success 'Safari configured.'
fi

# Homebrew installation and configuration
if is_osx && confirm 'Would you like to install and configure Homebrew formula/casks?'; then
	source "$DOTFILES_ROOT/script/brew.sh" && success 'Homebrew formulas and casks installed.'
	source "$DOTFILES_ROOT/script/apps/iterm2.sh" && success 'iTerm2 configured and themed.'
	source "$DOTFILES_ROOT/script/apps/sublime.sh" && success 'Sublime Text 3 configured and themed.'
	source "$DOTFILES_ROOT/script/apps/firefox.sh" && success 'Firefox configured and addons installed.'
	source "$DOTFILES_ROOT/script/apps/chrome.sh" && success 'Chrome configured.'
fi

# Node/NPM packages
if test $(which npm) && confirm 'Would you like to install NPM packages?'; then
	source "$DOTFILES_ROOT/script/npm.sh" && success 'NPM packages installed.'
fi

success 'Done! Some changes may require restarting your computer to take effect.'
pause 'Press any key to close the terminal window so that the profile can be initialized on restart.'
killall Terminal > /dev/null 2>&1
