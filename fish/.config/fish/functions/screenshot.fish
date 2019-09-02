function screenshot -a outname -d 'Capture image from screen'
  set -- outname $outname (date "+$HOME/Pictures/Screenshots/%F_%T.png")
  if test (uname) = Darwin
    screencapture -i $outname[1]
  else if test $XDG_SESSION_TYPE = wayland
    slurp | grim -g - -- $outname[1] 2> /dev/null
  else
    maim -s $outname[1]
  end
  test -f $outname && echo $outname
end
