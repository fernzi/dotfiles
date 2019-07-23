function fish_right_prompt
  set_color -o ffbcd9
  printf ''
  set -l cdir '~'
  if test $PWD != $HOME
    set cdir (basename $PWD)
  end
  printf ' %s' $cdir
  set_color normal
end
