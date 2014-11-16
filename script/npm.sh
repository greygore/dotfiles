#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] &&  { echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1; }
source "$DOTFILES_ROOT/script/lib.sh"

if ! which tldr > /dev/null; then
	npm install -g tldr  >> "$DOTFILES_ROOT/npm.log" 2>&1
fi
tldr --update > /dev/null 2>&1

if ! which ember > /dev/null; then
	npm install -g ember-cli >> "$DOTFILES_ROOT/npm.log" 2>&1
fi