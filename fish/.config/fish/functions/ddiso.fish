#######################################################################
# Fern's Dotfiles
# https://gitlab.com/fernzi/dotfiles
# ddiso.fish - No need to remember the options for `dd` anymore
#######################################################################

function ddiso -a infile -a outfile -d 'Write image to block file'
	set -l sudo sudo
	command -q doas && set sudo doas
	$sudo dd if=$infile of=$outfile bs=4M status=progress oflag=sync
end
