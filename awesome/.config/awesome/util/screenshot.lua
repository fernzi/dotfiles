-----------------------------------------------------------------------
-- Fern Zapata
-- https://github.com/fernzi/dotfiles
-- Awesome Window Manager - Screenshot/cast Utilities
-----------------------------------------------------------------------

local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local naughty = require('naughty')

local settings = require('settings')
local path = require('util.path')
local audio = require('util.audio')

local dpi = beautiful.xresources.apply_dpi

local screenshot = {}

-----------------------------------------------------------------------

local screenshot_path = settings.screenshot_path
                     or path.pictures .. 'Screenshots/'
local screencast_path = settings.screencast_path
                     or path.videos .. 'Screencasts/'

local function _run(command, file)
  gears.filesystem.make_parent_directories(file)
  return awful.spawn.easy_async(command, function()
    if not gears.filesystem.file_readable(file) then return end
    audio.play('screen-capture')
    naughty.notify {
      title = 'Screen captured!',
      text = file:gsub(os.getenv('HOME'), '~', 1),
      icon = file,
      icon_size = dpi(64),
      actions = {
        Open = function()
          awful.spawn{settings.file_manager, file}
        end
      }
    }
  end)
end

function screenshot.full()
  local file = screenshot_path .. os.date('%F_%T.png')
  local command = {'maim', file}
  _run(command, file)
end

function screenshot.window()
  if not client.focus then return end
  local file = screenshot_path .. os.date('%F_%T.png')
  local command = {'maim', '-i', tostring(client.focus.window), file}
  _run(command, file)
end

function screenshot.area()
  local file = screenshot_path .. os.date('%F_%T.png')
  local command = {'maim', '-s', file}
  _run(command, file)
end

local recording = 0

function screenshot.record()
  local file = screencast_path .. os.date('%F_%T.mp4')
  local scn = awful.screen.focused()
  local command = {
    'ffmpeg',
    '-vaapi_device', '/dev/dri/renderD128',
    '-f', 'x11grab',
    '-s', ('%dx%d'):format(scn.geometry.width, scn.geometry.height),
    '-r', '15',
    '-i', ('%s+%d,%d'):format(os.getenv('DISPLAY'), scn.geometry.x, scn.geometry.y),
    '-vf', 'hwupload,scale_vaapi=format=nv12',
    '-c:v', 'h264_vaapi',
    '-qp', '18',
    '-y',
    file,
  }
  if recording == 0 then
    recording = _run(command, file)
  elseif awesome.kill(recording, awesome.unix_signal.SIGTERM) then
    recording = 0
  end
end

-----------------------------------------------------------------------

setmetatable(screenshot, {
  __call = function(self, ...)
    return self.full(...)
  end,
})

return screenshot
