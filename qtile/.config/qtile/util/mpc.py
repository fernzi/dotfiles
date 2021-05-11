# Fern Zapata
# https://github.com/fernzi/dotfiles
# Qtile Window Manager - MPD control

import os
from mpd import MPDClient
import settings


try:
  _host = settings.mpd['host']
except (AttributeError, KeyError):
  _host = os.getenv('MPD_HOST', 'localhost')
try:
  _port = settings.mpd['port']
except (AttributeError, KeyError):
  _port = os.getenv('MPD_PORT', 6600)

_client = MPDClient()
_client.timeout = 5


def play(*_) -> None:
  try:
    _client.connect(_host, _port)
    _client.pause()
    _client.close()
    _client.disconnect()
  except ConnectionError:
    pass


def stop(*_) -> None:
  try:
    _client.connect(_host, _port)
    _client.stop()
    _client.close()
    _client.disconnect()
  except ConnectionError:
    pass


def next(*_) -> None:
  try:
    _client.connect(_host, _port)
    _client.next()
    _client.close()
    _client.disconnect()
  except ConnectionError:
    pass


def prev(*_) -> None:
  try:
    _client.connect(_host, _port)
    _client.previous()
    _client.close()
    _client.disconnect()
  except ConnectionError:
    pass
