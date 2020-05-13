#!/bin/sh
if [ "$(uname)" = Darwin ]; then
  osascript -e "display notification \"$@\" with title \"Newsboat\""
else
  exec notify-send -a Newsboat -i feedreader Newsboat "$@"
fi
