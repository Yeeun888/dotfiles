-- Pull in the wezterm API
local wezterm = require("wezterm")

-- Build configuration builder
local config = wezterm.config_builder()

config.initial_cols = 120
config.initial_rows = 28
config.font_size = 14
config.color_scheme = "Monokai Pro (Gogh)"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.window_background_opacity = 0.95

-- Finally, return the configuration to wezterm:
return config
