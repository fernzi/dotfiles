function xrkill -d 'Recursively  kill an X client'
  xprop _NET_WM_PID | cut -d= -f2 | xargs -r rkill
end
