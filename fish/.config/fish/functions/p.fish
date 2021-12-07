#######################################################################
# Fern's Dotfiles
# https://gitlab.com/fernzi/dotfiles
# p.fish - Use the latest and greatest `pacman` wrapper.
#######################################################################

for pac in paru yay pacman
	if command -q $pac
		function p -w $pac -V pac -d 'Package manager'
			$pac $argv
		end
		exit
	end
end
