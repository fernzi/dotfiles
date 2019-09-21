function fish_prompt
  set_color -o red
  set -q DISPLAY && printf '\n❯❯❯ ' || printf '\n>>> '
  set_color normal
end
