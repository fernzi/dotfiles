#######################################################################
# Fern's Dotfiles
# https://gitlab.com/fernzi/dotfiles
# dl.fish - Tiny wrapper for `curl` with a couple conveniences
#######################################################################

function dl -w curl -d 'Download file from URL'
	curl -JLO# $argv
end
