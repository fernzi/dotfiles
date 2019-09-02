function screenpick -d 'Pick colour from screen'
  if test $XDG_SESSION_TYPE = wayland
    slurp -p | grim -g - - 2> /dev/null
  else
    maim -st 0
  end | convert - -format '#%[hex:u]\n' info: 2> /dev/null
end
