-----------------------------------------------------------------------
-- Fern Zapata
-- https://github.com/ferzapata/dotfiles
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
  awful.titlebar(c):setup {
    {
      {
        widget = wibox.container.margin,
        right = dpi(64),
        left = dpi(64),
        {
          widget = awful.titlebar.widget.titlewidget(c),
          align = 'center',
        }
      },
      layout = wibox.layout.flex.horizontal,
    },
    {
      {
        awful.titlebar.widget.closebutton(c),
        awful.titlebar.widget.maximizedbutton(c),
        layout = wibox.layout.fixed.horizontal,
      },
      {
        buttons = keys.title_buttons(c),
        layout = wibox.layout.fixed.horizontal,
      },
      {
        awful.titlebar.widget.stickybutton(c),
        awful.titlebar.widget.floatingbutton(c),
        layout = wibox.layout.fixed.horizontal,
      },
      layout = wibox.layout.align.horizontal,
    },
    layout = wibox.layout.stack,
  }
end
