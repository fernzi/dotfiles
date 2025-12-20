#######################################################################
# Fern's Dotfiles -- Zsh - Prompt & Line Editing
# https://github.com/fernzi/dotfiles
#######################################################################

autoload -Uz promptinit
promptinit

# Load the best and slightly more creatively
# named prompt theme of all time ever forever.
prompt kins

# Remove that annoying space after the right prompt.
ZLE_RPROMPT_INDENT=0

PROMPT_EOL_MARK='%F{red}%S↵%s%f'

unsetopt beep

# Moving and deleting words is a bit greedy by default.
WORDCHARS=${WORDCHARS//[\/=._-]/}

setopt autocd

setopt autocontinue
