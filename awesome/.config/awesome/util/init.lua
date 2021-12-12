-----------------------------------------------------------------------
-- Fern's Dotfiles
-- https://gitlab.com/fernzi/dotfiles
-- Awesome Window Manager - Utilities
-----------------------------------------------------------------------

local gears = require('gears')
local awful = require('awful')
local beautiful = require('beautiful')
local naughty = require('naughty')

local dpi = beautiful.xresources.apply_dpi

local util = {}

-----------------------------------------------------------------------

local _in_error = false

function util.display_error(error)
  if _in_error then return end
  _in_error = true
  naughty.notify{
    preset = naughty.config.presets.critical,
    title = 'Runtime error!',
    text = tostring(error),
  }
  _in_error = false
end

function util.theme(t)
  local d = gears.filesystem.get_configuration_dir() .. 'themes/' .. t .. '/theme.lua'
  if gears.filesystem.file_readable(d) then
    return d
  else
    return gears.filesystem.get_themes_dir() .. t .. '/theme.lua'
  end
end

function util.set_wallpaper(scn, wallpaper)
  wallpaper = wallpaper or beautiful.wallpaper
  if wallpaper then
    if type(wallpaper) == 'function' then
      wallpaper = wallpaper()
    end
    gears.wallpaper.maximized(wallpaper, scn, true)
  end
end

function util.mpc(action)
  awful.spawn({'mpc', action})
end

-----------------------------------------------------------------------

return util
