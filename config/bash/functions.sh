# Simple calculator
function calc() {
	local result="";
	result="$(printf "scale=10;$*\n" | bc --mathlib | tr -d '\\\n')";
	#                       └─ default (when `--mathlib` is used) is 20
	#
	if [[ "$result" == *.* ]]; then
		# improve the output for decimal numbers
		printf "$result" |
		sed -e 's/^\./0./'        `# add "0" for cases like ".5"` \
		    -e 's/^-\./-0./'      `# add "0" for cases like "-.5"`\
		    -e 's/0*$//;s/\.$//';  # remove trailing zeros
	else
		printf "$result";
	fi;
	printf "\n";
}

# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$_";
}

# Change working directory to the top-most Finder window location
function cdf() { # short for `cdfinder`
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')";
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
	local tmpFile="${@%/}.tar";
	tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1;

	size=$(
		stat -f"%z" "${tmpFile}" 2> /dev/null; # macOS `stat`
		stat -c"%s" "${tmpFile}" 2> /dev/null # GNU `stat`
	);

	local cmd="";
	if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
		# the .tar file is smaller than 50 MB and Zopfli is available; use it
		cmd="zopfli";
	else
		if hash pigz 2> /dev/null; then
			cmd="pigz";
		else
			cmd="gzip";
		fi;
	fi;

	echo "Compressing .tar using \`${cmd}\`…";
	"${cmd}" -v "${tmpFile}" || return 1;
	[ -f "${tmpFile}" ] && rm "${tmpFile}";
	echo "${tmpFile}.gz created successfully.";
}

# Determine size of a file or total size of a directory
function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
	else
		local arg=-sh;
	fi;
	if [[ -n "$@" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* *;
	fi;
}

# Use Git’s colored diff when available
hash git &>/dev/null;
if [ $? -eq 0 ]; then
	function diff() {
		git diff --no-index --color-words "$@";
	}
fi;

# Create a data URI from a file
function datauri() {
	local mimeType=$(file -b --mime-type "$1");
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8";
	fi;
	printf "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')" | pbcopy | printf "=> data URI copied to pasteboard.\n"
}

# Create a git.io short URL
function gitio() {
	if [ -z "${1}" -o -z "${2}" ]; then
		echo "Usage: \`gitio slug url\`";
		return 1;
	fi;
	curl -i http://git.io/ -F "url=${2}" -F "code=${1}";
}

# Start an HTTP server from a directory, optionally specifying the port
function server() {
	local port="${1:-8000}";
	sleep 1 && open "http://localhost:${port}/" &
	# Set the default Content-Type to `text/plain` instead of `application/octet-stream`
	# And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
	python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port";
}

# Compare original and gzipped file size
function gz() {
	local origsize=$(wc -c < "$1");
	local gzipsize=$(gzip -c "$1" | wc -c);
	local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l);
	printf "orig: %d bytes\n" "$origsize";
	printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio";
}

# All the dig info
function digga() {
	dig +nocmd "$1" any +multiline +noall +answer;
}

# UTF-8-encode a string of Unicode symbols
function escape() {
	printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u);
	# print a newline unless we’re piping the output to another program
	if [ -t 1 ]; then
		echo ""; # newline
	fi;
}

# Decode \x{ABCD}-style Unicode escape sequences
function unidecode() {
	perl -e "binmode(STDOUT, ':utf8'); print \"$@\"";
	# print a newline unless we’re piping the output to another program
	if [ -t 1 ]; then
		echo ""; # newline
	fi;
}

# Get a character’s Unicode code point
function codepoint() {
	perl -e "use utf8; print sprintf('U+%04X', ord(\"$@\"))";
	# print a newline unless we’re piping the output to another program
	if [ -t 1 ]; then
		echo ""; # newline
	fi;
}

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
function getcertnames() {
	if [ -z "${1}" ]; then
		echo "ERROR: No domain specified.";
		return 1;
	fi;

	local domain="${1}";
	echo "Testing ${domain}…";
	echo ""; # newline

	local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
		| openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1);

	if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
		local certText=$(echo "${tmp}" \
			| openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
			no_serial, no_sigdump, no_signame, no_validity, no_version");
		echo "Common Name:";
		echo ""; # newline
		echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//";
		echo ""; # newline
		echo "Subject Alternative Name(s):";
		echo ""; # newline
		echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
			| sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2;
		return 0;
	else
		echo "ERROR: Certificate not found.";
		return 1;
	fi;
}

# `s` with no arguments opens the current directory in Sublime Text, otherwise
# opens the given location
function s() {
	if [ $# -eq 0 ]; then
		subl .;
	else
		subl "$@";
	fi;
}

# `a` with no arguments opens the current directory in Atom Editor, otherwise
# opens the given location
function a() {
	if [ $# -eq 0 ]; then
		atom .;
	else
		atom "$@";
	fi;
}

# `c` with no arguments opens the current directory in VS Code Editor, otherwise
# opens the given location
function c() {
	if [ $# -eq 0 ]; then
		code .;
	else
		code "$@";
	fi;
}

# `v` with no arguments opens the current directory in Vim, otherwise opens the
# given location
function v() {
	if [ $# -eq 0 ]; then
		vim .;
	else
		vim "$@";
	fi;
}

# `o` with no arguments opens the current directory, otherwise opens the given
# location
function o() {
	if [ $# -eq 0 ]; then
		open .;
	else
		open "$@";
	fi;
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
	tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

# Add note to Notes.app (macOS 10.8)
# Usage: `note 'foo'` or `echo 'foo' | note`
function note() {
	local text;
	if [ -t 0 ]; then # argument
		text="$1";
	else # pipe
		text=$(cat);
	fi;
	body=$(echo "$text" | sed -E 's|$|<br>|g');
	osascript >/dev/null <<EOF
tell application "Notes"
	tell account "iCloud"
		tell folder "Notes"
			make new note with properties {name:"$text", body:"$body"}
		end tell
	end tell
end tell
EOF
}

# Add reminder to Reminders.app (macOS 10.8)
# Usage: `remind 'foo'` or `echo 'foo' | remind`
function remind() {
	local text;
	if [ -t 0 ]; then
		text="$1"; # argument
	else
		text=$(cat); # pipe
	fi;
	osascript >/dev/null <<EOF
tell application "Reminders"
	tell the default list
		make new reminder with properties {name:"$text"}
	end tell
end tell
EOF
}

# Get macOS Software Updates, and update Homebrew, npm, Ruby gems and Python packages
function update() {
	# Get macOS Software Updates
	if which softwareupdate > /dev/null; then
		sudo softwareupdate -i -a | tee -a ~/update.log
	fi
	# Homebrew
	if which brew > /dev/null; then
		brew update | tee -a ~/update.log
		brew upgrade --all | tee -a ~/update.log
		brew cleanup | tee -a ~/update.log
	fi
	# Node modules
	if which npm > /dev/null; then
		npm install npm -g | tee -a ~/update.log
		npm update -g | tee -a ~/update.log
	fi
	# Ruby gems (todo check for rvm...)
	if which gem > /dev/null; then
		gem update --system | tee -a ~/update.log
		gem update | tee -a ~/update.log
	fi
	# Python packages
	if which pip > /dev/null; then
		pip freeze | sed -e 's/==.*//' | sed -e '/git-remote-helpers/ d' | xargs pip install -U | tee -a ~/update.log
	fi
}

# Easy file extraction
function x () {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2)   tar xjf $1 ;;
			*.tar.gz)    tar xzf $1 ;;
			*.bz2)       bunzip2 $1 ;;
			*.rar)       rar x $1 ;;
			*.gz)        gunzip $1 ;;
			*.tar)       tar xvf $1 ;;
			*.tbz2)      tar xjf $1 ;;
			*.tgz)       tar xzf $1 ;;
			*.zip)       unzip $1 ;;
			*.Z)         uncompress $1 ;;
			*.7z)        7za x $1 ;;
			*.xz)        xz -d $1 ;;
			*)           echo "'$1' cannot be extracted via x()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

function shout() {
	if which figlet > /dev/null; then
		figlet "$1"
	fi
	if [ "$(uname -s)" == "Darwin" ]; then
		local volume
		volume=$(/usr/bin/osascript -e 'output volume of (get volume settings)')
		/usr/bin/osascript -e 'set volume output volume 100'
		say "$1"
		/usr/bin/osascript -e "set volume output volume $volume"
	fi
}

function whisper() {
	if [ "$(uname -s)" == "Darwin" ]; then
		local volume
		volume=$(/usr/bin/osascript -e 'output volume of (get volume settings)')
		/usr/bin/osascript -e 'set volume output volume 15'
		say "$1"
		/usr/bin/osascript -e "set volume output volume $volume"
	fi
}

# GitHub URL for current repo.
function gurl() {
	local remotename="${@:-origin}"
	local remote="$(git remote -v | awk '/^'"$remotename"'.*\(push\)$/ {print $2}')"
	[[ "$remote" ]] || return
	local user_repo="$(echo "$remote" | perl -pe 's/.*://;s/\.git$//')"
	echo "https://github.com/$user_repo"
}

# open all changed files (that still actually exist) in the editor
# credit: @cowboy
function ged() {
	local files=()
	for f in $(git diff --name-only "$@"); do
		[[ -e "$f" ]] && files=("${files[@]}" "$f")
	done
	local n=${#files[@]}
	echo "Opening $n $([[ "$@" ]] || echo "modified ")file$([[ $n != 1 ]] && \
		echo s)${@:+ modified in }$@"
	$EDITOR "${files[@]}"
}

# open last commit in GitHub, in the browser.
# credit: @cowboy
function gfu() {
	local n="${@:-1}"
	n=$((n-1))
	open $(git log -n 1 --skip=$n --pretty=oneline | awk "{printf \"$(gurl)/commit/%s\", substr(\$1,1,7)}")
}

# Incorporating ideas from http://osxnotes.net/defaults.html
function find_prefs() {
	[ -z "$1" ] && echo 'Please include a search term' && return 1
	echo "Searching strings of unix executables"
	echo
	mdfind kMDItemContentType=public.unix-executable -onlyin /System|xargs strings 2>/dev/null|grep -E '^[a-zA-Z0-9.-]{10,80}$'|awk '!a[$0]++'|grep -i "$1"
	echo
	echo "Searching strings of applications"
	echo
	sleep 1
	for f in /Applications/*.app/Contents/MacOS/*;do strings "$f" 2> /dev/null|awk '!a[$0]++'|grep -i "$1"|sed "s/^/${f##*/} /g"|grep -v '^TextWrangler';done
	echo
	echo "Searching FinderKit for strings"
	echo
	sleep 1
	strings /System/Library/PrivateFrameworks/FinderKit.framework/Versions/A/FinderKit|grep -E '^[[:alnum:]_.:-]{10,80}$'|awk '!a[$0]++'|grep -i "$1"
	echo
	echo "Don't forget:"
	echo "defaults read > defaults.before"
	echo "<make changes>"
	echo "defaults read > defaults.after"
	echo "diff defaults.before defaults.after"
}

function setenv-macos() {
	if [ "$(uname -s)" == "Darwin" ]; then
		local key
		local val

		if [ $# -lt 1 ] || [ -z "$1" ]; then
			echo "ERROR: No key specified."
			return 1
		fi
		key=$1

		if [ $# -lt 2 ] || [ -z "$2" ]; then
			eval val=\$$1
			if [ -z "$val" ]; then
				echo "ERROR: No value specified or found in current env."
				return 1
			fi
		else
			val=$2
		fi

		local file="$HOME/Library/LaunchAgents/setenv.$key.plist"

		launchctl unload $file > /dev/null 2>&1

		cat <<- EOF | tee $file > /dev/null 2>&1
			<?xml version="1.0" encoding="UTF-8"?>
			<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
			  <plist version="1.0">
			  <dict>
			  <key>Label</key>
			  <string>setenv.$key</string>
			  <key>ProgramArguments</key>
			  <array>
			    <string>/bin/launchctl</string>
			    <string>setenv</string>
			    <string>$key</string>
			    <string>$val</string>
			  </array>
			  <key>RunAtLoad</key>
			  <true/>
			</dict>
			</plist>
		EOF

		launchctl load $file

		eval val=\$$key
		sleep 1 # Necessary to make sure the getenv succeeds
		echo "$key=$(launchctl getenv $key)"
	fi
}
