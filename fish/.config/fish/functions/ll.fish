# Fern's Dotfiles
# https://github.com/fernzi/dotfiles
# ll.fish - Use `exa` as an `ls` replacement, if available

if command -q exa
	function ll -w exa -d 'List contents of directory in long format'
		exa -l --git --group-directories-first --icons $argv
	end
else
	# Use Fish's default `ls` wrapper if `exa` is not installed
	source $fish_function_path[-1]/ll.fish
end
