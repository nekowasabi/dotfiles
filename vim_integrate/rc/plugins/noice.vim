lua << EOF
local function ignoreNotice(event, pattern, kind)
  kind = kind or ""
  return {
    filter = {
      event = event,
      kind = kind,
      find = pattern,
    },
    opts = { skip = true },
  }
end
local function ignoreMessage(pattern, kind)
  return ignoreNotice("msg_show", pattern, kind)
end
local function ignoreNotify(pattern, kind)
  return ignoreNotice("notify", pattern, kind)
end

require("noice").setup({
  presets = {
      bottom_search = false,         -- use a classic bottom cmdline for search
      command_palette = false,       -- position the cmdline and popupmenu together
      long_message_to_split = false, -- long messages will be sent to a split
      inc_rename = false,            -- enables an input dialog for inc-rename.nvim
  },
  commands = {
      all = {
        view = "split",
        opts = { enter = true, format = "details" },
        filter = {},
      },
  },
  notify = {
    enabled = true,
    view = "mini",
  },
  messages = {
    enabled = false,
    view = "mini",
    view_error = "mini",
    view_warn = "mini",
    view_history = "messages",
    view_search = false,
  },
  routes = {
    ignoreNotify("No information available"),
    ignoreMessage("書込み"),
    ignoreMessage("written"),
    ignoreMessage("search_count"),
    ignoreMessage("lines yanked"),
    ignoreMessage("fewer lines"),
    ignoreMessage("!rg --vimgrep --hidden"),
  },
})
EOF
