function fish_right_prompt
  set_color -o red
  printf '❮❮❮ %s' (basename (string replace -r \^$HOME \~ $PWD))
  set_color normal
end
