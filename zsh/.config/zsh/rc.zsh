#######################################################################
# Fern's Dotfiles -- Z Shell
# https://github.com/fernzi/dotfiles
#######################################################################

# Autoload all the functions
fpath=(
	$ZSH_CONFIG/{functions,widgets,prompts}
	$fpath
)
autoload -Uz -- $fpath[1]/*(.:t)

# Autoloading is not enough for ZLE.
# Gotta declare 'em as widgets as well.
for wid in $fpath[2]/*(.:t); do
	autoload -Uz -- $wid
	zle -N -- ${wid#[-_]w[-_]} ${wid}
done

# Source all the scripts in `rc.d` for great neatness.
# Wrapped in an anonymous function to emulate Fish's
# behaviour concerning stray variables.
for f in $ZSH_CONFIG/rc.d/*.zsh(N.); do
	() { source $f }
done

# Set terminal emulator title
if declare -f zsh-title >/dev/null; then
	add-zsh-hook precmd  zsh-title
	add-zsh-hook preexec zsh-title
fi
