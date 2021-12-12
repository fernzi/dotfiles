-----------------------------------------------------------------------
-- Fern's Dotfiles
-- https://gitlab.com/fernzi/dotfiles
-- Awesome Window Manager - Default Titlebar
-----------------------------------------------------------------------

local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')

local dpi = beautiful.xresources.apply_dpi

local keys = require('keys')

-----------------------------------------------------------------------

return function(c)
  awful.titlebar(c, {
    size = dpi(32),
  }):setup {
    {
      {
        widget = wibox.container.margin,
        left = dpi(32 * 3 + 8),
        right = dpi(32 * 3 + 8),
        {
          widget = awful.titlebar.widget.titlewidget(c),
          font = beautiful.font_title,
          align = 'center',
        }
      },
      layout = wibox.layout.flex.horizontal,
    },
    {
      {
        widget = wibox.container.margin,
        left = dpi(4),
        right = dpi(4),
        {
          {
            awful.titlebar.widget.closebutton(c),
            awful.titlebar.widget.minimizebutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            layout = wibox.layout.fixed.horizontal,
          },
          {
            buttons = keys.title_buttons(c),
            layout = wibox.layout.fixed.horizontal,
          },
          {
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.stickybutton(c),
            layout = wibox.layout.fixed.horizontal,
          },
          layout = wibox.layout.align.horizontal,
        },
      },
      layout = wibox.layout.flex.horizontal,
    },
    layout = wibox.layout.stack,
  }
end
