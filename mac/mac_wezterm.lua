local wezterm = require("wezterm")
local act = wezterm.action

return {
  font = wezterm.font("RuikaMono07 Nerd Font"),
  font_size = 22,
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
  keys = {
    { key = 'v', mods = 'CMD',  action=wezterm.action{PasteFrom="Clipboard"}},
  },
}
