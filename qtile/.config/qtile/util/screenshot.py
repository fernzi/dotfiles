# Fern Zapata
# https://github.com/fernzi/dotfiles
# Qtile Window Manager - Screenshot/cast utilities

import asyncio as aio
import time
from pathlib import Path

from libqtile import qtile
from gi.repository import Notify

import settings
from util import audio


def _screenshot_path() -> Path:
  try:
    path = Path(settings.screenshot_path)
  except AttributeError:
    path = Path('~/Pictures').expanduser()
  return path / 'Screenshots' / time.strftime('%F_%T.png')


async def _run(command: list, save: Path) -> bool:
  save.parent.mkdir(parents=True, exist_ok=True)
  proc = await aio.create_subprocess_exec(*command)
  await proc.wait()
  if save.exists():
    audio.play('screen-capture')
    if Notify.is_initted():
      Notify.Notification.new(
        'Screen captured!',
        str(save),
        str(save),
      ).show()
    return True
  return False


async def full() -> bool:
  save = _screenshot_path()
  command = ['maim', save]
  return await _run(command, save)


async def area() -> bool:
  save = _screenshot_path()
  command = ['maim', '-s', save]
  return await _run(command, save)


async def window() -> bool:
  try:
    save = _screenshot_path()
    window_id = str(qtile.current_window.info()['id'])
    command = ['maim', '-i', window_id, save]
    return await _run(command, save)
  except AttributeError:
    return False
