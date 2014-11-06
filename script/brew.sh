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
	bash # Bash 4
	coreutils
	findutils #find, locate, updatedb, xargs
	git

	go
	cheat
	trash
	rename
	tree
	node
	tag
	terminal-notifier
	spark
	figlet
	watchman
	ffmpeg
	hr
	html2text
	jq
	known_hosts
	bash-completion
	grc
)
brew install ${binaries[@]}

brew install caskroom/cask/brew-cask

apps=(
	alfred
	dropbox
	iterm2
	evernote
	wunderlist
	github
	sublime-text
	virtualbox
	sourcetree
	firefox
	google-chrome
	skype
	key-codes
	libreoffice
	spotify
	the-unarchiver
	cyberduck
	istat-menus
	komanda
	daisydisk
	caffeine
	kindle
	crashplan
	flux
	supersync
	ynab
	istat-menus
	gimp
	pgadmin3
	imageoptim
	steam
	vagrant
	battery-time-remaining
	dash # API Docs
)
brew cask install --appdir="/Applications" ${apps[@]} 2> /dev/null

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
sudo brew cask install --qlplugindir="/Library/QuickLook" ${quicklooks[0]} 2> /dev/null

brew cask alfred
brew cleanup --force
brew cask cleanup
rm -f -r /Library/Caches/Homebrew/*

unavailable=(
	characters
	pocket
	trillian
)
echo "The following apps were not available in brew or cask form and need to be downloaded via the Mac App Store:"
echo "${unavailable[@]}"
