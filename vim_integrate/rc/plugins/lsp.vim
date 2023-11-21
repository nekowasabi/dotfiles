" lsp_saga
function! s:nvim_lsp_show_documentation() abort
  if index(['vim', 'help'], &filetype) >= 0
    execute 'h ' . expand('<cword>')
  else
    lua require('lspsaga.hover').render_hover_doc()
  endif
endfunction

nnoremap <silent> <leader>ck <cmd>call <SID>nvim_lsp_show_documentation()<CR>
nnoremap <silent> <leader>cf <cmd>Lspsaga code_action<CR>
nnoremap <silent> <leader>cr <cmd>Lspsaga rename<CR>

lua << EOF
require("mason").setup()
require("mason-lspconfig").setup()
require('lspsaga').setup({
error_sign = " ",
warn_sign  = " ",
hint_sign  = " ",
infor_sign = " ",
})

-- keyboard shortcut
vim.keymap.set('n', '<leader>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
vim.keymap.set('n', '<leader>cr', '<cmd>lua vim.lsp.buf.references()<CR>')
vim.keymap.set('n', '<leader>cd', '<cmd>lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', '<leader>cD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
vim.keymap.set('n', '<leader>ci', '<cmd>lua vim.lsp.buf.implementation()<CR>')
vim.keymap.set('n', '<leader>ct', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
vim.keymap.set('n', '<leader>cn', '<cmd>lua vim.lsp.buf.rename()<CR>')
vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set('n', '<leader>ce', '<cmd>lua vim.diagnostic.open_float()<CR>')
vim.keymap.set('n', '<leader>c]', '<cmd>lua vim.diagnostic.goto_next()<CR>')
vim.keymap.set('n', '<leader>c[', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
EOF
