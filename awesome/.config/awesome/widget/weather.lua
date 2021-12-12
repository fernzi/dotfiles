-----------------------------------------------------------------------
-- Fern's Dotfiles
-- https://gitlab.com/fernzi/dotfiles
-- Awesome Window Manager - Weather Widget
-----------------------------------------------------------------------

local wibox = require('wibox')
local gears = require('gears')
local naughty = require('naughty')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi

local lgi = require('lgi')
local GLib, Soup, Json = lgi.GLib, lgi.Soup, lgi.Json

local icon = require('util.icon')


local URL = 'https://wttr.in/%s?format=j1'
local ICONS = setmetatable({
    ['113'] = 'clear',
    ['116'] = 'few-clouds',
    ['119'] = 'overcast',
    ['122'] = 'overcast',
    ['143'] = 'fog',
    ['176'] = 'showers-scattered',
    ['179'] = 'showers',
    ['182'] = 'showers',
    ['185'] = 'showers',
    ['200'] = 'storm',
    ['227'] = 'snow',
    ['230'] = 'snow',
    ['248'] = 'fog',
    ['260'] = 'fog',
    ['263'] = 'showers-scattered',
    ['266'] = 'showers-scattered',
    ['281'] = 'showers-scattered',
    ['284'] = 'showers-scattered',
    ['293'] = 'showers-scattered',
    ['296'] = 'showers-scattered',
    ['299'] = 'showers',
    ['302'] = 'showers',
    ['305'] = 'showers',
    ['308'] = 'showers',
    ['311'] = 'showers-scattered',
    ['314'] = 'showers-scattered',
    ['317'] = 'showers-scattered',
    ['320'] = 'snow',
    ['323'] = 'snow',
    ['326'] = 'snow',
    ['329'] = 'snow',
    ['332'] = 'snow',
    ['335'] = 'snow',
    ['338'] = 'snow',
    ['350'] = 'showers-scattered',
    ['353'] = 'showers-scattered',
    ['356'] = 'showers',
    ['359'] = 'showers',
    ['362'] = 'showers-scattered',
    ['365'] = 'showers-scattered',
    ['368'] = 'snow',
    ['371'] = 'snow',
    ['374'] = 'showers-scattered',
    ['377'] = 'showers-scattered',
    ['386'] = 'storm',
    ['389'] = 'storm',
    ['392'] = 'storm',
    ['395'] = 'storm',
}, {__index=function() return 'severe-alert' end})


local function icon_from_code(code)
  local i = icon(('weather-%s-symbolic'):format(ICONS[code]))
  return gears.color.recolor_image(i, beautiful.fg_focus)
end


local weather = {}

function weather:get_location()
  return self._private.location
end

function weather:set_location(location)
  self._private.location = location or self._private.location
  self:force_update()
end

function weather:get_refresh()
  return self._private.refresh
end

function weather:set_refresh(time)
  self._private.refresh = time or self._private.refresh
  self:force_update()
end

function weather:force_update()
  self._timer:emit_signal('timeout')
end

function weather:update()
  local stamp = GLib.DateTime.new_now_local()
  if self._private.stamp and stamp:difference(self._private.stamp) < 60000000 then
    return
  end
  self._private.stamp = stamp

  local source = URL:format(self._private.location)
  local message = Soup.Message.new('GET', source)

  self._private.session:send_async(message, nil, function(ss, rs)
    if message.status_code ~= 200 then
      return
    end

    local stream = ss:send_finish(rs)
    local response = Json.Parser.new()

    response:load_from_stream_async(stream, nil, function(rp, rs)
      if not rp:load_from_stream_finish(rs) then
        return
      end

      local curr = rp:get_root():get_object()
                     :get_array_member('current_condition')
                     :get_object_element(0)

      local code = curr:get_string_member('weatherCode')
      local temp = curr:get_string_member('temp_C')

      self._icon.image = icon_from_code(code)
      self._text.text = ('%s°C'):format(temp)
    end)
  end)
end

function weather.new(location, refresh)
  local icon = wibox.widget.imagebox(icon_from_code())
  local text = wibox.widget.textbox()

  icon.forced_height = dpi(16)
  text.font = beautiful.font_bar or text.font

  local this = wibox.widget {
    icon,
    text,
    spacing = dpi(8),
    layout = wibox.layout.fixed.horizontal,
  }
  gears.table.crush(this, weather, true)

  this._icon = icon
  this._text = text
  this._text.text = '...'

  this._private.location = location or ''
  this._private.refresh = refresh or 3600
  this._private.session = Soup.Session.new()

  function this._private.tick()
    this:update()
    this._timer.timeout = this._private.refresh
    this._timer:again()
    return true
  end

  this._timer = gears.timer.weak_start_new(refresh, this._private.tick)
  this:force_update()

  return this
end


return setmetatable(weather, {
  __call = function(self, ...)
    return self.new(...)
  end
})
