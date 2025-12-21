lua << EOF
-- mason.setup() は lsp.vim で設定済み
local mason_lspconfig = require('mason-lspconfig')
local nvim_lsp = require('lspconfig')

require("lspconfig").vimls.setup {}
nvim_lsp.intelephense.setup {}

-- LSPのdiagnoticを無効にする
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false
    }
)

local bufopts = { noremap=true, silent=true, buffer=bufnr }
vim.keymap.set('n', '<space>ck', vim.lsp.buf.hover, bufopts)
-- vim.keymap.set('n', '<space>cd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', '<space>ci', vim.lsp.buf.implementation, bufopts)
vim.keymap.set('n', '<space>cr', vim.lsp.buf.references, bufopts)
vim.keymap.set('n', '<space>cr', vim.lsp.buf.rename, bufopts)
vim.keymap.set('n', '<space>cD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', '<space>ci', vim.lsp.buf.implementation, bufopts)
vim.keymap.set('n', '<space>ct', vim.lsp.buf.type_definition, bufopts)
vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
vim.keymap.set('n', '<space>ce', vim.diagnostic.open_float, bufopts)

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = {"*.php", "*.ts"},
	buffer = buffer,
	callback = function()
	vim.lsp.buf.format { async = false }
	end
})

local capabilities = require("ddc_source_lsp").make_client_capabilities()
nvim_lsp.denols.setup({
  capabilities = capabilities,
})
nvim_lsp.vimls.setup({
  capabilities = capabilities,
})
nvim_lsp.intelephense.setup({
  capabilities = capabilities,
})

vim.lsp.diagnostics_trigger_update = false

local border = {
      {"┏", "FloatBorder"},  -- upper left
      {"━", "FloatBorder"},  -- upper
      {"┓", "FloatBorder"},  -- upper right
      {"┃", "FloatBorder"},  -- right
      {"┛", "FloatBorder"},  -- lower right
      {"━", "FloatBorder"},  -- lower
      {"┗", "FloatBorder"},  -- lower left
      {"┃", "FloatBorder"},  -- left
}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {
    border = "rounded", -- "shadow" , "none", "rounded"
    border = border
    -- width = 100,
  }
)

vim.cmd [[
autocmd ColorScheme * highlight NormalFloat guifg=gray guibg=#073642
autocmd ColorScheme * highlight FloatBorder guifg=gray guibg=#073642
autocmd ColorScheme * highlight! link FloatBorder NormalFloat
]]

EOF
