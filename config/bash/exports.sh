export DOTFILES_ROOT=$DOTFILES_ROOT

# Prefer US English and use UTF-8
export LANG="en_US.UTF-8";
export LC_ALL="en_US.UTF-8";

# Set the default editor
if which code > /dev/null 2>&1; then
	export EDITOR="code";
elif which atom > /dev/null 2>&1; then
	export EDITOR="atom";
elif which subl > /dev/null 2>&1; then
	export EDITOR="subl";
else
	export EDITOR="vim";
fi;

# Set 256 color terminal mode
if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
	export TERM='gnome-256color';
elif infocmp xterm-256color >/dev/null 2>&1; then
	export TERM='xterm-256color';
fi;

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X";
# Highlight section titles in manual pages
export LESS_TERMCAP_md="${yellow}";

# Larger bash history (allow 32³ entries; default is 500)
export HISTSIZE=32768;
export HISTFILESIZE=$HISTSIZE;
export HISTCONTROL=ignorespace:erasedups;
# Make some commands not show up in history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help";
# Add a timestamp to history
export HISTTIMEFORMAT=" %h/%d/%y-%H:%M:%S   "

# Make new shells get the history lines from all previous
# shells instead of the default "last window closed" history
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# Add extras to Git shell prompt goodies
export GIT_PS1_SHOWDIRTYSTATE=true;
export GIT_PS1_SHOWUNTRACKEDFILES=true;
export GIT_PS1_SHOWSTASHSTATE=true;

# Don't use the /etc/hosts for bash completion
export COMP_KNOWN_HOSTS_WITH_HOSTFILE=""

# macOS only
if [ "$(uname -s)" == "Darwin" ]; then
	# Link Homebrew casks in `/Applications` rather than `~/Applications`
	export HOMEBREW_CASK_OPTS="--appdir=/Applications";

	# Golang
	if which brew > /dev/null; then
		export GOPATH="$(brew --prefix)/lib/go"
	fi
fi
