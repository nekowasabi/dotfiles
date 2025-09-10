" function! s:LazyGit()
"   call setcellwidths([])
"   lua require("snacks").lazygit()
" endfunction
" command! LazyGit call <SID>LazyGit()
" nnoremap <silent> <leader>lg :LazyGit<CR>

" function! s:Terminal()
"   call setcellwidths([])
"   lua require("snacks").terminal()
" endfunction
" command! Terminal call <SID>Terminal()
" nnoremap <silent> <leader>gt :Terminal<CR>

lua << EOF
require("snacks").setup({
  opts = {
    lazygit = { enabled = false },
    bufdelete = { enabled = true },
    notify = { enabled = true },
    scratch = { enabled = true },
    terminal = { enabled = true },
    toggle = {
      enabled = true,
      map = vim.keymap.set, -- keymap.set function to use
      which_key = true, -- integrate with which-key to show enabled/disabled icons and colors
      notify = true, -- show a notification when toggling
      -- icons for enabled/disabled states
      icon = {
        enabled = " ",
        disabled = " ",
      },
      -- colors for enabled/disabled states
      color = {
        enabled = "green",
        disabled = "yellow",
      },
    },
  },
})
EOF
