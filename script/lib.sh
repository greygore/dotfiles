#!/usr/bin/env bash

# Library of useful bash functions

timestamp () {
	printf "$(tput setaf 8)[$(date +'%H:%M:%S')] $(tput sgr0)"
}

info () {
	timestamp
	printf "$(tput setaf 8) [   ] %s$(tput sgr0)\n" "$@"
}

question () {
	timestamp
	printf "$(tput bold; tput setaf 7) [ ? ] %s$(tput sgr0) " "$1"
	if [ $# -lt 2 ]; then
		read answer
	else
		read -s answer
		echo
	fi
}

confirm () {
	timestamp
	printf "$(tput bold; tput setaf 7) [ ? ] %s (y/n) $(tput sgr0)" "$@"
	while read -r -n 1 -s confirm; do
		if [[ $confirm = [YyNn] ]]; then
			[[ $confirm = [Yy] ]] && retval=0
			[[ $confirm = [Nn] ]] && retval=1
		break
		fi
	done
	echo
	return $retval
}

pause () {
	timestamp
	if [[ "$@" == "" ]]; then
		printf "$(tput setaf 8) [ ◼ ] Press any key to continue $(tput sgr0)" "$@"
	else
		printf "$(tput setaf 8) [ ◼ ] %s $(tput sgr0)" "$@"
	fi
	read -n 1 -s -r anykey
	echo
}

success () {
	timestamp
	printf "$(tput bold; tput setaf 64) [ ✓ ] %s$(tput sgr0)\n" "$@"
}

error () {
	timestamp
	printf "$(tput bold; tput setaf 1) [ x ] %s$(tput sgr0)\n" "$@"
}

warning () {
	timestamp
	printf "$(tput bold; tput setaf 136) [ ! ] %s$(tput sgr0)\n" "$@"
}

fail () {
	timestamp
	printf "$(tput setaf 1) [ X ] %s$(tput sgr0)\n" "$@"
	exit
}

link_file () {
	local src=$1 dst=$2

	local overwrite= backup= skip=
	local action=

	if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]; then

		if [ "$overwriteAll" == "false" ] && [ "$backupAll" == "false" ] && [ "$skipAll" == "false" ]; then
			local currentSrc="$(readlink $dst)"

			if [ "$currentSrc" == "$src" ]; then
				skip=true;
			else
				user "File already exists: $(basename "$src"), what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
				read -n 1 action
				case "$action" in
					o ) overwrite=true;;
					O ) overwrite_all=true;;
					b ) backup=true;;
					B ) backup_all=true;;
					s ) skip=true;;
					S ) skip_all=true;;
					* ) ;;
				esac
			fi
		fi

		overwrite=${overwrite:-$overwriteAll}
		backup=${backup:-$backupAll}
		skip=${skip:-$skipAll}

		if [ "$overwrite" == "true" ]; then
			rm -rf "$dst" > /dev/null 2>&1 \
			&& success "removed $(basename "$dst")" \
			|| error "Unable to remove $(basename "$dst")"
		fi

		if [ "$backup" == "true" ]; then
			mv "$dst" "${dst}.backup" > /dev/null 2>&1 \
			&& success "moved $(basename "$dst") to $(basename "$dst").backup" \
			|| success "Unable to move $(basename "$dst") to $(basename "$dst").backup"
		fi

		if [ "$skip" == "true" ]; then
			success "skipped $(basename "$src")"
		fi
	fi

	if [ "$skip" != "true" ]; then
		ln -s "$1" "$2" > /dev/null 2>&1 \
		&& success "linked $1 to $2" \
		|| error "Unable to link $1 to $2"
	fi
}
