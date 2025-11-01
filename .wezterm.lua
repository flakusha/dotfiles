-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()
local fonts = {
	{ family = "Maple Mono NF CN", weight = "Light" },
	{ family = "Iosevka Nerd Font Propo" },
	{ family = "M+1Code Nerd Font" },
	{ family = "ShureTechMono Nerd Font Propo", weight = "Regular" },
}

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Mocha"

-- Select correct GPU
for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
	if gpu.backend == "Vulkan" and gpu.device_type == "IntegratedGpu" and gpu.driver == "radv" then
		config.webgpu_preferred_adapter = gpu
		config.front_end = "WebGpu"
		-- config.webgpu_force_fallback_adapter = true
		break
	end
end

-- Test out specific adapter from list
-- config.webgpu_preferred_adapter = wezterm.gui.enumerate_gpus()[2]
-- config.webgpu_force_fallback_adapter = true

-- Wayland setup
-- config.enable_wayland = false
if os.getenv("XDG_SESSION_TYPE") == "wayland" then
	-- not stable yet
	config.enable_wayland = true
else
	config.enable_wayland = false
end

-- Window tab bar config
config.window_frame = {
	-- The font used in the tab bar.
	-- Roboto Bold is the default; this font is bundled
	-- with wezterm.
	-- Whatever font is selected here, it will have the
	-- main font setting appended to it to pick up any
	-- fallback fonts you may have used there.
	font = wezterm.font_with_fallback(fonts),

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

config.font = wezterm.font_with_fallback(fonts)
config.font_size = 10.0
config.window_background_opacity = 1.0
-- config.animation_fps = 144
-- config.front_end = "WebGpu"
-- config.webgpu_power_preference = "HighPerformance"
config.line_height = 0.9
config.treat_east_asian_ambiguous_width_as_wide = false
config.freetype_load_target = "Light"

config.use_fancy_tab_bar = false
config.enable_scroll_bar = true

-- In case of tiling, this option is better left off
-- depends on tiling_desktop_environments list
-- config.adjust_window_size_when_changing_font_size = false

config.tiling_desktop_environments = {
	"X11 LG3D",
	"X11 bspwm",
	"X11 i3",
	"X11 dwm",
	"X11 awesome",
	"X11 Hyprland :D",
	"Wayland",
}

config.use_ime = true

-- Pass environment variables to programs
config.set_environment_variables = {
	LANG = "en_IE.UTF8",
	LC_CTYPE = "en_IE.UTF8",
}

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

local act = wezterm.action

-- Add actions
wezterm.on("toggle-opacity", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if overrides.window_background_opacity == 1.0 then
		overrides.window_background_opacity = 0.5
	else
		overrides.window_background_opacity = 1.0
	end
	window:set_config_overrides(overrides)
end)

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
		key = "r",
		mods = "ALT",
		action = act.SplitPane({ direction = "Right" }),
	},
	{
		key = "d",
		mods = "ALT",
		action = act.SplitPane({ direction = "Down" }),
	},
	-- Show the selector, using the quick_select_alphabet
	{ key = "v", mods = "ALT", action = wezterm.action({ PaneSelect = {} }) },
	-- Show the selector, using your own alphabet
	{ key = "b", mods = "ALT", action = wezterm.action({ PaneSelect = { alphabet = "0123456789" } }) },
	{
		key = "w",
		mods = "ALT",
		action = wezterm.action.CloseCurrentTab({ confirm = true }),
	},
	{
		key = "q",
		mods = "ALT",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "B",
		mods = "CTRL",
		action = wezterm.action.EmitEvent("toggle-opacity"),
	},
}

-- No need to check for updates, as they are managed by Distro / pulled from Git
config.check_for_updates = false
-- config.check_for_updates_interval_seconds = 86400

-- Return the configuration to wezterm
return config
