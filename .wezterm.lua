-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Mocha"

-- Window tab bar config
config.window_frame = {
	-- The font used in the tab bar.
	-- Roboto Bold is the default; this font is bundled
	-- with wezterm.
	-- Whatever font is selected here, it will have the
	-- main font setting appended to it to pick up any
	-- fallback fonts you may have used there.
	font = wezterm.font({ family = "Iosevka Nerd Font", weight = "Bold" }),

	-- The size of the font in the tab bar.
	-- Default to 10.0 on Windows but 12.0 on other systems
	font_size = 10.0,

	-- The overall background color of the tab bar when
	-- the window is focused
	active_titlebar_bg = "none",

	-- The overall background color of the tab bar when
	-- the window is not focused
	inactive_titlebar_bg = "none",

	border_left_width = "1.0px",
	border_right_width = "1.0px",
	border_bottom_height = "1.0px",
	border_top_height = "1.0px",
	border_left_color = "purple",
	border_right_color = "purple",
	border_bottom_color = "purple",
	border_top_color = "purple",
}

config.colors = {
	tab_bar = {
		-- The color of the inactive tab bar edge/divider
		inactive_tab_edge = "#575757",
	},
}

config.font = wezterm.font("Iosevka Nerd Font")
config.font_size = 10.0
config.window_background_opacity = 0.5
config.use_fancy_tab_bar = false

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

local act = wezterm.action

config.keys = {
	-- Create a new tab in the same domain as the current pane.
	-- This is usually what you want.
	{
		key = "t",
		mods = "ALT",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	-- Create a new tab in the default domain
	-- { key = "t", mods = "SHIFT|ALT", action = act.SpawnTab("DefaultDomain") },
	-- Create a tab in a named domain
	-- {
	-- key = "t",
	-- mods = "SHIFT|ALT",
	-- action = act.SpawnTab({
	-- DomainName = "unix",
	-- }),
	-- },
	{
		key = "w",
		mods = "ALT",
		action = wezterm.action.CloseCurrentTab({ confirm = true }),
	},
}

-- and finally, return the configuration to wezterm
return config
