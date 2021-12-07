#######################################################################
# Fern's Dotfiles
# https://gitlab.com/fernzi/dotfiles
# ls.fish - Use `exa` as an `ls` replacement, if available
#######################################################################

# Use the default `ls` wrapper if `exa` is not installed.
if not command -q exa
	source $fish_function_path[-1]/ls.fish
	exit
end

function ls -w exa -d 'List contents of directory'
	exa -G --git --group-directories-first --icons $argv
end
