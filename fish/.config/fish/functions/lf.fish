if command -qs lf
  function lf -w lf
    set -l tmp (mktemp -up $XDG_RUNTIME_DIR/lf cd.XXXXXXXX)
    command lf -last-dir-path=$tmp $argv
    if test -f $tmp
      set -l dir (cat $tmp)
      rm $tmp
      test -d $dir && test $dir != $PWD && cd $dir
    end
  end
end
