-----------------------------------------------------------------------
-- Fern's Dotfiles -- Wezterm Terminal Emulator
-- https://github.com/fernzi/dotfiles
-----------------------------------------------------------------------

local wezterm = require 'wezterm'
local config = {}

-- Dislike Wezterm launching login shells every time.
-- Don't really use the GNU Screen-like functionality,
-- so doubt changing it will a problem.
config.default_prog = { os.getenv('SHELL') }

-- Appearance ---------------------------------------------------------

-- Sweet sweet integrated title bar.
-- Only issue is that it doesn't have any way to
-- style the buttons other than a couple presets.
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.integrated_title_button_alignment = 'Left'
config.integrated_title_buttons = { 'Close' }

-- Setting the font as `system-ui` wont't do,
-- so guess Wezterm doesn't use FontConfig?
config.window_frame = {
	font = wezterm.font {
		family = 'Fira Sans Condensed',
		weight = 'Bold',
	},
	font_size = 12,
}

-- Using `monospace` does work though, for some reason.
config.font = wezterm.font_with_fallback {
	'monospace',
	'Material Design Icons',
	'Noto Color Emoji',
}
config.font_size = 12

config.default_cursor_style = 'SteadyUnderline'

config.show_tab_index_in_tab_bar = false

local padding = 24
config.window_padding = {
	left   = padding,
	right  = padding,
	top    = padding,
	bottom = padding,
}

-- Colours ------------------------------------------------------------

config.window_frame.active_titlebar_bg = '#202020'
config.window_frame.inactive_titlebar_bg = '#202020'

config.color_scheme = 'Feri Dark'
config.bold_brightens_ansi_colors = false

config.colors = {
	tab_bar = {
		background = '#202020',
		inactive_tab_edge = '#202020',
		active_tab = {
			bg_color = '#181818',
			fg_color = '#D4D4D4',
		},
		inactive_tab = {
			bg_color = '#202020',
			fg_color = '#525252',
		},
		inactive_tab_hover = {
			bg_color = '#2A2A2A',
			fg_color = '#D4D4D4',
		},
		new_tab = {
			bg_color = '#202020',
			fg_color = '#525252',
		},
		new_tab_hover = {
			bg_color = '#2A2A2A',
			fg_color = '#D4D4D4',
		},
	},
}

-- Dim the active tab label to match my WM.
-- Don't really have any other way to tell
-- the window is unfocused otherwise.
local function dim_active_label(win, pane)
	local overrides = win:get_config_overrides() or {}
	overrides.colors = config.colors
	overrides.colors.tab_bar.active_tab.fg_color =
		win:is_focused() and '#D4D4D4' or '#525252'
	win:set_config_overrides(overrides)
end

wezterm.on('window-focus-changed', dim_active_label)

return config
