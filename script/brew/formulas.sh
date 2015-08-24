#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] &&  { echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1; }
source "$DOTFILES_ROOT/script/lib.sh"
source "$DOTFILES_ROOT/script/brew/lib.sh"

# Cooler versions of existing commands
brew_formula 'tree' # ls
brew_formula 'trash' # rm
brew_formula 'rename' # mv
brew_formula 'tag'
brew_formula 'ccat' # cat

# Cool new tools
brew_formula 'wget' '--with-iri'
brew_formula 'ack' # grep
brew_formula 'nmap' # network mapper
brew_formula 'cheat' # cheatsheets
brew_formula 'terminal-notifier' # cli notifications
brew_formula 'watchman' # file watcher
brew_formula 'known_hosts' # known_hosts manager
brew_formula 'jq' # json processor
brew_formula 'fpp' # Facebook path picker
brew_formula 'envchain' # Store ENV variables in keychain

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
brew_formula 'gifify'
brew_formula 'prettyping'

# Docker
brew_formula 'docker'
brew_formula 'docker-compose'

# Miscellaneous
brew_formula 'todo-txt' # http://todotxt.com/
brew_formula 'go' '--cross-compile-common' # golang
brew_formula 'node' # node.js and npm
brew_formula 'dark-mode' # Toggle OSX dark mode

# iTerm 1Password integration
brew tap ravenac95/sudolikeaboss
brew_formula 'sudolikeaboss'
