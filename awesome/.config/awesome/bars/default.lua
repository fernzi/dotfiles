-----------------------------------------------------------------------
-- Fern Zapata
-- https://github.com/ferzapata/dotfiles
-- Awesome Window Manager - Default Bar
-----------------------------------------------------------------------

local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')

-- Buttons ------------------------------------------------------------

local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t)
    t:view_only()
  end),
  awful.button({}, 4, function(t)
    awful.tag.viewprev(t.screen)
  end),
  awful.button({}, 5, function(t)
    awful.tag.viewnext(t.screen)
  end)
)

local layout_buttons = gears.table.join(
  awful.button({}, 1, function()
    awful.layout.inc(1)
  end),
  awful.button({}, 4, function()
    awful.layout.inc(1)
  end),
  awful.button({}, 5, function()
    awful.layout.inc(-1)
  end)
)

-- Setup --------------------------------------------------------------

local function taglist_filter(tl)
end

return function(s)
  s.panel = awful.wibar {
    screen = s,
    position = 'top',
  }

  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(layout_buttons)

  s.panel.mytaglist = awful.widget.taglist {
    screen = s,
    filter = awful.widget.taglist.filter.all,
    buttons = taglist_buttons
  }

  s.panel:setup {
    {
      {
        widget = wibox.widget.textclock,
        format = '%a %b %d  %R',
        align = 'center',
      },
      layout = wibox.layout.flex.horizontal,
    },
    {
      { -- Left widgets
        s.mylayoutbox,
        s.panel.mytaglist,
        layout = wibox.layout.fixed.horizontal,
      },
      nil,
      { -- Right widgets
        wibox.widget.systray(),
        layout = wibox.layout.fixed.horizontal,
      },
      layout = wibox.layout.align.horizontal,
    },
    layout = wibox.layout.stack,
  }
end
