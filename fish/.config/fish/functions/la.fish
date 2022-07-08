# Fern's Dotfiles
# https://github.com/fernzi/dotfiles
# la.fish - Use `exa` as an `ls` replacement, if available

if command -q exa
	function la -w exa -d 'List contents of directory including hidden entries'
		exa -la --git --group-directories-first --icons $argv
	end
else
	# Use Fish's default `ls` wrapper if `exa` is not installed
	source $fish_function_path[-1]/la.fish
end
