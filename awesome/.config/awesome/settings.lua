-----------------------------------------------------------------------
-- Fern Zapata
-- https://github.com/ferzapata/dotfiles
-- Awesome Window Manager - User Settings
-----------------------------------------------------------------------

return {
  terminal = 'alacritty',
  launcher = 'rofi -show drun',
  window_switcher = 'rofi -show window',
  file_manager = 'thunar',
  wallpaper = 'Pictures/wallpapers/other/deco.png',
  tags = {
    'a', 'o', 'e', 'u', 'i',
    'd', 'h', 't', 'n', 's',
  },
  autostart = {
    'setxkbmap -option compose:ralt',
    'ibus-daemon -dxr',
    'picom --experimental-backends',
    'nm-applet',
  },
}
