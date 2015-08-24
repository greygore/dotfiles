#/usr/bin/env bash

# Register a funciton that can be trapped
function cleanup_sudo() {
	sudo -k
}

# Initialize sudo
function init_sudo() {
	# Make sure aliases get expanded
	shopt -s expand_aliases

	# Create alias to validate before performing sudo
	alias sudo='validate_sudo || init_sudo; sudo '
	alias asudo='atomic_sudo '

	# Check for previously used sudo_password
	if [ -n "$sudo_password_previous" ]; then
		sudo_password=$sudo_password_previous
	fi

	# Read password from prompt
	until validate_sudo; do
		echo -n Password: 
		read -s sudo_password
		echo
	done
}

# Clear password and invalidate sudo
function destroy_sudo() {
	sudo -k
	sudo_password_previous="$sudo_password"
	unset sudo_password
	alias sudo='sudo '
}

# Create function to validate sudo access
function validate_sudo() {
	echo "$sudo_password" | command sudo -S -v &> /dev/null
}

# Perform sudo operation atomically
function atomic_sudo() {
	init_sudo
	sudo "$@"
	destroy_sudo
}
