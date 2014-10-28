#!/usr/bin/env bash

# Link Sublime Text settings
PREFS="$HOME/Library/Application Support/Sublime Text 3/Packages/User"
if [[ -d $PREFS && ! -L $PREFS ]]; then
	rm -rf "${PREFS}";
	ln -s ./settings/sublime/ $PREFS;
fi

# Link subl executable
ln -s "/Applications/Sublime Text 3.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl

# Use Sublime Text as default git editor
git config --global core.editor "subl -n -w"