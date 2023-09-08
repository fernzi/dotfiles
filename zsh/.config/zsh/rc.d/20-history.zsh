#######################################################################
# Fern's Dotfiles -- Zsh - History Settings
# https://github.com/fernzi/dotfiles
#######################################################################

HISTFILE="${ZSH_DATA}/history"
HISTSIZE=1000000
SAVEHIST=${HISTSIZE}

# Not storing history in the same place as configs,
# so gotta create the directory if it doesn't exist.
local histdir="${HISTFILE%/*}"
if [[ ! -d "${histdir}" ]]; then
	mkdir -p "${histdir}"
fi

# Save history entries with timestamps.
# Not really sure I've ever needed this,
# but having it just feels right.
setopt extendedhistory

# Share history across multiple terminals.
setopt append_history
setopt hist_fcntl_lock
setopt inc_append_history
setopt share_history

# Purge em filthy dupes from my command history.
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_save_no_dups

# Keep the history file clean of pointless stuff.
setopt hist_ignore_space
setopt hist_no_functions
setopt hist_no_store
setopt hist_reduce_blanks
