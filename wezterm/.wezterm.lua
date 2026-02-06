-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- Build configuration builder
local config = wezterm.config_builder()

-- Terminal shit
config.initial_cols = 120
config.initial_rows = 28
config.font_size = 14
config.color_scheme = "Monokai Pro (Gogh)"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.window_background_opacity = 0.95

-- Cursor
config.default_cursor_style = "BlinkingUnderline"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- Shortcuts
config.keys = {
	-- Split create panes
	{ key = "h", mods = "CTRL|SHIFT", action = act.SplitPane({ direction = "Left", size = { Percent = 50 } }) },
	{ key = "l", mods = "CTRL|SHIFT", action = act.SplitPane({ direction = "Right", size = { Percent = 50 } }) },
	{ key = "k", mods = "CTRL|SHIFT", action = act.SplitPane({ direction = "Up", size = { Percent = 50 } }) },
	{ key = "j", mods = "CTRL|SHIFT", action = act.SplitPane({ direction = "Down", size = { Percent = 50 } }) },

	-- Delete split panes (or the window)
	{ key = "w", mods = "CTRL|SHIFT", action = act.CloseCurrentPane({ confirm = true }) },

	-- Change focus
	{ key = "h", mods = "ALT", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "ALT", action = act.ActivatePaneDirection("Right") },
	{ key = "k", mods = "ALT", action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = "ALT", action = act.ActivatePaneDirection("Down") },

	-- Move tabs around
	{ key = "{", mods = "SHIFT|ALT", action = act.MoveTabRelative(-1) },
	{ key = "}", mods = "SHIFT|ALT", action = act.MoveTabRelative(1) },
}

-- Finally, return the configuration to wezterm:
return config
