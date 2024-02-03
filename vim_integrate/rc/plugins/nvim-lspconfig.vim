lua << EOF
-- lsp
require("mason").setup()
require("mason-lspconfig").setup()
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
