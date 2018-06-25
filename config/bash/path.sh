# Move /usr/local/bin to front of path
export PATH="/usr/local/bin:$PATH";

# Add GNU coreutils to path
if [ -e "/usr/local/opt/coreutils/libexec/gnubin" ]; then
	export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH";
	export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH";
fi

# Add Go binaries to path
export PATH="$GOPATH/bin:$PATH"

# Ensure ~/bin is at the front of the path
export PATH="$HOME/bin:$PATH"

# Add Rust binaries to path
if [ -d "$HOME/.cargo/bin" ]; then
  export PATH="$PATH:$HOME/.cargo/bin"
fi
