#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] && ( echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1 )
source "$DOTFILES_ROOT/script/lib.sh"

if ! which tldr > /dev/null; then
	npm install -g tldr  >> "$DOTFILES_ROOT/npm.log" 2>&1
fi
tldr --update > /dev/null 2>&1

if ! which ember > /dev/null; then
	npm install -g ember-cli >> "$DOTFILES_ROOT/npm.log" 2>&1
fi

if ! which json > /dev/null; then
	npm install -g json >> "$DOTFILES_ROOT/npm.log" 2>&1
fi

if ! which gifify > /dev/null; then
	npm install -g gifify >> "$DOTFILES_ROOT/npm.log" 2>&1
fi

if ! which cowsay > /dev/null; then
	npm install -g cowsay >> "$DOTFILES_ROOT/npm.log" 2>&1
fi

if ! which empty-trash > /dev/null; then
	npm install -g empty-trash >> "$DOTFILES_ROOT/npm.log" 2>&1
fi

if ! which is-online > /dev/null; then
	npm install -g is-online >> "$DOTFILES_ROOT/npm.log" 2>&1
fi

if ! which webpagetest > /dev/null; then
	npm install -g webpagetest >> "$DOTFILES_ROOT/npm.log" 2>&1
fi

if ! which psi > /dev/null; then
	npm install -g psi >> "$DOTFILES_ROOT/npm.log" 2>&1
fi

