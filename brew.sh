#!/usr/bin/env bash

# Install command line tools
if test ! $(which gcc); then
	echo "Installing command line tools..."
	xcode-select --install
fi

# Install Homebrew
if test ! $(which brew); then
	echo "Installing homebrew..."
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Upgrade recipes
brew update

binaries=(
	git
	bash
	coreutils
	findutils
	go
	cheat
	trash
	rename
	tree
	node
	wget
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
