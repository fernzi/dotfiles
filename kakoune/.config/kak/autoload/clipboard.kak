################################################################################
# System Clipboard
################################################################################

declare-option -docstring 'clipboard copy command' str copycmd %sh{
  if [ $(uname) = Darwin ]; then
    echo pbcopy
  elif [ $XDG_SESSION_TYPE = wayland ]; then
    echo wl-copy
  else
    echo xclip -sel clipboard
  fi
}

declare-option -docstring 'clipboard paste command' str pastecmd %sh{
  if [ $(uname) = Darwin ]; then
    echo pbpaste
  elif [ $XDG_SESSION_TYPE = wayland ]; then
    echo wl-paste -n
  else
    echo xclip -sel clipboard -o
  fi
}

define-command clipboard-yank %{
  #execute-keys "<a-|>%opt{copycmd}<ret>"
  nop %sh{
    printf '%s' $kak_selections | $kak_opt_copycmd > /dev/null 2>&1 &
  }
  echo -markup '{Information}selection copied to clipboard'
}

define-command clipboard-paste %{
  execute-keys -draft "!%opt{pastecmd}<ret>"
}

define-command clipboard-paste-before %{
  execute-keys -draft "<a-!>%opt{pastecmd}<ret>"
}

define-command clipboard-replace %{
  execute-keys -draft "|%opt{pastecmd}<ret>"
}

################################################################################
