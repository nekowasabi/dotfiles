local wezterm = require("wezterm")
-- local environment = require('environment')

local solarized = wezterm.get_builtin_color_schemes()["Solarized Dark - Patched"]
solarized.cursor_bg = "red"

local all_characters = [[`1234567890-=qwertyuiop[]\asdfghjkl;'zxcvbnm,./]]
local characters = {}

for i = 1, #all_characters do
  table.insert(characters, all_characters:sub(i, i))
end

local function mappings(maps)
  local result = {}
  local seen = {}
  local mod_key

  -- Check if running on macOS using os.getenv
  if os.getenv('HOME'):match('^/Users/') then
    mod_key = 'CMD'
  else
    mod_key = 'ALT'
  end

  for _, mapping in ipairs(maps) do
    mapping.mods = mapping.mods and mapping.mods:gsub('MOD', mod_key)
    table.insert(result, mapping)

    seen[mapping.mods .. " " .. mapping.key:lower()] = true
  end

  if mod_key == 'CMD' then
    for _, key in ipairs(characters) do
      for _, mods in ipairs({ 'CMD', 'CMD|SHIFT' }) do
        local combo = mods .. ' ' .. key

        if not seen[combo] then
          seen[combo] = true

          table.insert(result, {
            key = key,
            mods = mods,
            action = wezterm.action.SendKey { key = key, mods = mods:gsub('CMD', 'ALT') },
          })
        end
      end
    end
  end

  return result
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
  keys = mappings({
    { key = 'v', mods = 'MOD', action=wezterm.action{PasteFrom="Clipboard"}},
  }),
}


-- --- in your wezterm keys config, use it like:
-- keys = {
--    bind_super_key_to_vim('s'),
--   --- others....
-- }
