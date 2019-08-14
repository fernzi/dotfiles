# Fern's Dotfiles

Hi there! You've reached my dotfiles! I'm quite a picky person, so I won't
pretend they'll be useful for everyone, but maybe you can find some interesting
lil' snippets by looking around.

## Installation

I manage my configs with [GNU Stow][stow], because there's literally no reason
to use anything more complicated than that. You can install it with your OS of
choice's package manager:

```sh
# For Arch Linux, Manjaro and who knows what else:
pacman -S stow

# For Void:
xbps-install -S stow

# For Debian, Ubuntu and the rest of the family:
apt install stow

# For MacOS w/ Homebrew:
brew install stow
```

You can then clone this repo (or download a ZIP of it, but why would you?!) into
a convenient directory like `~/.dotfiles/` and then use Stow to add symlinks to
my dotfiles to your exisiting configuration. For example

```sh
cd ~/.dotfiles
stow fish
```

would install my configuration for the [Fish shell][fish]. A similar command
can be used for any of the other app-specific directories in the repository.

[stow]: https://www.gnu.org/software/stow/
[fish]: https://fishshell.com/
