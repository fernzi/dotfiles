#######################################################################
# Fern's Dotfiles -- Zsh - Default Environment
# https://github.com/fernzi/dotfiles
#######################################################################

# Add my personal scripts to the path.
# Though most of my scripts are just functions instead.
path=(~/.local/bin{,/**/*(N/)} $path)

## Default Programs ###################################################

# Set the first available editor as default,
# ordered in increasing levels of pain.
# I can use `vi`, but that doesn't mean I like it.
for editor in kak nvim micro vim vi nano; do
	if [[ -v commands[$editor] ]]; then
		export EDITOR="$editor"
		export VISUAL="$editor"
		break
	fi
done

# Set a default file opener.
# It's fascinating how `xdg-open` is not XDG compliant
# unless you also install `mimeopen` anyway.
export BROWSER="${ZSH_CONFIG}/functions/open"
export OPENER="${BROWSER}"

## Default Options ####################################################

# Use GPG subkeys for SSH.
# Seemed pretty handy a good while ago,
# but I'm starting to reconsider this decision.
if [[ -v commands[gpgconf] ]]; then
	export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
fi

# Get `less` to respect my colours.
export LESS=(-R)

# Make `exa` extra good looking.
# Not that it's any bad by default.
export EXA_GRID_ROWS=6
export EXA_ICON_SPACING=2

# Use the Qt version of LibreOffice.
# Not that I actually use it too much.
export SAL_USE_VCLPLUGIN=qt6
export SAL_DISABLE_OPENCL=1
