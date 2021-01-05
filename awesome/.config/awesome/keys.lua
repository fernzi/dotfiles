-----------------------------------------------------------------------
-- Fern Zapata
-- https://github.com/fernzi/dotfiles
-- Awesome Window Manager - Key Bindings
-----------------------------------------------------------------------

local gears = require('gears')
local awful = require('awful')
local beautiful = require('beautiful')

local settings = require('settings')
local util = require('util')
util.audio = require('util.audio')
util.screenshot = require('util.screenshot')

local keys = {}

-- Keys ---------------------------------------------------------------

local mod = {
  m = 'Mod4',
  a = 'Mod1',
  s = 'Shift',
  c = 'Control',
}

keys.global = gears.table.join(

  -- Applications --

  awful.key({mod.m}, 'Return', function()
    awful.spawn(settings.terminal)
  end),
  awful.key({mod.m, mod.s}, 'Return', function()
    awful.spawn(settings.file_manager, {
      floating = true,
    })
  end),
  awful.key({mod.m}, 'space', function()
    awful.spawn(settings.launcher)
  end),
  awful.key({mod.m}, 'grave', function()
    awful.spawn(settings.window_switcher)
  end),
  awful.key({mod.m}, '/', function()
    awful.spawn(settings.file_manager)
  end),

  awful.key({}, 'Print', util.screenshot.full),
  awful.key({mod.a}, 'Print', util.screenshot.window),
  awful.key({mod.s}, 'Print', util.screenshot.area),
  awful.key({mod.m}, 'Print', util.screenshot.record),

  -- Clients --

  awful.key({mod.m}, 'Left', function()
    if awful.layout.get() == awful.layout.suit.max then
      awful.client.focus.byidx(-1)
    else
      awful.client.focus.bydirection('left')
    end
    if client.focus then
      client.focus:raise()
    end
  end),
  awful.key({mod.m}, 'Down', function()
    awful.client.focus.bydirection('down')
    if client.focus then
      client.focus:raise()
    end
  end),
  awful.key({mod.m}, 'Up', function()
    awful.client.focus.bydirection('up')
    if client.focus then
      client.focus:raise()
    end
  end),
  awful.key({mod.m}, 'Right', function()
    if awful.layout.get() == awful.layout.suit.max then
      awful.client.focus.byidx(-1)
    else
      awful.client.focus.bydirection('right')
    end
    if client.focus then
      client.focus:raise()
    end
  end),

  awful.key({mod.m, mod.s}, 'Left', function()
    awful.client.swap.bydirection('left')
  end),
  awful.key({mod.m, mod.s}, 'Down', function()
    awful.client.swap.bydirection('down')
  end),
  awful.key({mod.m, mod.s}, 'Up', function()
    awful.client.swap.bydirection('up')
  end),
  awful.key({mod.m, mod.s}, 'Right', function()
    awful.client.swap.bydirection('right')
  end),

  -- Screen --

  awful.key({mod.m, mod.c}, 'Right', awful.tag.viewnext),
  awful.key({mod.m, mod.c}, 'Left', awful.tag.viewprev),

  awful.key({mod.m}, 'Tab', function()
    awful.layout.inc(1)
  end),
  awful.key({mod.m, mod.s}, 'space', function()
    if awful.layout.get() == awful.layout.suit.tile.right then
      awful.layout.set(awful.layout.suit.tile.left)
    elseif awful.layout.get() == awful.layout.suit.tile.left then
      awful.layout.set(awful.layout.suit.tile.right)
    end
  end),

  awful.key({mod.m}, 'backslash', function()
    local tag = awful.screen.focused().selected_tag
    tag.gap, tag.old_gap = tag.old_gap or 0, tag.gap
  end),

  -- Media --

  awful.key({}, 'XF86AudioMute', function()
    util.audio.set_volume(0)
  end),
  awful.key({}, 'XF86AudioLowerVolume', function()
    util.audio.set_volume(-5)
  end),
  awful.key({}, 'XF86AudioRaiseVolume', function()
    util.audio.set_volume(5)
  end),

  awful.key({}, 'XF86AudioPlay', function()
    util.mpc('toggle')
  end),
  awful.key({}, 'XF86AudioStop', function()
    util.mpc('stop')
  end),
  awful.key({}, 'XF86AudioPrev', function()
    util.mpc('prev')
  end),
  awful.key({}, 'XF86AudioNext', function()
    util.mpc('next')
  end),

  -- Awesome --

  awful.key({mod.m, mod.c}, 'Delete', awesome.restart),
  awful.key({mod.m, mod.c}, 'BackSpace', awesome.quit)
)

for i, _ in ipairs(settings.tags) do
  keys.global = gears.table.join(keys.global,
    awful.key({mod.m}, '#' .. i + 9, function()
      local scn = awful.screen.focused()
      local tag = scn.tags[i]
      if tag then
        if tag == scn.selected_tag then
          awful.tag.history.restore()
        else
          tag:view_only()
        end
      end
    end),
    awful.key({mod.m, mod.s}, '#' .. i + 9, function(c)
      if not client.focus then return end
      local tag = client.focus.screen.tags[i]
      if tag then
        client.focus:move_to_tag(tag)
      end
    end)
  )
end

keys.client_keys = gears.table.join(
  awful.key({mod.m}, ',', awful.placement.centered),
  awful.key({mod.m}, '.', awful.placement.under_mouse),

  awful.key({mod.m}, 'f', function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end),
  awful.key({mod.m, mod.s}, 'f', function(c)
    c.floating = not c.floating
  end),

  awful.key({mod.m}, 'w', function(c)
    c:kill()
  end)
)

-- Mouse --------------------------------------------------------------

keys.client_buttons = gears.table.join(
  awful.button({}, 1, function(c)
    c:emit_signal('request::activate', 'mouse_click', {raise=true})
  end),
  awful.button({mod.m}, 1, function(c)
    c:emit_signal('request::activate', 'mouse_click', {raise=true})
    awful.mouse.client.move(c)
  end),
  awful.button({mod.m}, 3, function(c)
    c:emit_signal('request::activate', 'mouse_click', {raise=true})
    awful.mouse.client.resize(c)
  end)
)

function keys.title_buttons(c)
  return gears.table.join(
    awful.button({}, 1, function()
      c:emit_signal('request::activate', 'titlebar', {raise=true})
      awful.mouse.client.move(c)
    end),
    awful.button({}, 3, function()
      c:emit_signal('request::activate', 'titlebar', {raise=true})
      awful.mouse.client.resize(c)
    end)
  )
end

-----------------------------------------------------------------------

return keys
