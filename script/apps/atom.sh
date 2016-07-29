#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] && ( echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1 )
source "$DOTFILES_ROOT/script/lib.sh"

# Use Atom as default git editor
git config --global core.editor "atom --wait"

# Basic functionality
apm install solarized-light-ui >> "$DOTFILES_ROOT/apm.log" 2>&1
apm install solarized-dark-ui >> "$DOTFILES_ROOT/apm.log" 2>&1
apm install Sublime-Style-Column-Selection >> "$DOTFILES_ROOT/apm.log" 2>&1
apm install minimap >> "$DOTFILES_ROOT/apm.log" 2>&1
apm install highlight-selected >> "$DOTFILES_ROOT/apm.log" 2>&1
apm install minimap-highlight-selected >> "$DOTFILES_ROOT/apm.log" 2>&1
apm install clipboard-plus >> "$DOTFILES_ROOT/apm.log" 2>&1
apm install editorconfig >> "$DOTFILES_ROOT/apm.log" 2>&1

# Go
apm install go-plus >> "$DOTFILES_ROOT/apm.log" 2>&1
if is_osx; then
    if [ -z "$GOPATH" ]; then
        export GOPATH="$(brew --prefix)/lib/go"
        setenv-osx GOPATH
    elif command -v setenv-osx > /dev/null; then
        setenv-osx GOPATH
    else
        info 'Remember to set the GOPATH environmental variable with launchd'
        info 'If you install the setenv-osx function you can: setenv-osx GOPATH'
    fi
fi
apm install gorename >> "$DOTFILES_ROOT/apm.log" 2>&1

# Git
apm install git-time-machine >> "$DOTFILES_ROOT/apm.log" 2>&1

# Misc
apm install linter >> "$DOTFILES_ROOT/apm.log" 2>&1
apm install todo-show >> "$DOTFILES_ROOT/apm.log" 2>&1
apm install foldingtext-for-atom >> "$DOTFILES_ROOT/apm.log" 2>&1

# HTML/CSS/JS
apm install less-than-slash >> "$DOTFILES_ROOT/apm.log" 2>&1
apm install pigments >> "$DOTFILES_ROOT/apm.log" 2>&1
apm install linter-htmlhint >> "$DOTFILES_ROOT/apm.log" 2>&1
apm install linter-csslint >> "$DOTFILES_ROOT/apm.log" 2>&1
apm install linter-jshint >> "$DOTFILES_ROOT/apm.log" 2>&1

# Fun
apm install activate-power-mode >> "$DOTFILES_ROOT/apm.log" 2>&1
#apm install asteroids >> "$DOTFILES_ROOT/apm.log" 2>&1
