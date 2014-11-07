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

# Install Homebrew
if test ! $(which brew); then
	info "Installing homebrew..."
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" \
	&& success 'Homebrew installed.'
fi

# Upgrade Homebrew
brew update >> "$DOTFILES_ROOT/brew.log" 2>&1

# Upgrade installed formulas
brew upgrade >> "$DOTFILES_ROOT/brew.log" 2>&1

brew install wget --with-iri

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
	go --cross-compile-common # golang
	node # node.js and npm
)
brew install ${binaries[@]} >> "$DOTFILES_ROOT/brew.log" 2>&1

# Add and set bash shell
echo '/usr/local/bin/bash' | sudo tee -a /etc/shells > /dev/null
sudo chsh -s /usr/local/bin/bash "$USER" > /dev/null 2>&1

brew install caskroom/cask/brew-cask

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
brew cask install --appdir="/Applications" ${apps[@]} >> "$DOTFILES_ROOT/brew.log" 2>&1

quicklooks=(
	qlcolorcode
	qlstephen
	qlmarkdown
	quicklook-json
	qlprettypatch
	quicklook-csv
	betterzipql
	webp-quicklook
	suspicious-package
)
sudo brew cask install --qlplugindir="/Library/QuickLook" ${quicklooks[0]}  >> "$DOTFILES_ROOT/brew.log" 2>&1

brew cask alfred
brew cleanup --force
brew cask cleanup
rm -f -r /Library/Caches/Homebrew/*

unavailable=(
	characters
	pocket
	trillian
	wunderlist
)
echo "The following apps were not available in brew or cask form and need to be downloaded via the Mac App Store:"
echo "${unavailable[@]}"
