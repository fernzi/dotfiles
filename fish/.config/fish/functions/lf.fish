if command -qs lf
  function lf -w lf
    set -l lfdir $XDG_RUNTIME_DIR/lf /tmp/$USER/lf
    set -l tmp (mktemp -up $lfdir[1] cd.XXXXXXXX)
    command lf -last-dir-path=$tmp $argv
    if test -f $tmp
      read -l dir < $tmp
      rm $tmp
      test -d $dir -a $dir != $PWD && cd $dir
    end
  end
end
