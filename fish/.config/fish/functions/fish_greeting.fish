function fish_greeting
  set -l art $__fish_config_dir/art.txt
  set -l maxline (wc -L $art | cut -f1 -d' ')
  set -l padline (math -s0 "($COLUMNS - ($maxline + 2) * 4) / 2")
  while read s
    string repeat -Nn $padline ' '
    for c in red magenta blue green
      set_color $c
      printf " %-$maxline"'s ' $s
    end
    echo
  end < $art
  set_color normal
end
