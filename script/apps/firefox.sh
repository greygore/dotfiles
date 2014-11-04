#!/usr/bin/env bash
SOURCE="${BASH_SOURCE[0]}"
# Resolve $SOURCE until the file is no longer a symlink
while [ -h "$SOURCE" ]; do 
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  # If $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DOTFILES_ROOT="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

source "$DOTFILES_ROOT/script/lib.sh"

# Set default browser
open -a Firefox --args -setDefaultBrowser

# Install addons
wget https://lastpass.com/download/cdn/lp_mac.xpi # Last Pass
wget https://update.adblockplus.org/latest/adblockplusfirefox.xpi # AdBlock Plug
wget http://download.xmarks.com/download/binary/firefox # XMarks
wget https://addons.mozilla.org/firefox/downloads/latest/7661/addon-7661-latest.xpi # Pocket
wget http://download.livereload.com/2.0.8/LiveReload-2.0.8.xpi # LiveReload
wget https://addons.mozilla.org/firefox/downloads/file/276230/ember_inspector-1.5.0-fx.xpi # Ember Inspector

# TODO - Load addons without opening Firefox
open -a Firefox.app *.xpi

pause "Press any key to remove Firefox addon installation files..."
rm *.xpi