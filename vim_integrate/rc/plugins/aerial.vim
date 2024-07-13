lua << EOF
-- fidget.nvim
require"fidget".setup{}

require('aerial').setup({
-- optionally use on_attach to set keymaps when aerial has attached to a buffer
on_attach = function(bufnr)
-- Jump forwards/backwards with '{' and '}'
vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', {buffer = bufnr})
vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', {buffer = bufnr})
end
})
vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')
vim.keymap.set('n', '<leader>o', '<cmd>lua require("telescope").extensions.aerial.aerial()<CR>')

EOF

