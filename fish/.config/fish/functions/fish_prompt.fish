# Fern's Dotfiles
# https://github.com/fernzi/dotfiles
# fish_prompt - Prompt for the Fish shell

function fish_prompt
  printf '\n%s %s ' $(set_color -ro red) $USER
  set_color -b black normal
  printf ' %s ' (date +%T)
  set_color normal
  printf ' '
end
