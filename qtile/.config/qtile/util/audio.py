# Fern Zapata
# https://github.com/fernzi/dotfiles
# Qtile Window Manager - Audio Utilities

import os
import asyncio as aio
from contextlib import suppress
from typing import Optional

from pulsectl_asyncio import PulseAsync
from pulsectl import PulseSinkInfo

with suppress(ImportError):
  import gi
  gi.require_version('GSound', '1.0')
  from gi.repository import GSound
  from gi.repository import GLib


class SoundPlayer:
  _context: GSound.Context

  def __init__(self) -> None:
    with suppress(NameError):
      self._context = GSound.Context()
      self._context.init()

  def __call__(self, name: str) -> bool:
    try:
      mode = GSound.ATTR_EVENT_ID
      if os.access(name, os.R_OK):
        mode = GSound.ATTR_MEDIA_FILENAME
      return self._context.play_simple({mode: name})
    except (NameError, AttributeError, GLib.Error):
      return False


play = SoundPlayer()


class VolumeManager:
  CLIENT_NAME = 'qtile-volume-change'

  _pulse: Optional[PulseAsync] = None

  async def __call__(self, step: int = 0) -> None:
    if step == 0:
      await self.toggle()
    else:
      await self.change(step)

  async def _timeout(self) -> None:
    await aio.sleep(10)
    self._pulse.disconnect()

  async def _connect(self) -> None:
    if self._pulse is None:
      self._pulse = PulseAsync(self.CLIENT_NAME)
    if not self._pulse.connected:
      await self._pulse.connect()
      aio.create_task(self._timeout())

  async def _get_default_sink(self) -> PulseSinkInfo:
    info = await self._pulse.server_info()
    return await self._pulse.get_sink_by_name(info.default_sink_name)

  async def change(self, step: int) -> None:
    await self._connect()
    sink = await self._get_default_sink()
    await self._pulse.volume_change_all_chans(sink, step / 100)

  async def toggle(self) -> None:
    await self._connect()
    sink = await self._get_default_sink()
    await self._pulse.mute(sink, not sink.mute)


volume = VolumeManager()
