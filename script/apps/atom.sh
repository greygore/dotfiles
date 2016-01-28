#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] && ( echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1 )
source "$DOTFILES_ROOT/script/lib.sh"

# Use Atom as default git editor
git config --global core.editor "atom --wait"

# Basic functionality
apm install Sublime-Style-Column-Selection
apm install minimap
apm install highlight-selected
apm install minimap-highlight-selected
apm install clipboard-plus
apm install editorconfig

# Go
apm install go-plus
if is_osx; then
    if [ -z "$GOPATH" ]; then
        warning 'Unable to locate $GOPATH for atom-go-plus'
    elif [ command -v setenv-osx > /dev/null ]; then
        setenv-osx GOPATH
    else
        info 'Remember to set the GOPATH environmental variable with launchd'
        info 'If you install the setenv-osx function you can: setenv-osx GOPATH'
    fi
fi
apm install gorename

# Git
apm install git-time-machine

# Misc
apm install linter
apm install todo-show
apm install foldingtext-for-atom

# HTML/CSS/JS
apm install less-than-slash
apm install pigments
apm install linter-htmlhint
apm install linter-csshint
apm install linter-jshint

# Fun
apm install activate-power-mode
#apm install asteroids
