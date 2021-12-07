#######################################################################
# Fern's Dotfiles
# https://gitlab.com/fernzi/dotfiles
# e.fish - Run the default text editor
#######################################################################

set -l editor $VISUAL $EDITOR vi

function e -w $editor[1] -d 'Default editor' -V editor
	$editor[1] $argv
end
