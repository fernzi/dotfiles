#######################################################################
# Fern's Dotfiles -- Zsh - Key Bindings
# https://github.com/fernzi/dotfiles
#######################################################################

# Set the default bindings to Emacs-style.
# Clearly the superior editor.
bindkey -e

# <key>  <action>
readonly -A key=(
	# Movement
	khome  beginning-of-line
	kend   end-of-line
	kLFT   vi-backward-blank-word
	kLFT3  backward-word
	kLFT5  backward-word
	kRIT   vi-forward-blank-word
	kRIT3  forward-word
	kRIT5  forward-word

	# Editing
	kbs    backward-delete-char
	kdch1  delete-char
	kich1  overwrite-mode

	# History
	# kcuu1  up-line-or-beginning-search
	kcuu1  history-substring-search-up
	# kcud1  down-line-or-beginning-search
	kcud1  history-substring-search-down
	kpp    beginning-of-buffer-or-history
	knp    end-of-buffer-or-history

	# Utilities
	'\ee'  edit-command-line
	'\eh'  open-manual
	'\el'  list-directory
	'\ep'  append-pager
	'\es'  prepend-sudo
)

## Widgets ############################################################

# autoload -Uz \
# 	up-line-or-beginning-search \
# 	down-line-or-beginning-search

# zle -N up-line-or-beginning-search
# zle -N down-line-or-beginning-search

autoload -Uz edit-command-line
zle -N edit-command-line

## Plugins ############################################################

readonly plugdirs=(
	/usr/share/zsh/plugins
	$ZSH_CONFIG/plugins
	$ZSH_DATA/plugins
)

readonly plugins=(
	syntax-highlighting
	history-substring-search
	autosuggestions
)

for plug in $plugins; do
	for dir in $plugdirs; do
		local plugfile="$dir/zsh-$plug/zsh-$plug.zsh"
		if [[ -r $plugfile ]]; then
			source $plugfile
			break
		fi
	done
done

## Bind Processing ####################################################

# Get the correct key codes from `terminfo`.
# Why doesn't ZSH do this by default?
# Will try to bind the string as is if it's not
# the name of a terminal capability.
for kcode kfunc in ${(kv)key}; do
	bindkey -- ${terminfo[$kcode]:-$kcode} $kfunc
done

# Make sure the terminal is in application mode ...whatever that is.
# Otherwise the `terminfo` codes don't work.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget

	_zle-app-mode-start() { echoti smkx }
	_zle-app-mode-stop()  { echoti rmkx }

	add-zle-hook-widget -Uz zle-line-init   _zle-app-mode-start
	add-zle-hook-widget -Uz zle-line-finish _zle-app-mode-stop
fi
