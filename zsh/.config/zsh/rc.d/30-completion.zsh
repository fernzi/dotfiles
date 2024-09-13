#######################################################################
# Fern's Dotfiles -- Zsh - Completion System
# https://github.com/fernzi/dotfiles
#######################################################################

# Handle slashes gracefully when completing paths.
# Not sure why, but unnecessary trailing slashes just bother me.
setopt auto_param_slash
setopt auto_remove_slash

setopt extended_glob

# What was this again?
setopt list_packed

# WIP: List completion options.
unsetopt list_ambiguous

zstyle ':completion:*' menu select
zstyle ':completion:*' list-prompt ''
zstyle ':completion:*' select-prompt ''
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*' format '%B%F{yellow}%d%f%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose true

# Use case insensitive completion matching,
# and partial word completion if that fails.
zstyle ':completion:*' matcher-list \
	'm:{[:lower:]}={[:upper:]}' \
	'+r:|[._-]=* r:|=*' \
	'+l:|=*'

# Don't complete functions starting with a dash or underscore.
# Nor Zsh's precmd/exec special functions.
# There's no much reason to run em manually.
zstyle ':completion:*:functions' ignored-patterns '([-_]*|pre(cmd|exec))'

# zstyle ':completion:*:options' description yes
zstyle ':completion:*:options' auto-description '%d'

zstyle ':completion:*:*:kill:*:processes' \
	list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# Use the completion cache.
zstyle ':completion:*' cache-path ${ZSH_CACHE}/completion
zstyle ':completion:*' use-cache true

## Custom Comlpletions ################################################

# Tabtab for Node programs
local tabtab="${XDG_CONFIG_HOME:-$HOME/.config}/tabtab/zsh/__tabtab.zsh"
if [[ -f $tabtab ]]; then
	. $tabtab || true
fi

# AUR helper wrapper/shorthand `pacman`.
if [[ -v commands[pacman] ]]; then
	compdef p=pacman
fi

## Initialization #####################################################

# This makes loaded widgets use the 'new' completion system,
# so it needs to be at the very end so it catches them all.

autoload -Uz compinit
compinit -d ${ZSH_CACHE}/completion.dump
