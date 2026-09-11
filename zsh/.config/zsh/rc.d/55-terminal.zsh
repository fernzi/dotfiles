#######################################################################
# Fern's Dotfiles -- Zsh - Terminal Emulator Integration
# https://codeberg.org/fernzi/dotfiles
#######################################################################

# Some terminals have fancier features when the shell cooperates.
# I only really care for what Foot supports though.

_zsh_term_osc() {
  printf '\e]%d;%s\e\\' "$@"
}

### Set terminal emulator title ###

_zsh_term_title() {
  print '\e]0;'

  # Show the user and host only when running on SSH.
  if [[ -v SSH_CLIENT || -v SSH_TTY ]]; then
    printf '%s@%s : ' ${USER} ${HOST%%.*}
  fi

  # Add the current command's name when something is running.
  # The `preexec` hook passes the command line as arguments,
  # and the `precmd` hook then clears it.
  if [[ $# -gt 0 ]]; then
    printf '%s : ' ${1%% *}
  fi

  # Print the base name of the current directory,
  # substituting the home for a `~` when necessary.
  printf '%s — Zsh\a' ${${PWD/#$HOME/\~}##*/}
}
add-zsh-hook precmd  _zsh_term_title
add-zsh-hook preexec _zsh_term_title

### Set the current working directory (OSC-7) ###

_zsh_term_osc7() {
  (( ZSH_SUBSHELL )) && return
  setopt localoptions extendedglob
  local P="${PWD//(#m)([^@-Za-z&-;_~])/%${(l:2::0:)$(([##16]#MATCH))}}"
  _zsh_term_osc 7 "file://${HOST}${P}"
}
add-zsh-hook chpwd _zsh_term_osc7

### Capture command output (OSC-133) ###

_zsh_term_osc133c() {
  _zsh_term_osc 133 C
}
_zsh_term_osc133d() {
  if ! builtin zle; then
    _zsh_term_osc 133 D
  fi
}
add-zsh-hook preexec _zsh_term_osc133c
add-zsh-hook precmd _zsh_term_osc133d

### Jumping between prompts (OSC-133) ###

_zsh_term_osc133a() {
  _zsh_term_osc 133 A
}
add-zsh-hook precmd _zsh_term_osc133a
