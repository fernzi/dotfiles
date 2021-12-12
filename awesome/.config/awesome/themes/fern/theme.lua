-----------------------------------------------------------------------
-- Fern's Dotfiles
-- https://gitlab.com/fernzi/dotfiles
-- Awesome Window Manager - Theme
-----------------------------------------------------------------------

local gs = require('gears')

local theme_assets = require('beautiful.theme_assets')
local dpi = require('beautiful.xresources').apply_dpi
local gfs = require('gears.filesystem')

local theme_dir = gfs.get_configuration_dir() .. 'themes/fern/'
local theme = dofile(gfs.get_themes_dir() .. 'default/theme.lua')

function theme:_add_title_icon(type, image, colors)
  for k,v in pairs(colors) do
    theme[('titlebar_%s_button_%s'):format(type, k)] = gs.color.recolor_image(image, v)
  end
end

local color = {
  base = {
    bg0    = '#202020',
    bg1    = '#303030',
    bg2    = '#404040',
    bg3    = '#525252',
    fg0    = '#C6C6C6',
    fg1    = '#D4D4D4',
    fg2    = '#E2E2E2',
    fg3    = '#F0F0F0',
  },
  normal = {
    red    = '#FFAED0',
    orange = '#FFB099',
    yellow = '#F6CE88',
    green  = '#B0E0AD',
    aqua   = '#94D1CE',
    blue   = '#9EDCFF',
    purple = '#D0BCFE',
    gray   = '#909090',
  },
  bright = {
    red    = '#FFCDE3',
    orange = '#FFD0BD',
    yellow = '#FFEEAC',
    green  = '#D3FAD3',
    aqua   = '#C1EAE1',
    blue   = '#CFF5FF',
    purple = '#E8DAFF',
    gray   = '#ABABAB',
  },
  dim = {
    red    = '#C7789A',
    orange = '#CD7A66',
    yellow = '#BC9855',
    green  = '#7BA979',
    aqua   = '#5E9A98',
    blue   = '#66A5C9',
    purple = '#9986C5',
    gray   = '#5E5E5E',
  },
}

local button = {
  close   = theme_dir .. 'titlebar/button.svg',
  min     = theme_dir .. 'titlebar/button.svg',
  max     = theme_dir .. 'titlebar/button.svg',
  maxa    = theme_dir .. 'titlebar/full.svg',
  float   = theme_dir .. 'titlebar/button.svg',
  floata  = theme_dir .. 'titlebar/full.svg',
  ontop   = theme_dir .. 'titlebar/button.svg',
  ontopa  = theme_dir .. 'titlebar/full.svg',
  sticky  = theme_dir .. 'titlebar/button.svg',
  stickya = theme_dir .. 'titlebar/full.svg',
}

-- Fonts --------------------------------------------------------------

theme.font       = 'Roboto Condensed, 11'
theme.font_title = 'Roboto Condensed, Bold 11'
theme.font_bar   = 'Roboto Condensed, Bold 11'

-- Colors -------------------------------------------------------------

theme.bg_normal   = color.base.bg0
theme.bg_focus    = theme.bg_normal
theme.bg_urgent   = theme.bg_normal
theme.bg_minimize = theme.bg_normal
theme.bg_systray  = theme.bg_normal

theme.fg_normal   = color.base.bg3
theme.fg_focus    = color.base.fg1
theme.fg_urgent   = theme.fg_focus
theme.fg_minimize = theme.fg_focus

-- Notifications ------------------------------------------------------

theme.notification_fg = color.base.fg1
theme.notification_margin = dpi(16)
theme.notification_icon_size = dpi(32)

-- Borders ------------------------------------------------------------

theme.useless_gap   = dpi(16)
theme.border_width  = dpi(1)
theme.border_normal = theme.bg_normal
theme.border_focus  = theme.bg_normal
theme.border_marked = theme.bg_normal

-- Menu ---------------------------------------------------------------

theme.menu_height = dpi(16)
theme.menu_width  = dpi(128)

-- Bar ----------------------------------------------------------------

theme.wibar_width  = dpi(1024)
theme.wibar_height = dpi(32)

-- Titlebar -----------------------------------------------------------

theme:_add_title_icon('close', theme_dir..'titlebar/button.svg', {
  normal = theme.fg_normal,
  normal_hover = color.bright.red,
  normal_press = color.dim.red,
  focus = color.normal.red,
  focus_hover = color.bright.red,
  focus_press = color.dim.red,
})

theme:_add_title_icon('minimize', theme_dir..'titlebar/button.svg', {
  normal = theme.fg_normal,
  normal_hover = color.bright.purple,
  normal_press = color.dim.purple,
  focus = color.normal.purple,
  focus_hover = color.bright.purple,
  focus_press = color.dim.purple,
})

theme:_add_title_icon('maximized', theme_dir..'titlebar/button.svg', {
  normal_inactive       = theme.fg_normal,
  normal_inactive_hover = color.bright.blue,
  normal_inactive_press = color.dim.blue,
  focus_inactive        = color.normal.blue,
  focus_inactive_hover  = color.bright.blue,
  focus_inactive_press  = color.dim.blue,
})

theme:_add_title_icon('maximized', theme_dir..'titlebar/full.svg', {
  normal_active         = theme.fg_normal,
  normal_active_hover   = color.bright.blue,
  normal_active_press   = color.dim.blue,
  focus_active          = color.normal.blue,
  focus_active_hover    = color.bright.blue,
  focus_active_press    = color.dim.blue,
})

theme:_add_title_icon('floating', theme_dir..'titlebar/button.svg', {
  normal_inactive       = theme.fg_normal,
  normal_inactive_hover = color.bright.aqua,
  normal_inactive_press = color.dim.aqua,
  focus_inactive        = color.normal.aqua,
  focus_inactive_hover  = color.bright.aqua,
  focus_inactive_press  = color.dim.aqua,
})

theme:_add_title_icon('floating', theme_dir..'titlebar/full.svg', {
  normal_active         = theme.fg_normal,
  normal_active_hover   = color.bright.aqua,
  normal_active_press   = color.dim.aqua,
  focus_active          = color.normal.aqua,
  focus_active_hover    = color.bright.aqua,
  focus_active_press    = color.dim.aqua,
})

theme:_add_title_icon('ontop', theme_dir..'titlebar/button.svg', {
  normal_inactive       = theme.fg_normal,
  normal_inactive_hover = color.bright.green,
  normal_inactive_press = color.dim.green,
  focus_inactive        = color.normal.green,
  focus_inactive_hover  = color.bright.green,
  focus_inactive_press  = color.dim.green,
})

theme:_add_title_icon('ontop', theme_dir..'titlebar/full.svg', {
  normal_active         = theme.fg_normal,
  normal_active_hover   = color.bright.green,
  normal_active_press   = color.dim.green,
  focus_active          = color.normal.green,
  focus_active_hover    = color.bright.green,
  focus_active_press    = color.dim.green,
})

theme:_add_title_icon('sticky', theme_dir..'titlebar/button.svg', {
  normal_inactive       = theme.fg_normal,
  normal_inactive_hover = color.bright.yellow,
  normal_inactive_press = color.dim.yellow,
  focus_inactive        = color.normal.yellow,
  focus_inactive_hover  = color.bright.yellow,
  focus_inactive_press  = color.dim.yellow,
})

theme:_add_title_icon('sticky', theme_dir..'titlebar/full.svg', {
  normal_active         = theme.fg_normal,
  normal_active_hover   = color.bright.yellow,
  normal_active_press   = color.dim.yellow,
  focus_active          = color.normal.yellow,
  focus_active_hover    = color.bright.yellow,
  focus_active_press    = color.dim.yellow,
})

-- theme.taglist_squares_sel         = gs.color.recolor_image(theme_dir..'titlebar/button.svg', '#FFA6C9')
-- theme.taglist_squares_unsel       = gs.color.recolor_image(theme_dir..'titlebar/button.svg', theme.fg_normal)
-- theme.taglist_squares_sel_empty   = gs.color.recolor_image(theme_dir..'titlebar/empty.svg', '#FFA6C9')
-- theme.taglist_squares_unsel_empty = gs.color.recolor_image(theme_dir..'titlebar/empty.svg', theme.fg_normal)
-- theme.taglist_squares_resize      = true

-- theme.awesome_icon = theme_assets.awesome_icon(
--   theme.menu_height, theme.bg_focus, theme.fg_focus
-- )

-- theme.icon_theme = nil

return theme
