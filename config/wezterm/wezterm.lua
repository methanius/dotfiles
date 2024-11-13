-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
--
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Font choice, I like liagutures and fun fonts for italics
config.font = wezterm.font({
  family = "JetBrainsMono NF",
  harfbuzz_features = { "zero", "ss02", "ss19", "cv03" },
  weight="Light"
})

config.font_rules = {
  {
    intensity = "Bold",
    italic = true,
    font = wezterm.font({
      family = "VictorMono NF",
      weight = "Bold",
      style = "Italic",
    }),
  },
  {
    italic = true,
    intensity = "Half",
    font = wezterm.font({
      family = "VictorMono NF",
      weight = "DemiBold",
      style = "Italic",
    }),
  },
  {
    italic = true,
    intensity = "Normal",
    font = wezterm.font({
      family = "VictorMono NF",
      style = "Italic",
    }),
  },
}


-- Appearance
config.adjust_window_size_when_changing_font_size = false
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
-- config.window_padding
config.font_size = 15
-- config.line_height = 1.10 // Buggy on ubuntu 24.04 apparently? Booh.
config.show_tab_index_in_tab_bar = true

-- remove titlebar and other annoyances from window
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_frame = {
  font = wezterm.font("VictorMono NF", { weight = "Regular", italic = true }),
}

-- Turn off the annoying bell!!!
config.audible_bell = "Disabled"

-- Configs for Windows pc only
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  -- Choosing color_scheme
  config.color_scheme = "zenbones_dark"

  config.default_domain = "WSL:Ubuntu"
  -- Reload configuration every 30 minutes

  config.background = {
    {
      source = {
        File = "C:\\Users\\cnm\\AppData\\Roaming\\Microsoft\\Windows\\Themes\\TranscodedWallpaper",
      },
      hsb = { brightness = 0.05 },
      horizontal_align = "Center",
      vertical_align = "Middle",
      repeat_x = "NoRepeat",
      repeat_y = "NoRepeat",
      -- height = 1600,
      -- width = 2560,
    },
  }

  -- Track when wallpaper changes
  wezterm.add_to_config_reload_watch_list(
    "C:\\Users\\cnm\\AppData\\Roaming\\Microsoft\\Windows\\Themes\\TranscodedWallpaper"
  )
end

-- Configs for linux only
if wezterm.target_triple == "x86_64-unknown-linux-gnu" then
  config.default_cwd = wezterm.home_dir

  -- Appearance background
  config.window_background_opacity = 0.9

  -- WebGpu was painfully slow on my linux box for whatever reason!
  config.front_end = "OpenGL"
  config.enable_wayland = false
  local theme = require("kanagawa")
  config.colors = theme.colors
  config.force_reverse_video_cursor = false
  config.colors.tab_bar = {
    background = "rgba(0,0,0,0)",
    active_tab = {
      bg_color = "rgba(0,0,0,0)",
      fg_color = "#c0c0c0",
      italic = true,
      intensity = "Bold",
      underline = "Single",
    },
    inactive_tab = {
      fg_color = "#c0c0c0",
      bg_color = "rgba(0,0,0,0)",
      italic = true,
      intensity = "Half",
    },
    new_tab = {
      bg_color = "rgba(0,0,0,0)",
      fg_color = "#c0c0c0",
    },
  }
end

-- and finally, return the configuration to wezterm
return config
