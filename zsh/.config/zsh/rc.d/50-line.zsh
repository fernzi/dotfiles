#######################################################################
# Fern's Dotfiles -- Zsh - Prompt & Line Editing
# https://github.com/fernzi/dotfiles
#######################################################################

autoload -Uz promptinit
promptinit

# Load the absolute best and most creatively named
# prompt theme of all time ever forever.
prompt fernzi

# Remove that annoying space after the right prompt.
ZLE_RPROMPT_INDENT=0

PROMPT_EOL_MARK='%F{red}%S↵%s%f'

unsetopt beep

WORDCHARS='-_'

setopt autocd

setopt autocontinue
