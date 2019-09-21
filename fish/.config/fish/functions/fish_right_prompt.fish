function fish_right_prompt
  set_color -o red
  set dir (basename (string replace -r \^$HOME \~ $PWD))
  set -q DISPLAY && printf '❮❮❮ %s' $dir || printf '<<< %s' $dir
  set_color normal
end
