# Fern Zapata
# https://github.com/fernzi/dotfiles
# Qtile Window Manager - Weather vidget

import asyncio as aio
import json
from collections import namedtuple
from contextlib import suppress
from datetime import datetime
from enum import Enum
from enum import auto
from pathlib import Path
from typing import Optional, Tuple

import aiofiles as aif
import aiofiles.os as aos
import aiohttp as aht
from appdirs import AppDirs
from libqtile.widget.base import InLoopPollText

__all__ = [
  'Weather'
]


Location = namedtuple('Location', ('lat', 'lon'))


class Units(Enum):
  C = auto()
  F = auto()
  K = auto()


class Weather(InLoopPollText):
  '''
  Display weather and temperature at your current location.
  '''

  defaults = [
    # I may've borrowed this from somewhere…
    ('api_key', '5819a34c58f8f07bc282820ca08948f1',
     'OpenWeatherMap API key'),
    ('format', '{icon} {temp}°{unit}',
     'Display format'),
    ('update_interval', 1800,
     'Update time in seconds'),
    ('units', Units.C.name,
     'Temperature display units (C, F or K)'),
  ]

  API_URL = 'https://api.openweathermap.org/data/2.5/weather'
  GEO_URL = 'https://freegeoip.live/json/'
  ICONS = {
    # Day
    '01d': '', '02d': '', '03d': '',
    '04d': '', '09d': '', '10d': '',
    '11d': '', '13d': '', '50d': '',
    # Night
    '01n': '', '02n': '', '03n': '',
    '04n': '', '09n': '', '10n': '',
    '11n': '', '13n': '', '50n': '',
    # Unknown
    '000': '',
  }
  DIR = AppDirs('qtile')

  def __init__(self, **config):
    super().__init__(default_text=self.ICONS['000'], **config)
    self.add_defaults(Weather.defaults)

  def tick(self) -> None:
    self.qtile.call_soon(aio.create_task, self.fetch())

  async def fetch(self) -> None:
    with suppress(TypeError):
      icon, temp = await self._from_cache()
      return self.set_weather(icon, temp)

    async with aht.ClientSession() as session:
      async with session.get(self.GEO_URL) as response:
        if response.status != 200:
          self.update(self.ICONS['000'])
          return

        geo = await response.json()
        loc = Location(geo['latitude'], geo['longitude'])

      args = dict(
        APPID=self.api_key,
        lat=str(loc.lat),
        lon=str(loc.lon),
      )

      async with session.get(self.API_URL, params=args) as response:
        if response.status != 200:
          self.update(self.ICONS['000'])
          return

        weather = await response.json()
        icon = weather['weather'][0]['icon']
        temp = weather['main']['temp']

    await self._to_cache(icon, temp)
    self.set_weather(icon, temp)

  def set_weather(self, icon: str, temp: float) -> None:
    icon = self.ICONS.get(icon, self.ICONS['000'])
    unit = Units[self.units]

    if unit is not Units.K:
      temp -= 273.15
      if unit is Units.F:
        temp /= 1.8
    temp = round(temp)

    self.update(self.format.format(icon=icon, temp=temp, unit=unit.name))

  async def _from_cache(self) -> Optional[Tuple[str, float]]:
    cache = Path(self.DIR.user_cache_dir) / 'weather.json'

    with suppress(IOError):
      cst = await aos.stat(cache)
      now = datetime.now()

      if now.timestamp() - cst.st_mtime < 1800:
        with suppress(OSError, json.JSONDecodeError):
          async with aif.open(cache, 'r') as f:
            text = await f.read()
            data = json.loads(text)

          return data['icon'], data['temp']

  async def _to_cache(self, icon: str, temp: float) -> None:
    cache = Path(self.DIR.user_cache_dir) / 'weather.json'

    with suppress(OSError):
      await aos.mkdir(cache.parent)

    async with aif.open(cache, 'w') as f:
      text = json.dumps(dict(icon=icon, temp=temp))
      await f.write(text)
