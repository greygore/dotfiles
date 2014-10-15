#!/usr/bin/env bash
wget https://lastpass.com/download/cdn/lp_mac.xpi # Last Pass
wget https://update.adblockplus.org/latest/adblockplusfirefox.xpi # AdBlock Plug
wget http://download.xmarks.com/download/binary/firefox # XMarks
wget https://addons.mozilla.org/firefox/downloads/latest/7661/addon-7661-latest.xpi # Pocket
wget http://download.livereload.com/2.0.8/LiveReload-2.0.8.xpi # LiveReload
wget https://addons.mozilla.org/firefox/downloads/file/276230/ember_inspector-1.5.0-fx.xpi # Ember Inspector

# TODO - Load addons without opening Firefox
open -a Firefox.app *.xpi

echo "Press any key to remove Firefox addon installation files..."
read -n 1 -s
rm *.xpi