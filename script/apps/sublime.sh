#!/usr/bin/env bash
SOURCE="${BASH_SOURCE[0]}"
# Resolve $SOURCE until the file is no longer a symlink
while [ -h "$SOURCE" ]; do 
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  # If $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DOTFILES_ROOT="$( cd -P "$( dirname "$SOURCE" )"/../.. && pwd )"

# Install package control
open -a "Sublime Text" && killall "Sublime Text" # Create support directories
cd "$HOME/Library/Application Support/Sublime Text 3/Installed Packages/"
curl -O https://sublime.wbond.net/Package%20Control.sublime-package > /dev/null 2>&1
cd -

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