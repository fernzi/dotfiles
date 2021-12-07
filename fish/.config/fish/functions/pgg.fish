#######################################################################
# Fern's Dotfiles
# https://gitlab.com/fernzi/dotfiles
# pgg.fish - Search processes by name and arguments
#######################################################################

# Bit curiously, I'm not quite sure what `pgg` stands for.
# I first encountered it in someone's `.bashrc`, as the alias
#
# 	alias pgg='ps aux | grep -v grep | grep'
#
# so might just be a mnemonic for the commands?
# It's fairly fragile, so it didn't stay like that
# long after I started using `fish` though.

function pgg -d 'Search processes'
	pgrep -fi -- $argv | xargs -r ps -o %p%u%a --no-headers
end
