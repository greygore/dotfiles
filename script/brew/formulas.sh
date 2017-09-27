#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] &&  { echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1; }
source "$DOTFILES_ROOT/script/lib.sh"
source "$DOTFILES_ROOT/script/brew/lib.sh"

# Java is sometimes a dependency, regretably
brew_cask 'java'

# Cooler versions of existing commands
brew_formula 'm-cli' # OSX specific helpers
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
brew_formula 'noti' # cli notifications
brew_formula 'watchman' # file watcher
brew_formula 'known_hosts' # known_hosts manager
brew_formula 'jq' # json processor
brew_formula 'path-extractor' # Path picker from stdin
brew_formula 'envchain' # Store ENV variables in keychain
brew_formula 'speedtest-cli' # Perform a speed test
brew_formula 'ssh-copy-id' # Copy SSH key to remote system
brew_formula 'httpie' # Better than CURL
brew_formula 'dshb' # OS X system monitor in Swift
brew_formula 'jump' # Fuzzy directory jumper
brew_formula 'peco' # Interactive filtering

# Conversion tools
brew_formula 'ffmpeg' '--with-tools --with-x265' # movies/audio
brew_formula 'imagemagick' '--with-libtiff --with-webp' # images
brew_formula 'html2text'
brew_formula 'webkit2png'

# Font tools (https://github.com/bramstein/homebrew-webfonttools)
brew tap bramstein/webfonttools >> "$DOTFILES_ROOT/brew.log" 2>&1
brew_formula 'woff2' # For WOFF2
brew_formula 'sfnt2woff-zopfli' # For WOFF static files
brew_formula 'sfnt2woff' # For dynamically generating WOFF
#brew_formula 'sfntly' # Use sfnttool to generate compressed EOT

# Graphical command line utilities
brew_formula 'grc'
brew_formula 'pv'
brew_formula 'hr'
brew_formula 'figlet'
brew_formula 'spark'
brew_formula 'prettyping'
brew_formula 'archey' # Show system info

# Docker
brew_formula 'docker'
brew_formula 'docker-compose'

# Shell completion
brew_formula 'homebrew/completions/apm-bash-completion'
brew_formula 'homebrew/completions/boot2docker-completion'
brew_formula 'homebrew/completions/brew-cask-completion'
brew_formula 'homebrew/completions/open-completion'
brew_formula 'homebrew/completions/vagrant-completion'

# Miscellaneous
brew_formula 'todo-txt' # http://todotxt.com/
brew_formula 'go' '--cross-compile-common' # golang
brew_formula 'node' # node.js and npm
brew_formula 'dark-mode' # Toggle OSX dark mode
brew_formula 'brightness' # Set brightness from CLI
brew_formula 'ansiweather'

# Fun
brew_formula 'cmatrix' # Matrix green character rain
brew_formula 'nyancat'
brew_formula 'rig' # Random Identity Generator
