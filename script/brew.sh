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

function brew_formula() {
	local formula=$1
	local args=$2

	info "Installing $formula formula..."
	brew install $formula $args >> "$DOTFILES_ROOT/brew.log" 2>&1 \
	&& success "Installed $formula formula." \
	|| error "Unable to install $formula formula"
}

function brew_cask() {
	local cask=$1

	info "Installing $cask cask..."
	brew cask install --appdir="/Applications" $cask >> "$DOTFILES_ROOT/brew.log" 2>&1 \
	&& success "Installed $cask cask." \
	|| error "Unable to install $cask cask"
}

function brew_quicklook() {
	local quicklook=$1

	info "Installing $quicklook QuickLook plugin..."
	sudo brew cask install --qlplugindir="/Library/QuickLook" $quicklook >> "$DOTFILES_ROOT/brew.log" 2>&1 \
	&& success "Installed $quicklook QuickLook plugin." \
	|| fail "Unable to install $quicklook QuickLook plugin"
}

# Ask for sudo up front and keep alive for entire script
sudo -v; while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install Homebrew
if test ! $(which brew); then
	info "Installing homebrew..."
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install | sed 's/^.*sudo.*\-k/#&/g')" < /dev/null >> "$DOTFILES_ROOT/brew.log" 2>&1 \
	&& success 'Homebrew installed.' \
	|| fail 'Unable to install Homebrew'
fi

info 'Upgrading homebrew and existing formulas'
brew update >> "$DOTFILES_ROOT/brew.log" 2>&1 \
&& brew upgrade >> "$DOTFILES_ROOT/brew.log" 2>&1 \
&& success 'Homebrew and formulas upgraded.' \
|| fail 'Unable to upgrade homebrew and formulas'

# Patch homebrew to stop sudo timestamp invalidation
if grep '^[^#].*sudo.*\-k' "$(brew --prefix)/Library/Homebrew/build.rb"; then
	sed -i '.backup' 's/^.*sudo.*\-k/#&/g' "$(brew --prefix)/Library/Homebrew/build.rb"
fi

info 'Installing homebrew cask...'
brew install caskroom/cask/brew-cask >> "$DOTFILES_ROOT/brew.log" 2>&1 \
&& success 'Installed homebrew cask' \
|| fail 'Unable to install homebrew cask'

# Modern bash & completion
brew_formula 'bash'
echo '/usr/local/bin/bash' | sudo tee -a /etc/shells > /dev/null
sudo chsh -s /usr/local/bin/bash "$USER" > /dev/null 2>&1 \
&& success 'Updated shell to brew version of bash.' \
|| error 'Unable to update shell to brewed version of bash'
brew_formula 'bash-completion'

# Updated OSX binaries
brew_formula 'coreutils'
brew_formula 'findutils' '--default-names' # find, locate, updatedb, xargs
brew_formula 'gnu-sed' '--default-names' # sed
brew_formula 'git' '--with-gettext --with-pcre'

# Cooler versions of existing commands
brew_formula 'tree' # ls
brew_formula 'trash' # rm
brew_formula 'rename' # mv
brew_formula 'tag'

# Cool new tools
brew_formula 'wget' '--with-iri'
brew_formula 'ack' # grep
brew_formula 'nmap' # network mapper
brew_formula 'cheat' # cheatsheets
brew_formula 'terminal-notifier' # cli notifications
brew_formula 'watchman' # file watcher
brew_formula 'known_hosts' # known_hosts manager
brew_formula 'jq' # json processor

# Conversion tools
brew_formula 'ffmpeg' '--with-tools --with-x265' # movies/audio
brew_formula 'imagemagick' '--with-libtiff --with-webp' # images
brew_formula 'html2text'
brew_formula 'webkit2png'

# Graphical command line utilities
brew_formula 'grc'
brew_formula 'pv'
brew_formula 'hr'
brew_formula 'figlet'
brew_formula 'spark'

# Miscellaneous
brew_formula 'todo-txt' # http://todotxt.com/
brew_formula 'go' '--cross-compile-common' # golang
brew_formula 'node' # node.js and npm

# Basic tools
brew_cask 'onepassword'
brew_cask 'alfred'
brew_cask 'iterm2'
brew_cask 'caskroom/homebrew-versions/sublime-text3'

# Utilities
brew_cask 'caffeine'
brew_cask 'the-unarchiver'
brew_cask 'flux'
brew_cask 'key-codes'
brew_cask 'daisydisk'

# Menu
brew_cask 'battery-time-remaining'
brew_cask 'istat-menus'

# Browser
brew_cask 'firefox'
brew_cask 'google-chrome'

# Services
brew_cask 'crashplan'
brew_cask 'dropbox'
brew_cask 'evernote'
brew_cask 'github'

# Dev tools
brew_cask 'virtualbox'
brew_cask 'vagrant'
brew_cask 'sourcetree'
brew_cask 'pgadmin3'
brew_cask 'dash' # API Docs
brew_cask 'imageoptim'
brew_cask 'cyberduck' # Remote files

# Communication
brew_cask 'skype'
brew_cask 'komanda' # IRC

# Apps
brew_cask 'libreoffice'
brew_cask 'ynab'
brew_cask 'gimp'

# Entertainment
brew_cask 'spotify'
brew_cask 'steam'
brew_cask 'supersync'

# QuickLook plugins
brew_quicklook 'qlcolorcode' # Code syntax
brew_quicklook 'qlstephen' # Extensionless text files
brew_quicklook 'qlmarkdown'
brew_quicklook 'quicklook-json'
brew_quicklook 'qlprettypatch' # Diff
brew_quicklook 'quicklook-csv'
brew_quicklook 'betterzipql' # Archives
brew_quicklook 'webp-quicklook'
brew_quicklook 'suspicious-package' # OSX Installer Packages

# Add casks to Alfred's path
brew cask alfred link >> "$DOTFILES_ROOT/brew.log" 2>&1 \
&& success 'Added caskroom to Alfred scope.' \
|| error 'Unable to add caskroom to Alfred scope'

# Clean up brew working files
brew cleanup >> "$DOTFILES_ROOT/brew.log" 2>&1 \
&& brew cask cleanup >> "$DOTFILES_ROOT/brew.log" 2>&1 \
&& success 'Cleaned up brew and cask.' \
|| error 'Unable to clean up brew and cask'

# Remove sudo timestamp invalidation patch
if [ -f "$(brew --prefix)/Library/Homebrew/build.rb.backup" ]; then
	mv "$(brew --prefix)/Library/Homebrew/build.rb.backup" "$(brew --prefix)/Library/Homebrew/build.rb"
fi

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
