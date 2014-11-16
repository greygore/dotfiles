#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] &&  { echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1; }
source "$DOTFILES_ROOT/script/lib.sh"

# Set default browser
open -a Firefox --args -setDefaultBrowser
pause 'Setting Firefox to your default browser. Press any key to continue installing addons.'

# Install addons
wget http://cdn.agilebits.com/dist/1P/ext/1Password-4.2.5.xpi > /dev/null 2>&1 # 1Password
wget https://update.adblockplus.org/latest/adblockplusfirefox.xpi > /dev/null 2>&1 # AdBlock Plus
wget http://download.xmarks.com/download/binary/firefox > /dev/null 2>&1 # XMarks
wget https://addons.mozilla.org/firefox/downloads/latest/7661/addon-7661-latest.xpi > /dev/null 2>&1 # Pocket
wget http://download.livereload.com/2.0.8/LiveReload-2.0.8.xpi > /dev/null 2>&1 # LiveReload
wget https://addons.mozilla.org/firefox/downloads/file/276230/ember_inspector-1.5.0-fx.xpi > /dev/null 2>&1 # Ember Inspector

# TODO - Load addons without opening Firefox
open -a Firefox.app *.xpi > /dev/null 2>&1

pause "Press any key to remove Firefox addon installation files..."
rm *.xpi \
&& success 'Removed Firefox addon installation files.' \
|| error 'Unable to remove Firefox addon installation files'