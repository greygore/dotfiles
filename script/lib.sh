#!/usr/bin/env bash

# Library of useful bash functions

info () {
	printf " [ \033[00;34m..\033[0m ] $1"
}

user () {
	printf "\r [ \033[0;33m?\033[0m ] $1 "
}

success () {
	printf "\r\033[2K [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
	printf "\r\033[2K [\033[0;31mFAIL\033[0m] $1\n"
	echo ''
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
			rm -rf "$dst"
			success "removed $(basename "$dst")"
		fi

		if [ "$backup" == "true" ]; then
			mv "$dst" "${dst}.backup"
			success "moved $(basename "$dst") to $(basename "$dst").backup"
		fi

		if [ "$skip" == "true" ]; then
			success "skipped $(basename "$src")"
		fi
	fi

	if [ "$skip" != "true" ]  # "false" or empty
		then
		ln -s "$1" "$2"
		success "linked $1 to $2"
	fi
}
