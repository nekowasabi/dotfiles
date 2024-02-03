lua << EOF
-- lsp
require("mason").setup()
require('mason-lspconfig').setup_handlers({ function(server)
  local opt = {
    -- -- -- Function executed when the LSP server startup
    -- on_attach = function(client, bufnr)
    --   local opts = { noremap=true, silent=true }
    --   vim.cmd 'autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 1000)'
    -- end,
  }
  require('lspconfig')[server].setup(opt)
end })

require("lspconfig").vimls.setup {}
require("lspconfig").intelephense.setup {}
require("lspconfig").denols.setup {}

-- LSPのdiagnoticを無効にする
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true
    }
)

EOF
