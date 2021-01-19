function fish_prompt
  set_color red
  printf '\n'
  set_color -r red
  printf '• '
  set_color -b black normal
  printf ' %s' $USER
  set_color black -b normal
  printf ''
  set_color normal
  printf ' '
end
