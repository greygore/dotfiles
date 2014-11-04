#!/usr/bin/env bash
SOURCE="${BASH_SOURCE[0]}"
# Resolve $SOURCE until the file is no longer a symlink
while [ -h "$SOURCE" ]; do 
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  # If $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DOTFILES_ROOT="$( cd -P "$( dirname "$SOURCE" )"../.. && pwd )"

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Use a modified version of the Solarized Dark theme by default in Terminal.app
TERM_PROFILE='Solarized Dark xterm-256color';
CURRENT_PROFILE="$(defaults read com.apple.terminal 'Default Window Settings')";
if [ "$CURRENT_PROFILE" != "$TERM_PROFILE" ]; then
	open "$DOTFILES_ROOT/init/$TERM_PROFILE.terminal";
	sleep 1; # Wait a bit to make sure the theme is loaded
	defaults write com.apple.terminal 'Default Window Settings' -string "$TERM_PROFILE";
	defaults write com.apple.terminal 'Startup Window Settings' -string "$TERM_PROFILE";
fi;

# Mouse focus for Terminal.app and all X11 apps
# i.e. hover over a window and start typing in it with[out] clicking first
defaults write com.apple.terminal FocusFollowsMouse -bool false
defaults write org.x.X11 wm_ffm -bool false
