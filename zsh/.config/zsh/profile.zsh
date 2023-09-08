#######################################################################
# Fern's Dotfiles -- Zsh - Profile
# https://github.com/fernzi/dotfiles
#######################################################################

# Create the cache directory if it doesn't exist.
# Think it kinda makes more sense in `env.zsh`,
# but it didn't feel right to check the disk on
# every shell launched.
if [[ ! -d $ZSH_CACHE ]]; then
	mkdir -p $ZSH_CACHE
fi

# Source all the scripts on `profile.d`.
# The anonymous function should catch all the local variables,
# but still allow the exported ones to remain.
for f in $ZSH_CONFIG/profile.d/*.zsh(N.); do
	function { source $f }
done
