local wezterm = require("wezterm")

local solarized = wezterm.get_builtin_color_schemes()["Solarized Dark - Patched"]
solarized.cursor_bg = "red"

local function is_vim(pane)
	local is_vim_env = pane:get_user_vars().IS_NVIM == 'true'
	if is_vim_env == true then return true end
	-- This gsub is equivalent to POSIX basename(3)
	-- Given "/foo/bar" returns "bar"
	-- Given "c:\\foo\\bar" returns "bar"
	local process_name = string.gsub(pane:get_foreground_process_name(), '(.*[/\\])(.*)', '%2')
	return process_name == 'nvim' or process_name == 'vim'
end

--- cmd+keys that we want to send to neovim.
local super_vim_keys_map = {
  s = utf8.char(0xAA),
  x = utf8.char(0xAB),
  b = utf8.char(0xAC),
  ['.'] = utf8.char(0xAD),
  c = utf8.char(0xAE),
  d = utf8.char(0xAF),
  a = utf8.char(0xB0),
  g = utf8.char(0xB1),
}

local function bind_super_key_to_vim(key)
	return {
		key = key,
		mods = 'CMD',
		action = wezterm.action_callback(function(win, pane)
			local char = super_vim_keys_map[key]
			if char and is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = char, mods = nil },
				}, pane)
			else
				win:perform_action({
					SendKey = {
						key = key,
						mods = 'CMD'
					}
				}, pane)
			end
		end)
	}
end


return {
-- wsl_domains = wsl_domains,
  default_cwd = "/Users/ttakeda",
  font = wezterm.font("RuikaMono07 Nerd Font", { weight = 7, stretch="Normal", style = 'Normal',  italic = false }),
  font_size = 22,
  enable_csi_u_key_encoding = false,
  enable_kitty_keyboard = true,
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
    { key = 'v', mods = 'CMD', action=wezterm.action{PasteFrom="Clipboard"}},
    bind_super_key_to_vim('s'),
  },
}


-- --- in your wezterm keys config, use it like:
-- keys = {
--    bind_super_key_to_vim('s'),
--   --- others....
-- }
