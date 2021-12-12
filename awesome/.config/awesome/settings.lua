-----------------------------------------------------------------------
-- Fern's Dotfiles
-- https://gitlab.com/fernzi/dotfiles
-- Awesome Window Manager - User Settings
-----------------------------------------------------------------------

local settings = {}

settings.appearance = {
  theme     = 'fern',
  wallpaper = 'Pictures/Wallpapers/Other/Waves.png',
}

settings.tags = {
  '1', '2', '3', '4', '5',
  '6', '7', '8', '9', '0',
}

settings.applications = {
  browser  = 'qutebrowser',
  editor   = 'alacritty -e kak',
  files    = 'pcmanfm-qt',
  launcher = 'rofi -show drun',
  mixer    = 'pavucontrol-qt',
  music    = 'alacritty -e ncmpcpp',
  switcher = 'rofi -show window',
  terminal = 'alacritty',
}

settings.autostart = {
  'lxqt-policykit-agent',
  'setxkbmap -option compose:ralt',
  'ibus-daemon -dxr',
  'picom --experimental-backends',
  'nm-applet',
  'blueman-applet',
}

return settings
