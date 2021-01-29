function fish_prompt
  set_color red
  printf '\n'
  set_color -ro red
  printf '%s ' $USER
  set_color -b black normal
  printf ' %s' (date +%T)
  set_color black -b normal
  printf ''
  set_color normal
  printf ' '
end
