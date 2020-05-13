#!/bin/sh
#######################################################################
# Newsboat - URL opener
#######################################################################

set -Cf

if [ "$(uname)" = Darwin ]; then
  cmd='open'
else
  case "$XDG_SESSION_DESKTOP" in
    gnome|pantheon|budgie*)
      cmd='gio open' ;;
    xfce)
      cmd='exo-open' ;;
    *)
      cmd='xdg-open' ;;
  esac
fi

setsid $cmd -- "$@" &>/dev/null &
