#!/usr/bin/env bash

# Because Terminal.app will apparently overwrite the Default and Startup
# Window Settings when it closes, we need to run this as a cron script
TERM_PROFILE='Solarized Dark xterm-256color';
defaults write com.apple.terminal 'Default Window Settings' -string "$TERM_PROFILE";
defaults write com.apple.terminal 'Startup Window Settings' -string "$TERM_PROFILE";
(crontab -l | grep -v "terminal_cron.sh") | crontab
