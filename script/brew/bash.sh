#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] &&  { echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1; }
source "$DOTFILES_ROOT/script/lib.sh"
source "$DOTFILES_ROOT/script/brew/lib.sh"

# Initialize sudo password save
init_sudo; destroy_sudo

# Modern bash
brew_formula 'bash'
echo '/usr/local/bin/bash' | sudo tee -a /etc/shells > /dev/null
asudo chsh -s /usr/local/bin/bash "$USER" > /dev/null 2>&1 \
&& success 'Updated shell to brew version of bash.' \
|| error 'Unable to update shell to brewed version of bash'

# Bash completion
brew tap homebrew/versions
brew_formula 'bash-completion2'
