lua << EOF

require("notify").setup({
  stages = "static",
  timeout = 2500,
})

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
  lsp = {
    documentation = {
      view = "hover",
      opts = { -- lsp_docs settings
      lang = "markdown",
      replace = true,
      render = "plain",
      format = { "{message}" },
      position = { row = 2, col = 2 },
      size = {
        max_width = math.floor(0.8 * vim.api.nvim_win_get_width(0)),
        max_height = 15,
      },
      border = {
        style = "rounded",
      },
      win_options = {
        concealcursor = "n",
        conceallevel = 3,
        winhighlight = {
          Normal = "CmpPmenu",
          FloatBorder = "DiagnosticSignInfo",
        },
      },
      },
    },
  },
  -- lsp = {
  --   -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
  --   override = {
  --     ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
  --     ["vim.lsp.util.stylize_markdown"] = true,
  --     ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
  --   },
  -- },
  views = {
    cmdline_popup = {
      position = {
        row = 20,
        col = "50%",
      },
      size = {
        width = 100,
        height = "auto",
      },
    },
    popupmenu = {
      relative = "editor",
      position = {
        row = 8,
        col = "50%",
      },
      size = {
        width = 80,
        height = 10,
      },
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
      win_options = {
        winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
      },
    },
  },
  presets = {
      bottom_search = false,         -- use a classic bottom cmdline for search
      command_palette = true,        -- position the cmdline and popupmenu together
      long_message_to_split = false, -- long messages will be sent to a split
      inc_rename = false,            -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false,        -- add a border to hover docs and signature help
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
    view = "notify",
  },
  messages = {
    enabled = true,
    view = "notify",
    view_error = "notify",
    view_warn = "notify",
    view_history = "messages",
    -- view_search = "disable",
  },
  routes = {
    ignoreNotify("No information available"),
    ignoreMessage("書込み"),
    ignoreMessage("written"),
    ignoreMessage("search_count"),
    ignoreMessage("lines yanked"),
    ignoreMessage("fewer lines"),
    ignoreMessage("!rg --vimgrep --hidden"),
    {
      filter = {
        find = "Already",
      },
      opts = { skip = true },
    },
    {
        filter = {
        find = "cwd",
      },
      opts = { skip = true },
    },
  },
})
EOF
