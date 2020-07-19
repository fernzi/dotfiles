-----------------------------------------------------------------------
-- Fern Zapata
-- https://github.com/ferzapata/dotfiles
-- Awesome Window Manager - Autostart
-----------------------------------------------------------------------

return {
  'setxkbmap -option compose:ralt',
  'ibus-daemon -dxr',
  'picom --experimental-backends',
  'nm-applet',
}
