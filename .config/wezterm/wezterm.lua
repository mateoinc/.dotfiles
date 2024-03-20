-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = wezterm.config_builder()

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Frappe'

-- font
config.font = wezterm.font 'CommitMono'

-- Remove all padding
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

-- F11 to toggle fullscreen mode
config.keys = {
  { key = 'F11', action = wezterm.action.ToggleFullScreen },
}
-- Remove the title bar from the window
config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
-- Don't hide cursor when typing
config.hide_mouse_cursor_when_typing = false
-- Spawn a nu shell in login mode
config.default_prog = { '/etc/profiles/per-user/mbarria/bin/nu', '-l' }

-- and finally, return the configuration to wezterm
return config
