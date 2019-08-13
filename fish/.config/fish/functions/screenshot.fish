function screenshot -a outname
  set -- outname $outname -
  if test (uname) = Darwin
    screencapture -i $outname
  else if test $XDG_SESSION_TYPE = wayland
    grim -g (slurp) $outname
  else
    maim -s -f png $outname
  end
end
