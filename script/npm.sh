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

if ! which tldr > /dev/null; then
	npm install -g tldr  >> "$DOTFILES_ROOT/npm.log" 2>&1
fi
tldr --update > /dev/null 2>&1

if ! which ember > /dev/null; then
	npm install -g ember-cli >> "$DOTFILES_ROOT/npm.log" 2>&1
fi