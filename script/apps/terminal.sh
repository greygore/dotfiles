#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] && ( echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1 )

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Use a modified version of the Solarized Dark theme by default in Terminal.app
TERM_PROFILE='Solarized Dark xterm-256color';
CURRENT_PROFILE="$(defaults read com.apple.terminal 'Default Window Settings')";
if [ "$CURRENT_PROFILE" != "$TERM_PROFILE" ]; then
	(crontab -l 2> /dev/null | grep -v "terminal_cron.sh"; echo "@reboot $DOTFILES_ROOT/script/apps/terminal_cron.sh") | crontab -
	sleep 5
	(crontab -l 2> /dev/null | grep -v "terminal_cron.sh"; echo "@reboot $DOTFILES_ROOT/script/apps/terminal_cron.sh") | crontab -
	open "$DOTFILES_ROOT/init/$TERM_PROFILE.terminal";
fi;

# Mouse focus for Terminal.app and all X11 apps
# i.e. hover over a window and start typing in it with[out] clicking first
defaults write com.apple.terminal FocusFollowsMouse -bool false
defaults write org.x.X11 wm_ffm -bool false
