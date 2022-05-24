#######################################################################
# Fern's Dotfiles
# https://gitlab.com/fernzi/dotfiles
# Fish Shell - Environment Variables
#######################################################################

status is-login || exit

umask 027

# Add my personal scripts to the path.
# And also a static version of XBPS I use sometimes,
# every so often, maybe, once in a blue moon.
fish_add_path -g ~/.local/bin
fish_add_path -g ~/.local/share/xbps/usr/bin

## Default Programs ###################################################

# Set the first available editor as default,
# ordered in increasing levels of pain.
# I can use `vi`, but that doesn't mean I like it.
for editor in kak nvim vim vi micro nano
	if command -q $editor
		set -x EDITOR $editor
		set -x VISUAL $editor
		break
	end
end

# Set a default file opener.
# It's fascinating how `xdg-open` is not XDG compliant
# unless you also install `mimeopen` anyway.
for opener in open mimeopen mimeo handlr xdg-open
	if command -q $opener
		set -x OPENER $opener
		set -x BROWSER $opener
	end
end

## Utilities ##########################################################

# Use GPG subkeys for SSH.
# Seemed pretty handy a good while ago,
# but I'm starting to reconsider this decision.
if command -q gpgconf
	set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
end

# `less`, please respect my colours.
set -x LESS -R

# Make `exa` extra good looking.
# Not that it's any bad by default.
set -x EXA_GRID_ROWS 6
set -x EXA_ICON_SPACING 2

# Export all these to that SystemD abomination.
if set -q DISPLAY && command -q systemctl
	dbus-update-activation-environment --systemd --all
end
