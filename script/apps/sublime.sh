#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] && ( echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1 )

# Install package control
/usr/local/bin/subl -b && killall "Sublime Text" # Create support directories
cd "$HOME/Library/Application Support/Sublime Text 3/Installed Packages/"
curl -o "Package Control.sublime-package" https://sublime.wbond.net/Package%20Control.sublime-package > /dev/null 2>&1
cd - > /dev/null 2>&1

# Link Sublime Text settings
PREFS="$HOME/Library/Application Support/Sublime Text 3/Packages/User"
if [[ -d "$PREFS" && ! -L "$PREFS" ]]; then
	rm -rf "$PREFS";
	ln -s "$DOTFILES_ROOT/settings/sublime/" "$PREFS";
fi

# Use Sublime Text as default git editor
git config --global core.editor "subl -n -w"
