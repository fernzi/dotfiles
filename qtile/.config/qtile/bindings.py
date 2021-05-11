# Fern Zapata
# https://github.com/fernzi/dotfiles
# Qtile Window Manager - Key/mouse bindings

from libqtile.config import Click, Drag, Key, KeyChord
from libqtile.lazy import lazy

import settings
from util import audio
from util import mpc
from util import screenshot
from util import task
from util import window as winutil


def _group_index_to_screen(qtile, i: int) -> None:
  try:
    qtile.groups[i].cmd_toscreen()
  except IndexError:
    pass


class Mod:
  M = 'mod4'
  A = 'mod1'
  C = 'control'
  S = 'shift'


keys = [
  Key(
    [Mod.M, Mod.C], 'Delete',
    lazy.restart(),
    desc='Restart qtile',
  ),
  Key(
    [Mod.M, Mod.C], 'BackSpace',
    lazy.spawn('wm-logout-prompt'),
    desc='Shutdown qtile',
  ),

  Key(
    [Mod.M], 'r',
    lazy.spawncmd(),
    desc='Spawn a command using a prompt widget',
  ),

  # Windows

  Key(
    [Mod.M], 'Left',
    lazy.layout.left(),
    desc='Focus window to the left',
  ),
  Key(
    [Mod.M], 'Down',
    lazy.layout.down(),
    desc='Focus window below',
  ),
  Key(
    [Mod.M], 'Up',
    lazy.layout.up(),
    desc='Focus window above',
  ),
  Key(
    [Mod.M], 'Right',
    lazy.layout.right(),
    desc='Focus window to the right',
  ),
  Key(
    [Mod.M], 'space',
    lazy.group.next_window(),
    desc='Focus next window',
  ),

  Key(
    [Mod.M, Mod.S], 'Left',
    lazy.layout.swap_left(),
    desc='Swap window to the left',
  ),
  Key(
    [Mod.M, Mod.S], 'Down',
    lazy.layout.shuffle_down(),
    desc='Swap window down',
  ),
  Key(
    [Mod.M, Mod.S], 'Up',
    lazy.layout.shuffle_up(),
    desc='Swap window up',
  ),
  Key(
    [Mod.M, Mod.S], 'Right',
    lazy.layout.swap_right(),
    desc='Swap window to the right',
  ),

  Key(
    [Mod.M], 'comma',
    lazy.window.function(winutil.center),
    desc='Center window on screen',
  ),

  Key(
    [Mod.M], 'f',
    lazy.window.toggle_fullscreen(),
    desc='Toggle window fullscreen',
  ),
  Key(
    [Mod.M, Mod.S], 'f',
    lazy.window.toggle_floating(),
    desc='Toggle window floating',
  ),
  Key(
    [Mod.M], 'w',
    lazy.window.kill(),
    desc='Close current window',
  ),

  # Layouts

  Key(
    [Mod.M], 'Tab',
    lazy.next_layout(),
    desc='Toggle between layouts',
  ),
  Key(
    [Mod.M, Mod.S], 'space',
    lazy.layout.flip(),
    desc='Flip main window side'
  ),

  # Groups

  Key(
    [Mod.M, Mod.C], 'Left',
    lazy.screen.prev_group(),
    desc='Switch to previous group',
  ),
  Key(
    [Mod.M, Mod.C], 'Right',
    lazy.screen.next_group(),
    desc='Switch to next group',
  ),
  Key(
    [Mod.M], 'grave',
    lazy.screen.toggle_group(),
    desc='Switch to last group',
  ),

  Key(
    [Mod.M, Mod.C, Mod.S], 'Left',
    lazy.window.function(winutil.to_prev_group),
    desc='Move window to previous group',
  ),
  Key(
    [Mod.M, Mod.C, Mod.S], 'Right',
    lazy.window.function(winutil.to_next_group),
    desc='Move window to next group',
  ),

  # Applications

  Key(
    [Mod.M], 'Return',
    lazy.spawn(settings.terminal),
    desc='Launch terminal',
  ),
  Key(
    [Mod.M, Mod.S], 'Return',
    lazy.spawn(settings.launcher),
    desc='Show application launcher',
  ),
  Key(
    [Mod.M, Mod.S], 'grave',
    lazy.spawn(settings.switcher),
    desc='Launch window switcher',
  ),
  Key(
    [Mod.M], 'slash',
    lazy.spawn(settings.file_manager),
    desc='Launch file manager',
  ),

  KeyChord([Mod.M], 'Escape', [
    Key(
      [], 'a',
      lazy.spawn(settings.applications['mixer']),
      desc='Launch audio mixer',
    ),
    Key(
      [], 'w',
      lazy.spawn(settings.applications['web_browser']),
      desc='Launch web browser',
    ),
    Key(
      [], 'd',
      lazy.spawn(settings.applications['messenger']),
      desc='Launch messaging application',
    )
  ]),

  # Media

  Key(
    [], 'XF86AudioPlay',
    lazy.function(mpc.play),
    desc='Play/pause MPD reproduction',
  ),
  Key(
    [], 'XF86AudioStop',
    lazy.function(mpc.stop),
    desc='Stop MPD reproduction',
  ),
  Key(
    [], 'XF86AudioPrev',
    lazy.function(mpc.prev),
    desc='Play previous item in the MPD playlist',
  ),
  Key(
    [], 'XF86AudioNext',
    lazy.function(mpc.next),
    desc='Play next item in the MPD playlist',
  ),

  Key(
    [], 'XF86AudioMute',
    task.easy_async(audio.volume.toggle),
    desc='Mute audio',
  ),
  Key(
    [], 'XF86AudioLowerVolume',
    task.easy_async(audio.volume, -2),
    desc='Lower volume',
  ),
  Key(
    [], 'XF86AudioRaiseVolume',
    task.easy_async(audio.volume, 2),
    desc='Raise volume',
  ),

  Key(
    [], 'Print',
    task.easy_async(screenshot.full),
    desc='Capture the whole screen',
  ),
  KeyChord([Mod.C], 'Print', [
    Key(
      [], 'a',
      task.easy_async(screenshot.area),
      desc='Capture mouse-selected area',
    ),
    Key(
      [], 'w',
      task.easy_async(screenshot.window),
      desc='Capture current window',
    ),
  ])
]

for i in range(10):
  keys.extend([
    Key(
      [Mod.M], str((i + 1) % 10),
      lazy.function(_group_index_to_screen, i),
      desc=f'Switch to group {i + 1}',
    ),
    Key(
      [Mod.M, Mod.S], str((i + 1) % 10),
      lazy.window.function(winutil.to_group_index, i),
      desc=f'Switch to & move focused window to group {i + 1}',
    ),
  ])

mouse = [
  Drag(
    [Mod.M], 'Button1',
    lazy.window.set_position_floating(),
    start=lazy.window.get_position(),
  ),
  Drag(
    [Mod.M], 'Button3',
    lazy.window.set_size_floating(),
    start=lazy.window.get_size(),
  ),
  Click(
    [Mod.M], 'Button2',
    lazy.window.bring_to_front(),
  ),
]
