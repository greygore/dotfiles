#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] && ( echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1 )
source "$DOTFILES_ROOT/script/lib.sh"

# Set default browser
info 'Setting Firefox to the default browser. Close Firefox to continue'
open -W -a Firefox --args -setDefaultBrowser

# Install addons
info 'Downloading Firefox extensions'
wget -O 1password.xpi http://cdn.agilebits.com/dist/1P/ext/1Password-4.2.5.xpi > /dev/null 2>&1 # 1Password
wget -O ublock-origin.xpi https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/addon-607454-latest.xpi?src=dp-btn-primary > /dev/null 2>&1 # uBlock Origin
wget -O ember-inspector.xpi https://addons.mozilla.org/firefox/downloads/file/276230/ember_inspector-1.5.0-fx.xpi > /dev/null 2>&1 # Ember Inspector
wget -O json-view.xpi https://addons.mozilla.org/firefox/downloads/latest/10869/addon-10869-latest.xpi > /dev/null 2>&1 # JSON View

# TODO - Load addons without opening Firefox
info 'Loading Firefox extensions. Close Firefox to continue'
open -W -a Firefox.app *.xpi > /dev/null 2>&1

# Remove extension files
rm *.xpi \
&& success 'Removed Firefox addon installation files.' \
|| error 'Unable to remove Firefox addon installation files'
