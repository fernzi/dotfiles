#######################################################################
# Fern's Dotfiles
# https://gitlab.com/fernzi/dotfiles
# killjail.fish - Close Firejail sandboxes from a menu
#######################################################################

command -q firejail || exit

function killjail -d 'Shutdown a Firejail sandbox'
	firejail --list | fzy | cut -d: -f1 | xargs -ri firejail --shutdown={}
end
