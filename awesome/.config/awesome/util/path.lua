-----------------------------------------------------------------------
-- Fern Zapata
-- https://github.com/fernzi/dotfiles
-- Awesome Window Manager - Path Utilities
-----------------------------------------------------------------------

local glib = require('lgi').GLib

local path = {}

-----------------------------------------------------------------------

local keys = {
  desktop   = glib.UserDirectory.DIRECTORY_DESKTOP,
  documents = glib.UserDirectory.DIRECTORY_DOCUMENTS,
  download  = glib.UserDirectory.DIRECTORY_DOWNLOAD,
  music     = glib.UserDirectory.DIRECTORY_MUSIC,
  pictures  = glib.UserDirectory.DIRECTORY_PICTURES,
  public    = glib.UserDirectory.DIRECTORY_PUBLIC_SHARE,
  templates = glib.UserDirectory.DIRECTORY_TEMPLATES,
  videos    = glib.UserDirectory.DIRECTORY_VIDEOS,
}

setmetatable(path, {
  __index = function(self, k)
    if keys[k] then
      return glib.get_user_special_dir(keys[k]) .. '/'
    else
      return self[k]
    end
  end,
})

-----------------------------------------------------------------------

return path
