function fish_prompt
  set_color -r red
  test (id -u) -eq 0 && set -l pchar '#' || set -l pchar '●'
  printf '\n %s ' $pchar
  set_color -b black normal
  printf ' %s ' $USER
  set_color normal
  printf ' '
end
