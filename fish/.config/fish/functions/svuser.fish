#######################################################################
# Fern's Dotfiles
# https://gitlab.com/fernzi/dotfiles
# svuser.fish - Control per-user `runit` services
#######################################################################

command -q sv || exit

function svuser -w sv
  set -lx SVDIR ~/.config/runit/service
  if set -q XDG_CONFIG_HOME
    set SVDIR $XDG_CONFIG_HOME/runit/service
  end
  sv $argv
end
