" lsp_saga
function! s:nvim_lsp_show_documentation() abort
  if index(['vim', 'help'], &filetype) >= 0
    execute 'h ' . expand('<cword>')
  else
    lua require('lspsaga.hover').render_hover_doc()
  endif
endfunction

" nnoremap <silent> <leader>ck <cmd>call <SID>nvim_lsp_show_documentation()<CR>
" nnoremap <silent> <leader>cf <cmd>Lspsaga code_action<CR>
" nnoremap <silent> <leader>cr <cmd>Lspsaga rename<CR>

lua << EOF

require("mason").setup()
-- require("mason-lspconfig").setup()
-- require("mason-lspconfig").setup_handlers {
--   function (server_name) -- default handler (optional)
--     require("lspconfig")[server_name].setup {
--       on_attach = on_attach, --keyバインドなどの設定を登録
--       capabilities = capabilities, --cmpを連携
--     }
--   end,
-- }

require("mason-lspconfig").setup_handlers({
	function(server_name)
		-- require("lspconfig")[server_name].setup({})
		vim.lsp.enable({server_name})
	end,
})

-- require('lspsaga').setup({
-- error_sign = " ",
-- warn_sign  = " ",
-- hint_sign  = " ",
-- infor_sign = " ",
-- })

-- keyboard shortcut
vim.keymap.set('n', ',cf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
vim.keymap.set('n', ',cr', '<cmd>lua vim.lsp.buf.references()<CR>')
vim.keymap.set('n', ',cd', '<cmd>lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', ',cD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
vim.keymap.set('n', ',ci', '<cmd>lua vim.lsp.buf.implementation()<CR>')
vim.keymap.set('n', ',ct', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
vim.keymap.set('n', ',cn', '<cmd>lua vim.lsp.buf.rename()<CR>')
vim.keymap.set('n', ',ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set('n', ',ce', '<cmd>lua vim.diagnostic.open_float()<CR>')
vim.keymap.set('n', ',c]', '<cmd>lua vim.diagnostic.goto_next()<CR>')
vim.keymap.set('n', ',c[', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
EOF
