#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] && ( echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1 )
source "$DOTFILES_ROOT/script/lib.sh"

# Initialize sudo password save
init_sudo

if [ -f "$HOME/.dotrc" ]; then
	source "$HOME/.dotrc"
elif confirm 'Do full install?' $DOTFILES_DO_FULL_INSTALL; then
	DOTFILES_DO_GIT_CONFIG='y'
	DOTFILES_DO_GIT_SYNC='y'
	DOTFILES_DO_SYMLINK='y'
	DOTFILES_DO_HOSTS='y'
	DOTFILES_DO_OSX='y'
	DOTFILES_DO_APP_STORE='y'
	DOTFILES_DO_BREW='y'
	DOTFILES_DO_BREW_BASH='y'
	DOTFILES_DO_BREW_TOOLS='y'
	DOTFILES_DO_BREW_OTHER='y'
	DOTFILES_DO_BREW_CASK='y'
	DOTFILES_DO_BREW_QUICKLOOK='y'
	DOTFILES_DO_NPM='y'
fi

# Set work/home variables to flag brew formulas
if confirm 'Is this a work install?'; then
	DOTFILES_INSTALL_CONTEXT='work'
else
	DOTFILES_INSTALL_CONTEXT='home'
fi

# Create basic config file if it doesn't already exist
if [ ! -f "$HOME/.dotrc" ]; then
	echo "DOTFILES_ROOT=$DOTFILES_ROOT" > "$HOME/.dotrc"
fi

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
if [ ! -f "$HOME/.ssh/id_rsa.pub" ]; then
	info 'Generating new ssh key...'
	question ' (SSH) What is your email?' "$DOTFILES_SSH_EMAIL" " (SSH) Using supplied email: $DOTFILES_SSH_EMAIL"
	ssh_email=$answer
	password ' (SSH) Enter a passphrase:' "$DOTFILES_SSH_PASSPHRASE" " (SSH) Using supplied passphrase"
	ssh_passphrase=$answer
	ssh-keygen -q -t rsa -C "$ssh_email" -f "$HOME/.ssh/id_rsa" -N "$ssh_passphrase" > /dev/null \
	|| fail 'Unable to generate a new key'
	eval "$(ssh-agent -s)" > /dev/null || fail 'Unable to start ssh agent'
	ssh-add -A "$HOME/.ssh/id_rsa" > /dev/null 2>&1 || fail 'Unable to add new key to ssh'
	ssh-keyscan -t rsa github.com >> "$HOME/.ssh/known_hosts" 2> /dev/null
	if is_osx; then
		pbcopy < "$HOME/.ssh/id_rsa.pub"
		info 'Your public key has been copied to your clipboard.'
	else
		info "Your public key is: $(cat $HOME/.ssh/id_rsa.pub)"
	fi
	open https://www.github.com/settings/ssh
	pause 'Enter your public key to your Github account, then press any key to continue.'
elif confirm 'Would you like to enter your public key on Github?'; then
	if is_osx; then
		pbcopy < "$HOME/.ssh/id_rsa.pub"
		info 'Your public key has been copied to your clipboard.'
	else
		info "Your public key is: $(cat $HOME/.ssh/id_rsa.pub)"
	fi
	open https://www.github.com/settings/ssh
	pause 'Enter your public key to your Github account, then press any key to continue.'
fi

# Set up git config
if confirm 'Would you like to configure git?' $DOTFILES_DO_GIT_CONFIG 'Configuring git...'; then
	cp -f "$DOTFILES_ROOT/config/git/.gitconfig.master" "$HOME/.gitconfig" \
	|| fail "Unable to copy master .gitconfig file to home directory"

	question ' (Git) What is your full name?' "$DOTFILES_GIT_NAME" " (Git) Using supplied name: $DOTFILES_GIT_NAME"
	git_authorname=$answer
	question ' (Git) What is your email?' "$DOTFILES_GIT_EMAIL" " (Git) Using supplied email: $DOTFILES_GIT_EMAIL"
	git_authoremail=$answer
	if is_osx; then
		git_credential='osxkeychain'
	else
		git_credential='cache'
	fi
	git config --global user.name "$git_authorname"
	git config --global user.email "$git_authoremail"
	git config --global credential.helper $git_credential
	git config --global core.excludesfile "$HOME/.gitignore.global"
	success 'Created .gitconfig.'
fi

# Clean up git repo
if [ -e "$DOTFILES_ROOT/.git" ]; then
	cd "$DOTFILES_ROOT"
	if [ -n "$(git status --porcelain)" ]; then
		if confirm 'You have uncommited changes. Are you sure you want to continue?' $DOTFILES_IGNORE_UNCOMMITED; then
			warning 'Remember to commit your changes later then.'
		else
			exit 1
		fi
	elif [ -n "$(git log origin/master..HEAD)" ]; then
		if confirm 'You have local unpushed commits. Do you want to push them to master?' $DOTFILES_PUSH_COMMITS; then
			git push origin master
			success "Local changes pushed to remote."
		fi
	fi
# If there is no repo, create one and sync it from origin
elif confirm 'Would you like to create a git repository and sync it with the remote?' $DOTFILES_DO_GIT_SYNC; then
	info 'Creating new git repository and syncing with remote...'
	if [ -z "$DOTFILES_USER" ]; then
		question 'What is the github user for this dotfiles repository?'
		DOTFILES_GIT_REMOTE="git@github.com:$answer/dotfiles.git"
	else
		DOTFILES_GIT_REMOTE="git@github.com:$DOTFILES_USER/dotfiles.git"
	fi
	cd $DOTFILES_ROOT
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
if confirm 'Would you like to symlink your dotfiles?' $DOTFILES_DO_SYMLINK; then
	# Grab all config files that start with "." and don't end in .master
	for src in $(find config -iregex '^config/[a-z0-9]*/\.[a-z0-9._-]*' -maxdepth 3 | grep -v .master$); do
		[ -d $src ] && src="$src/"
		dst="$HOME/$(basename "${src}")"
		link_file "$DOTFILES_ROOT/$src" "$dst"
	done

	# Start new bash environment
	source "$HOME/.bash_profile"

	# Make sure our sudo alias isn't overwritten
	init_sudo
fi

info 'Installing user binaries and scripts...'
link_file "$DOTFILES_ROOT/bin" "$HOME/bin"

if confirm 'Would you like to install a third party hosts file?' $DOTFILES_DO_HOSTS; then
	curl -fsLo "$HOME/hosts" http://someonewhocares.org/hosts/ipv6/hosts
	sudo mv "$HOME/hosts" /etc/hosts
fi

# OSX Settings
if is_osx && confirm 'Would you like to customize your OS X environment?' $DOTFILES_DO_OSX; then
	source "$DOTFILES_ROOT/script/osx.sh" && success 'OS X environment customized.'
	source "$DOTFILES_ROOT/script/apps/terminal.sh" && success 'Terminal configured and themed.'
	source "$DOTFILES_ROOT/script/apps/mail.sh" && success 'Mail.app configured.'
	source "$DOTFILES_ROOT/script/apps/safari.sh" && success 'Safari configured.'
fi

# Mac App Store
if is_osx && confirm 'Would you like to install apps from the Mac App Store?' $DOTFILES_DO_APP_STORE; then
	source "$DOTFILES_ROOT/script/app_store.sh"
fi

# Homebrew installation and configuration
if is_osx && confirm 'Would you like to install and configure Homebrew formula/casks?' $DOTFILES_DO_BREW; then
	source "$DOTFILES_ROOT/script/brew.sh" && success 'Homebrew formulas and casks installed.'
	source "$DOTFILES_ROOT/script/apps/iterm2.sh" && success 'iTerm2 configured and themed.'
	source "$DOTFILES_ROOT/script/apps/sublime.sh" && success 'Sublime Text 3 configured and themed.'
	source "$DOTFILES_ROOT/script/apps/firefox.sh" && success 'Firefox configured and addons installed.'
	source "$DOTFILES_ROOT/script/apps/chrome.sh" && success 'Chrome configured.'
fi

# Node/NPM packages
if test $(which npm) && confirm 'Would you like to install NPM packages?' "$DOTFILES_DO_NPM" 'Installing NPM packages...'; then
	source "$DOTFILES_ROOT/script/npm.sh" && success 'NPM packages installed.'
fi

success 'Done! Some changes may require restarting your computer to take effect.'
pause 'Press any key to close the terminal window so that the profile can be initialized on restart.'
killall Terminal > /dev/null 2>&1
