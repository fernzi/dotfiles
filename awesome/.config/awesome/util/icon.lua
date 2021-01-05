-----------------------------------------------------------------------
-- Fern Zapata
-- https://github.com/fernzi/dotfiles
-- Awesome Window Manager - Icon finder
-----------------------------------------------------------------------

local lgi = require('lgi')
Gio, Gtk = lgi.Gio, lgi.Gtk


local THEME = Gtk.IconTheme.get_default()


local icon = {}

function icon.get(name, size)
  local icon = Gio.ThemedIcon.new_with_default_fallbacks(name)
  local info = THEME:choose_icon(icon:get_names(), size or 32, 0)
  return info:get_filename()
end


return setmetatable(icon, {
  __call = function(self, ...)
    return self.get(...)
  end
})
