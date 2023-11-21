local wezterm = require("wezterm")

local solarized = wezterm.get_builtin_color_schemes()["Solarized Dark - Patched"]
solarized.cursor_bg = "red"

window_decorations = "NONE

return {
-- wsl_domains = wsl_domains,
  default_cwd = "/Users/ttakeda",
  -- default_prog = {"wsl.exe", "--distribution", "Ubuntu", "--exec", "/home/linuxbrew/.linuxbrew/bin/zsh", "-l"},
  font = wezterm.font("RuikaMono", { weight = 7, style = 'Normal',  italic = false }),
  font_size = 18,
  color_schemes = {
    -- Override the builtin Gruvbox Light scheme with our modification.
    ["Solarized Dark - Patched"] = solarized,
  },
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  color_scheme = "Solarized Dark - Patched",
  use_ime = true,
  hide_tab_bar_if_only_one_tab = true,
  enable_tab_bar = true,
	disable_default_key_bindings = true,
  window_decorations = 'RESIZE',
  keys = {
    { key = 'v', mods = 'CMD',  action=wezterm.action{PasteFrom="Clipboard"}},
  },
}
