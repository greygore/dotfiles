#/usr/bin/env bash
function brew_formula() {
	local formula=$1
	local args=$2

	info "Installing $formula formula..."
	brew install $formula $args >> "$DOTFILES_ROOT/brew.log" 2>&1 \
	&& success "Installed $formula formula." \
	|| error "Unable to install $formula formula"
}

function brew_cask() {
	local cask=$1

	info "Installing $cask cask..."
	brew cask install --appdir="/Applications" $cask >> "$DOTFILES_ROOT/brew.log" 2>&1 \
	&& success "Installed $cask cask." \
	|| error "Unable to install $cask cask"
}

function brew_quicklook() {
	local quicklook=$1

	info "Installing $quicklook QuickLook plugin..."
	sudo brew cask install --qlplugindir="/Library/QuickLook" $quicklook >> "$DOTFILES_ROOT/brew.log" 2>&1 \
	&& success "Installed $quicklook QuickLook plugin." \
	|| fail "Unable to install $quicklook QuickLook plugin"
}
