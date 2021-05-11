# Fern Zapata
# https://github.com/fernzi/dotfiles
# Qtile Window Manager - Window movement

from contextlib import suppress
from libqtile.window import Window


def center(win: Window) -> None:
  if win.floating:
    win.tweak_float(
      win.group.screen.width // 2,
      win.group.screen.height // 2,
      -win.width // 2,
      -win.height // 2,
    )


def to_prev_group(win: Window) -> None:
  grp = win.group.get_previous_group()
  win.togroup(grp.name, switch_group=True)


def to_next_group(win: Window) -> None:
  grp = win.group.get_next_group()
  win.togroup(grp.name, switch_group=True)


def to_group_index(win: Window, i: int) -> None:
  with suppress(IndexError):
    win.togroup(win.qtile.groups[i].name, switch_group=True)
