#/usr/bin/env bash
function brew_formula() {
	local formula=$1
	local args=$2
	local context=$3

	if [ -z "$context" ] || [ "$context" = "$DOTFILES_INSTALL_CONTEXT" ]; then
		info "Installing $formula formula..."
		brew install $formula $args >> "$DOTFILES_ROOT/brew.log" 2>&1 \
		&& success "Installed $formula formula." \
		|| error "Unable to install $formula formula"
	fi
}

function brew_cask() {
	local cask=$1
	local context=$2

	if [ -z "$context" ] || [ "$context" = "$DOTFILES_INSTALL_CONTEXT" ]; then
		info "Installing $cask cask..."
		brew cask install $cask >> "$DOTFILES_ROOT/brew.log" 2>&1 \
		&& success "Installed $cask cask." \
		|| error "Unable to install $cask cask"
	fi
}
