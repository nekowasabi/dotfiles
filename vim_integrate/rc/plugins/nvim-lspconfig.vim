lua << EOF
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local nvim_lsp = require('lspconfig')

nvim_lsp.denols.setup({
  root_dir = nvim_lsp.util.root_pattern("deno.json"),
  init_options = {
    lint = true,
    unstable = true,
    suggest = {
      imports = {
        hosts = {
          ["https://deno.land"] = true,
          ["https://cdn.nest.land"] = true,
          ["https://crux.land"] = true,
        },
      },
    },
  },
  on_attach = function()
    local active_clients = vim.lsp.get_active_clients()
    for _, client in pairs(active_clients) do
      -- stop tsserver if denols is already active
      if client.name == "tsserver" then
        client.stop()
      end
    end
  end,
})

mason.setup()

require("lspconfig").vimls.setup {}
nvim_lsp.intelephense.setup {}

-- LSPのdiagnoticを無効にする
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false
    }
)

EOF
