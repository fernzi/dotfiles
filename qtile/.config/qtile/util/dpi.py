# Fern Zapata
# https://github.com/fernzi/dotfiles
# Qtile Window Manager - HiDPI support hack

import xcffib
import xcffib.xproto
import xcffib.randr


class DPIManager:
  def __init__(self) -> None:
    self._dpi = self._find_dpi()
    self._scale = round(self._dpi / 96)

  def __call__(self, val: int) -> int:
    return val * self._scale

  def _find_dpi(self) -> float:
    x = xcffib.connect()
    x.randr = x(xcffib.randr.key)
    res = x.randr.GetScreenResources(x.setup.roots[0].root).reply()
    dpi = 96
    px = dict(w=0, h=0)
    mm = dict(w=0, h=0)
    for crtc in res.crtcs:
      info = x.randr.GetCrtcInfo(crtc, xcffib.CurrentTime).reply()
      px['w'] += info.width
      px['h'] += info.height
    for out in res.outputs:
      info = x.randr.GetOutputInfo(out, xcffib.CurrentTime).reply()
      mm['w'] += info.mm_width
      mm['h'] += info.mm_height
    if mm['w'] > 0:
      w_dpi = px['w'] * 25.4 / mm['w']
      h_dpi = px['h'] * 25.4 / mm['h']
      dpi = (w_dpi + h_dpi) / 2
    return dpi


dpi = DPIManager()
