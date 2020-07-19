-----------------------------------------------------------------------
-- Fern Zapata
-- https://github.com/ferzapata/dotfiles
-- Awesome Window Manager - Audio Utilities
-----------------------------------------------------------------------

local fs = require 'gears.filesystem'
local lgi = require 'lgi'
local gsound = lgi.GSound

local audio = {}

-----------------------------------------------------------------------

local context = gsound.Context()

context:init()

function audio.play(name)
  local mode = fs.file_readable(name) and gsound.ATTR_MEDIA_FILENAME
                                       or gsound.ATTR_EVENT_ID
  return context:play_simple{[mode]=name}
end

local _volume_notification = {}

function audio.set_volume(delta)
  delta = delta or 0
  local command = {
    'pulsemixer',
    '--toggle-mute',
    '--get-volume',
    '--get-mute',
  }
  if delta ~= 0 then
    command = {
      'pulsemixer',
      '--change-volume', ('%+d'):format(delta),
      '--unmute',
      '--get-volume',
      '--get-mute',
    }
  end
  awful.spawn.easy_async(command, function(stdo)
    local level, muted = stdo:match('(%d+).*[\r\n]+(%d)')
    level = tonumber(level)
    local message = 'Muted'
    local icon = 'audio-volume-muted'
    if muted == '0' then
      message = ('%d%%'):format(level)
      if level < 35 then
        icon = 'audio-volume-low'
      elseif level < 70 then
        icon = 'audio-volume-medium'
      else
        icon = 'audio-volume-high'
      end
    end
    _volume_notification = naughty.notify {
      title = 'Volume',
      text = message,
      icon = 'audio-volume-muted',
      replaces_id = _volume_notification.id,
    }
  end)
end

-----------------------------------------------------------------------

return audio
