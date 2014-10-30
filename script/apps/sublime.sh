#!/usr/bin/env bash

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd)

# Link Sublime Text settings
PREFS="$HOME/Library/Application Support/Sublime Text 3/Packages/User"
if [[ -d "$PREFS" && ! -L "$PREFS" ]]; then
	rm -rf "$PREFS";
	ln -s "$DOTFILES_ROOT/settings/sublime/" "$PREFS";
fi

# Link subl executable
if [[ ! -L /usr/local/bin/subl ]]; then
	ln -s "/Applications/Sublime Text 3.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
fi

# Use Sublime Text as default git editor
git config --global core.editor "subl -n -w"