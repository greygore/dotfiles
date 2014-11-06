# GreyGore’s dotfiles

This is my personal setup of a clean OS X Yosemite Mac. Eventually I'd like to use this to personalize my Linux shell(s) as well.

Originally this was forked from [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles), but it's since been added to and rewritten extensively.

## Installation

### Requirements

 * [curl](http://curl.haxx.se/)
 * [git](http://git-scm.com/)

A base installation of OS X Yosemite will include `curl`, while `git` will be installed automatically as part of the command line tools.

### One Line Install

```DOTFILES_USER="greygore" bash -c "$(curl -fsSL raw.github.com/$DOTFILES_USER/dotfiles/master/bootstrap.sh)"
```

:warning: If you fork, you must change `DOTFILES_USER` to your Github username.

By default the script will install in the `~/.dotfiles` directory. An alternate location can be provided with the `DOTFILES_DIRECTORY` variable. For example:

```DOTFILES_USER="greygore" DOTFILES_DIRECTORY="$HOME/dotfiles" bash -c "$(curl -fsSL raw.github.com/$GITHUB_USER/dotfiles/master/bootstrap.sh)"
```

## Customization

Although you should consider forking this repository and customizing it to your own needs, the installation script will attempt to prompt you for user specific information, rather than using hard-coded values.

Currently, the exception to this is the OS X locale information. *Don't worry:* if you are not in the US (and the Eastern timezone), you'll be able to opt out of this. In the future I'll consider adding additional locale and timezone choices; if you want this, please [file an issue](https://github.com/greygore/dotfiles/issues).

## Features

### General

 * Creates a public/private SSH key
 * Configures Git (`.gitconfig`)

### Dotfiles

All config files are symlinked into the home directory:

 - Bash configuration
    * `.aliases` - Aliases
    * `.bash_profile` - Main config, includes completions
    * `.bash_prompt` - Customized prompt
    * `.bashrc` - Loads main config
    * `.exports` - Environmental variables
    * `.functions` - Bash functions
 - Git configuration
    * `.gitattributes` - Path specific options
    * `.gitignore_global` - Git ignore file for all repos
 - Program configuration
    * `.curlrc`
    * `.jshintrc`
    * `.screenrc`
    * `.wgetrc`
 - Miscellaneous
    * `.editorconfig` - Portable text editor config
    * `.hushlogin` - Stub file to skip copyright notice
    * `.inputrc` - Keybindings and readline behavior

### OSX

 * Installs command line tools
 * Configures default OS settings
 * Install programs via [Homebrew](http://brew.sh/)
 * Install applications via [Cask](http://caskroom.io/)

### Custom bash prompt

The custom bash prompt is based on the [Solarized color palette](http://ethanschoonover.com/solarized). For best results be sure to use the included Terminal or [iTerm2](http://iterm2.com/) theme.

When your current working directory is a Git repository, the prompt will
display the checked-out branch's name (and failing that, the commit SHA that
HEAD is pointing to). The state of the working tree is reflected in the
following way:

<table>
    <tr>
        <td><code>+</code></td>
        <td>Uncommitted changes in the index</td>
    </tr>
    <tr>
        <td><code>!</code></td>
        <td>Unstaged changes</td>
    </tr>
    <tr>
        <td><code>?</code></td>
        <td>Untracked files</td>
    </tr>
    <tr>
        <td><code>$</code></td>
        <td>Stashed files</td>
    </tr>
</table>

Further details are in the `.bash_prompt` file.

## To Do

 * Remove hard-coded locale and/or allow selection of alternatives.
 * Make non-interactive version.
 * Add [zsh](http://www.zsh.org/) shell with [oh-my-zsh](http://ohmyz.sh/)

## Feedback

Suggestions/improvements
[welcome](https://github.com/greygore/dotfiles/issues)!

## Thanks to…

 * [Roderik van der Veer](http://vanderveer.be/) for his [Mountain Lion setup post](http://vanderveer.be/setting-up-my-perfect-developer-environment-on-osx-10-8-mountain-lion-dp3-edition/) which pointed me to...
 * [Mathias Bynens](http://mathiasbynens.be/) for [his widely forked dotfiles](https://github.com/mathiasbynens/dotfiles)
 * [Nicolas Gallagher](http://nicolasgallagher.com/) whose [dotfiles I shamelessly stole from](https://github.com/necolas/dotfiles)
 * 
