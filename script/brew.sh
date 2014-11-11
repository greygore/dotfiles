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

# Ask for sudo up front and keep alive for entire script
sudo -v && while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install Homebrew
if test ! $(which brew); then
	info "Installing homebrew..."
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null >> "$DOTFILES_ROOT/brew.log" 2>&1 \
	&& success 'Homebrew installed.' \
	|| fail 'Unable to install Homebrew'
fi

info 'Upgrading homebrew and existing formulas'
brew update >> "$DOTFILES_ROOT/brew.log" 2>&1 \
&& brew upgrade >> "$DOTFILES_ROOT/brew.log" 2>&1 \
&& success 'Homebrew and formulas upgraded.' \
|| fail 'Unable to upgrade homebrew and formulas'

binaries=(
	# Updated versions of old OS X versions
	coreutils
	findutils --default-names # find, locate, updatedb, xargs
	gnu-sed --default-names # sed
	git --with-gettext --with-pcre

	# Bash 4
	bash
	bash-completion

	# Cooler tools
	tree # ls
	trash # rm
	rename # mv
	tag

	# Helper tools
	wget --with-iri
	ack # grep
	nmap # network mapper
	cheat # cheatsheets
	terminal-notifier # cli notifications
	watchman # file watcher
	known_hosts # known_hosts manager
	jq # json processor

	# Conversion utilities
	ffmpeg --with-tools --with-x265 # movies/audio
	imagemagick --with-libtiff --with-webp # images
	html2text
	webkit2png

	# Graphical CLI stuff
	grc
	pv
	hr
	figlet
	spark

	# Other
	todo-txt # http://todotxt.com/
	go --cross-compile-common # golang
	node # node.js and npm
)
info 'Installing brew formulas, this will take a while...'
brew install ${binaries[@]} >> "$DOTFILES_ROOT/brew.log" 2>&1 \
&& success 'Installed brewed formulas.' \
|| fail 'Unable to install brewed formulas'

# Add and set bash shell
echo '/usr/local/bin/bash' | sudo tee -a /etc/shells > /dev/null
sudo chsh -s /usr/local/bin/bash "$USER" > /dev/null 2>&1 \
&& success 'Updated bash to brew version.' \
|| error 'Unable to update bash to brewed version'

info 'Installing homebrew cask...'
brew install caskroom/cask/brew-cask \
&& success 'Installed homebrew cask' \
|| fail 'Unable to install homebrew cask'

apps=(
	# Basic tools
	onepassword
	alfred
	iterm2
	caskroom/homebrew-versions/sublime-text3

	# Utilities
	caffeine
	the-unarchiver
	flux
	key-codes
	daisydisk

	# Menu
	battery-time-remaining
	istat-menus

	# Browsers
	firefox
	google-chrome

	# Services
	crashplan
	dropbox
	evernote
	github

	# Dev tools
	virtualbox
	vagrant
	sourcetree
	pgadmin3
	dash # API Docs
	imageoptim
	cyberduck # Remote files

	# Communication
	skype
	komanda # IRC

	# Apps	
	libreoffice
	ynab
	gimp

	# Entertainment
	spotify
	steam
	supersync
)
info 'Installing brew casks, this will also take a while...'
brew cask install --appdir="/Applications" ${apps[@]} >> "$DOTFILES_ROOT/brew.log" 2>&1 \
&& success 'Installed brewed casks.' \
&& error 'Unable to install brew casks'

quicklooks=(
	qlcolorcode # Code syntax
	qlstephen # Extensionless text files
	qlmarkdown
	quicklook-json
	qlprettypatch # Diff
	quicklook-csv
	betterzipql # Archives
	webp-quicklook
	suspicious-package # OSX Installer Packages
)
info 'Installing QuickLook plugins...'
sudo brew cask install --qlplugindir="/Library/QuickLook" ${quicklooks[0]}  >> "$DOTFILES_ROOT/brew.log" 2>&1 \
&& success 'Installed QuickLook plugins.' \
|| fail 'Unable to install QuickLook plugins'

# Add casks to Alfred's path
brew cask alfred \
&& success 'Added caskroom to Alfred scope.' \
|| error 'Unable to add caskroom to Alfred scope'

# Clean up brew working files
brew cleanup && brew cask cleanup \
&& success 'Cleaned up brew and cask.' \
|| error 'Unable to clean up brew and cask'

# Mac App Store links
# App IDs pulled from https://linkmaker.itunes.apple.com/us/
pause 'Opening Mac App Store for Trillian. Press any key to continue.'
open macappstore://itunes.apple.com/app/id412056820?mt=12
pause 'Opening Mac App Store for Wunderlist. Press any key to continue.'
open macappstore://itunes.apple.com/app/id410628904?mt=12
pause 'Opening Mac App Store for Leaf. Press any key to continue.'
open macappstore://itunes.apple.com/app/id576338668?mt=12
pause 'Opening Mac App Store for Pocket. Press any key to continue.'
open macappstore://itunes.apple.com/app/id568494494?mt=12
pause 'Opening Mac App Store for Characters. Press any key to continue.'
open macappstore://itunes.apple.com/app/id536511979?mt=12
pause 'Opening Mac App Store for Kindle. Press any key to continue.'
open macappstore://itunes.apple.com/app/id405399194?mt=12
pause 'Opening Mac App Store for Lifespan Active +. Press any key to continue.'
open macappstore://itunes.apple.com/app/id804738629?mt=12
