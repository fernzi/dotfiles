function screenshot -a outname -d 'Capture image from screen'
  set -- outname $outname (date "+$HOME/Pictures/Screenshots/%F_%T.png")
  set -- outname $outname[1]
  if test (uname) = Darwin
    screencapture -i $outname
  else if test $XDG_SESSION_TYPE = wayland
    slurp | grim -g - -- $outname 2>/dev/null
  else
    maim -s $outname
  end
  test -f $outname && realpath $outname
end
