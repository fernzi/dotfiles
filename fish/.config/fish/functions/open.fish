# Fern's Dotfiles
# https://github.com/fernzi/dotfiles
# Open - Default application handler

command -q open && exit

function open -d 'Open file in default application'
	if not set -q argv[1]
		echo 'Expected at least 1 argument, got 0.' >&2
		return 1
	end

	if command -q handlr
		handlr open -- $argv
	else if command -q gio
		gio open -- $argv
	else if command -q mimeopen
		setsid mimeopen -n -- $argv &
	else if command -q xdg-open
		for f in $argv
			setsid xdg-open $f &
		end
	else
		echo 'No file handler found.' >&2
		return 1
	end
end
