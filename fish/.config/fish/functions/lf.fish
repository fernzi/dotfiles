#######################################################################
# Fern's Dotfiles
# https://gitlab.com/fernzi/dotfiles
# lf.fish - Change to the last visited directory when `lf` exits
#######################################################################

command -q lf || exit

function lf -w lf
	# Store lf's last directory on a temporary file.
	set -l lfdir $XDG_RUNTIME_DIR/lf /tmp/$USER/lf
	set -l tmp (mktemp -up $lfdir[1] cd.XXXXXXXX)
	command lf -last-dir-path=$tmp $argv
	# And `cd` to it if it exists,
	# and it's not the current directory.
	if test -f $tmp
		read -l dir < $tmp
		rm $tmp
		test -d $dir -a $dir != $PWD && cd $dir
	end
end
