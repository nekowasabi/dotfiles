local wezterm = require("wezterm")

local wsl_domains = wezterm.default_wsl_domains()

for idx, dom in ipairs(wsl_domains) do
  if dom.name == "WSL:Ubuntu" then
    dom.default_prog = {"zsh"}
  end
end

local solarized = wezterm.get_builtin_color_schemes()["Solarized Dark - Patched"]
solarized.cursor_bg = "red"

return {
  wsl_domains = wsl_domains,
  default_cwd = "/home/takets",
  default_prog = {"wsl.exe", "--distribution", "Ubuntu", "--exec", "/home/linuxbrew/.linuxbrew/bin/zsh", "-l"},
  font = wezterm.font("RuikaMono NF"),
  font_size = 16,
  color_schemes = {
    -- Override the builtin Gruvbox Light scheme with our modification.
    ["Solarized Dark - Patched"] = solarized,
  },
	color_scheme = "Solarized Dark - Patched",
  use_ime = true,
  hide_tab_bar_if_only_one_tab = true,
  enable_tab_bar = true,
	-- Overrides the cell background color when the current cell is occupied by the
	-- cursor and the cursor style is set to Block
	cursor_bg = "#52ad70",
	-- Overrides the text color when the current cell is occupied by the cursor
	cursor_fg = "yellow",
	-- Specifies the border color of the cursor when the cursor style is set to Block,
	-- or the color of the vertical or horizontal bar when the cursor style is set to
	-- Bar or Underline.
	cursor_border = "#52ad70",
}
