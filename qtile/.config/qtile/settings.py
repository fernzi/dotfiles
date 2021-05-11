# Fern Zapata
# https://github.com/fernzi/dotfiles
# Qtile Window Manager - User settings

terminal = 'alacritty'
launcher = 'rofi -show drun'
switcher = 'rofi -show window'
file_manager = 'pcmanfm-qt'

wallpaper = '~/Pictures/Wallpapers/Other/Waves.png'

applications = dict(
  messenger='discord',
  mixer='pavucontrol-qt',
  web_browser='qutebrowser',
)

autostart = [
  'lxqt-policykit-agent',
  'setxkbmap -option compose:ralt',
  'ibus-daemon -dxr',
  'picom --experimental-backends',
  'nm-applet',
  'blueman-applet',
]
