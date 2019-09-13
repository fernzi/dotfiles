function colortest -d 'Show terminal colours'
  set cs (set_color -c)
  set cs $cs[-1] $cs[1..-2]
  set tx $COLORTEST_TEXT '●●'
  echo
  for c0 in $cs
    for c1 in $cs
      printf ' %s %s %s' (set_color -b $c1 $c0) $tx[1] (set_color normal)
    end
    echo
  end
end
