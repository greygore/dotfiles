# Shell prompt based on the Solarized Dark theme.
# Screenshot: http://imgur.com/CiXGoha
# Heavily inspired by @necolas’s prompt: https://github.com/necolas/dotfiles
# iTerm → Profiles → Text → use 13pt Monaco with 1.1 vertical spacing.

tput sgr0 # reset colors
bold=$(tput bold)
reset=$(tput sgr0)
black=$(tput setaf 0)
white=$(tput setaf 15)
# Solarized colors, taken from http://git.io/solarized-colors
base03=$(tput setaf 234)
base02=$(tput setaf 235)
base01=$(tput setaf 240)
base00=$(tput setaf 241)
base0=$(tput setaf 244)
base1=$(tput setaf 245)
base2=$(tput setaf 254)
base3=$(tput setaf 230)
yellow=$(tput setaf 136)
orange=$(tput setaf 166)
red=$(tput setaf 160)
magenta=$(tput setaf 125)
violet=$(tput setaf 61)
blue=$(tput setaf 33)
cyan=$(tput setaf 37)
green=$(tput setaf 64)

prompt_git() {
	local s='';
	local branchName='';

	# Check if the current directory is in a Git repository.
	if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then

		# check if the current directory is in .git before running git checks
		if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then

			# Ensure the index is up to date.
			git update-index --really-refresh -q &>/dev/null;

			# Check for uncommitted changes in the index.
			if ! $(git diff --quiet --ignore-submodules --cached); then
				s+='+';
			fi;

			# Check for unstaged changes.
			if ! $(git diff-files --quiet --ignore-submodules --); then
				s+='!';
			fi;

			# Check for untracked files.
			if [ -n "$(git ls-files --others --exclude-standard)" ]; then
				s+='?';
			fi;

			# Check for stashed files.
			if $(git rev-parse --verify refs/stash &>/dev/null); then
				s+='$';
			fi;

		fi;

		# Get the short symbolic ref.
		# If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
		# Otherwise, just give up.
		branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
			git rev-parse --short HEAD 2> /dev/null || \
			echo '(unknown)')";

		[ -n "${s}" ] && s=" [${s}]";

		echo "${violet} ${1}${branchName}${blue}${s}${reset}";
	else
		return;
	fi;
}

prompt_battery () {
	if [ "$(uname -s)" == "Darwin" ]; then
		local battery=$(ioreg -n AppleSmartBattery -r | awk '$1~/Capacity/{c[$1]=$3} END{OFMT="%.1f%%"; max=c["\"MaxCapacity\""]; print (max>0? 100*c["\"CurrentCapacity\""]/max: "?")}')
		local charging=$(ioreg -n AppleSmartBattery -r | awk '$1~/ExternalConnected/{gsub("Yes", "+");gsub("No", "-"); print substr($0, length, 1)}' | [ "$(cat)" == "+" ] && echo '⚡' || echo '🔋')
		echo "${base2}${battery} ${charging}${reset}"
	else
		return
	fi
}

prompt_return () {
	local code="$1"
	if [ $code -eq 0 ]; then
		echo " ${green}✔${reset}"
	else
		echo " ${red}✘${reset}"
	fi
}

prompt_top () {
	local top

	case $TERM in
		xterm*)
			# Set window/tab title
			# \033 = ESC
			# \007 = BEL
			top="\n\[\033]0;\w\007\]"
			;;
		*)
			top="\n"
			;;
	esac

	echo -e $top
}

prompt_left () {
	local left
	local userStyle
	local hostStyle

	# Highlight the user name when logged in as root
	if [ "${USER}" == "root" ]; then
		userStyle="${bold}${red}";
	else
		userStyle="${orange}";
	fi;

	# Highlight the hostname when connected via SSH.
	if [ "${SSH_TTY}" ]; then
		hostStyle="${bold}${red}";
	else
		hostStyle="${yellow}";
	fi;

	# user@host: ~/dir/
	left="${userStyle}\u${base01}@${hostStyle}\h${base01}: ${green}\w"
	# - mybranch [?]
	left+=$(command -v prompt_git > /dev/null 2>&1 && prompt_git)
	left+="${reset}";
	echo -e $left
}

prompt_right () {
	local right;
	right="\$(command -v prompt_battery > /dev/null 2>&1 && prompt_battery)"
	echo -e $right
}

prompt_bottom () {
	local bottom
	bottom="\n\[${base01}\][\T]\[${white}\] \$ \[${reset}\]" # [hh:mi:ss] $
	echo -e $bottom
}

set_prompt () {
	local RETURN=$?
	PS1=$(printf "%s%*s\r%s%s%s" "$(prompt_top)" "$(($(tput cols)+54))" "$(prompt_right)" "$(prompt_left)" "$(prompt_return $RETURN)" "$(prompt_bottom)")
}

PROMPT_COMMAND=set_prompt

PS2="\[${yellow}\]→ \[${reset}\]";
export PS2;
