nnoremap <leader>cc :CodeCompanionActions<CR>
vnoremap <leader>cc :CodeCompanionChat 
nnoremap <Leader>ct :CodeCompanionChat Toggle<CR>
vnoremap <Leader>ci :CodeCompanion 
vnoremap ga :CodeCompanionChat Add<CR>

lua << EOF


require("codecompanion").setup({
  opts = {
    language = "Japanese",
  },
  display = {
    chat = {
      render_headers = true,
    },
  },
  diff = {
    enabled = true,
    close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
    layout = "vertical", -- vertical|horizontal split for default provider
    opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
    provider = "default", -- default|mini_diff
  },
  inline = {
    -- If the inline prompt creates a new buffer, how should we display this?
    layout = "vertical", -- vertical|horizontal|buffer
  },
  strategies = {
    chat = {
      adapter = "copilot",
      slash_commands = {
        ["file"] = {
          opts = {
            -- ref: https://github.com/olimorris/codecompanion.nvim/discussions/276
            provider = "telescope",
          },
        },
      },
      agent = {
        adapter = "copilot",
      },
    },
    inline = {
      adapter = "copilot",
    },
  },

  adapters = {
    copilot = function()
      return require("codecompanion.adapters").extend("copilot", {
        schema = {
          model = {
            default = "claude-3.5-sonnet",
          },
        },
      })
    end,
  },
})
EOF
