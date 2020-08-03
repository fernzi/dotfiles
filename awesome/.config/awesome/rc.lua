-----------------------------------------------------------------------
-- Fern Zapata
-- https://github.com/ferzapata/dotfiles
-- Awesome Window Manager
-----------------------------------------------------------------------

local gears = require('gears')
local awful = require('awful')
local beautiful = require('beautiful')
require('awful.autofocus')

local settings = require('settings')
local util = require('util')
local keys = require('keys')
local titlebar = require('decorations.default')
local setupbar = require('bars.default')

local dpi = beautiful.xresources.apply_dpi

awesome.connect_signal('debug::error', util.display_error)
beautiful.init(util.theme('gtk'))

-- Screens ------------------------------------------------------------

awful.layout.layouts = {
  awful.layout.suit.tile.left,
  awful.layout.suit.max,
}

awful.screen.connect_for_each_screen(function(scn)
  util.set_wallpaper(scn)

  scn.padding = {
    left = dpi(80),
    bottom = dpi(24),
    top = dpi(24),
    right = dpi(80),
  }

  awful.tag(settings.tags, scn, awful.layout.layouts[1])

  setupbar(scn)
end)

beautiful.useless_gap = 24

-- Rules --------------------------------------------------------------

root.keys(keys.global)

awful.rules.rules = {
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_color,
      focus = awful.client.focus.filter,
      raise = true,
      keys = keys.client_keys,
      buttons = keys.client_buttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap
                + awful.placement.no_offscreen,
    },
  },
  {
    rule_any = {
      type = {
        'normal',
        'dialog',
      },
    },
    properties = {
      titlebars_enabled = true,
    },
  },
  {
    rule = {
      class = 'Steam',
    },
    except = {
      name = 'Steam',
    },
    properties = {
      floating = true,
    },
  },
  {
    rule_any = {
      class = {
        'Steam',
      },
      name = {
        'Discord Updater',
      },
    },
    properties = {
      titlebars_enabled = false,
    },
  },
  {
    rule = {
      class = 'Dragdrop',
    },
    properties = {
      placement = function(c)
        awful.placement.centered(c, {parent=client.focus})
      end,
    },
  },
  {
    rule = {
      class = 'kruler',
    },
    properties = {
      floating = true,
      titlebars_enabled = false,
      border_width = 0,
      placement = awful.placement.under_mouse,
    },
  },
  {
    rule_any = {
      instance = {
        'pinentry',
      },
      class = {
        'mpv',
        'imv',
      },
      name = {
        'Event Tester',
      },
    },
    properties = {
      floating = true,
      placement = awful.placement.next_to_mouse,
    },
  },
}

-- Signals ------------------------------------------------------------

client.connect_signal('manage', function(c)
  if awesome.startup then
    if not (c.size_hints.user_position or
            c.size_hints.program_position) then
      awful.placement.no_offscreen(c)
    end
  else
    awful.client.setslave(c)
  end
end)

client.connect_signal('request::titlebars', titlebar)

client.connect_signal('mouse::enter', function(c)
  c:emit_signal('request::activate', 'mouse_enter', {raise=false})
end)

client.connect_signal('focus', function(c)
  c.border_color = beautiful.border_focus
end)

client.connect_signal('unfocus', function(c)
  c.border_color = beautiful.border_normal
end)

-- Autostart ----------------------------------------------------------

for i,v in ipairs(settings.autostart) do
  awful.spawn.once(v)
end
