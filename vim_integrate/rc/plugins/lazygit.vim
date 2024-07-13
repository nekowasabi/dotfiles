nnoremap <silent> <leader>lg :LazyGit<CR>
let g:lazygit_floating_window_use_plenary = 1

lua << EOF
-- Lazygit起動時にESCを無効化する
vim.api.nvim_create_augroup("LazygitKeyMapping", {})
-- TermEnterでは起動されたバッファではなく、起動したバッファが対象になってしまう
local bkey = vim.api.nvim_buf_set_keymap
vim.api.nvim_create_autocmd("TermOpen", {
  group = "LazygitKeyMapping",
  pattern = "*",
  callback = function()
  local filetype = vim.bo.filetype
  -- filetypeにはlazygitが渡る。空文字ではない
  if filetype == "lazygit" then
    -- このkeymapが肝。なんでこれで動くのかは謎
    bkey(0, "t", "<ESC>", "<ESC>", { silent = true })
    -- <C-\><C-n>がNeovimとしてのESC。<ESC>はLazygitが奪う
    bkey(0, "t", "<C-x><C-x>", [[<C-\><C-n>]], { silent = true })
    bkey(0, "t", "jj", "<Down><Down>", { silent = true })
    end
  end,
})

EOF
