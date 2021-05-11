# Fern Zapata
# https://github.com/fernzi/dotfiles
# Qtile Window Manager - Configuration

from libqtile import qtile, bar, layout, widget, hook
from libqtile.config import Group, Screen
from bindings import keys, mouse

import settings
from util.dpi import dpi
from widget.weather import Weather

# Groups ##############################################################

groups = [Group(str((i + 1) % 10)) for i in range(10)]

# Layouts #############################################################

layout_theme = dict(
  border_width=dpi(2),
  margin=dpi(48),
  border_focus='ffaed0',
  border_normal='202020',
)

layouts = [
  layout.MonadTall(
    align=layout.MonadTall._right,
    **layout_theme,
  ),
  layout.Stack(
    name='single',
    num_stacks=1,
    **layout_theme,
  ),
]

floating_layout = layout.Floating(
  float_rules=[
    *layout.Floating.default_float_rules,
  ],
)

widget_defaults = dict(
  font='Fira Sans Condensed,',
  fontsize=dpi(13),
  padding=dpi(8),
)

extension_defaults = widget_defaults.copy()

screens = [
  Screen(
    top=bar.Bar(
      [
        widget.CurrentLayout(),
        widget.GroupBox(),
        widget.Prompt(),
        widget.WindowName(),
        widget.Chord(
          chords_colors={
            'launch': ("#ff0000", "#ffffff"),
          },
          name_transform=lambda name: name.upper(),
        ),
        widget.PulseVolume(),
        widget.Systray(
          icon_size=dpi(28),
          padding=dpi(8),
        ),
        widget.Clock(
          format='%a %b %d  %R',
          fmt='<b>{}</b>',
        ),
        Weather(
          format='<b>{icon}  {temp}°{unit}</b>',
        ),
      ],
      dpi(32),
    ),
    wallpaper=settings.wallpaper,
    wallpaper_mode='fill',
  ),
]

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = 'smart'
wmname = 'LG3D'

# Hooks ###############################################################

@hook.subscribe.startup_once
def startup() -> None:
  for command in settings.autostart:
    qtile.cmd_spawn(command)
