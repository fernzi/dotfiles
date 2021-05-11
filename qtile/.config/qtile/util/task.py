# Fern Zapata
# https://github.com/fernzi/dotfiles
# Qtile Window Manager - Function utilities

import asyncio as aio

from libqtile.lazy import lazy


def _easy_add_task(_, coro, *args, **kwargs) -> None:
  aio.create_task(coro(*args, **kwargs))


def easy_async(coro, *args, **kwargs):
  return lazy.function(_easy_add_task, coro, *args, **kwargs)


def _lazy_add_task(context, coro, *args, **kwargs):
  aio.create_task(coro(context, *args, **kwargs))


def lazy_async(context, coro, *args, **kwargs):
  return context.function(_lazy_add_task, coro, *args, **kwargs)
