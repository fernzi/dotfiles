#######################################################################
# Fern's Dotfiles
# https://gitlab.com/fernzi/dotfiles
# ccat.fish - Output syntax-highlighted files
#######################################################################

function ccat -d 'Syntax highlighting'
	set -l cmd cat
	if command -q highlight
		set cmd highlight --force -O ansi --stdout
	else if command -q pygmentize
		set cmd pygmentize -g
	end
	$cmd -- $argv
end
