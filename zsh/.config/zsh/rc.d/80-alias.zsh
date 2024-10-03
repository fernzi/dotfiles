#######################################################################
# Fern's Dotfiles -- Zsh - Command Aliases
# https://github.com/fernzi/dotfiles
#######################################################################

local cmd

# I don't really keep up with the flavour of the month
# AUR helper, so which ones and in which order this checks
# is kind of arbitrary.

for cmd in yay paru pacman; do
	if [[ -v commands[${cmd}] ]]; then
		alias p=${cmd}
		break
	fi
done
