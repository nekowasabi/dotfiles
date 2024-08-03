function! SetFileTypeBindings()
  if &filetype   == 'changelog' || &filetype == 'markdown' || &filetype == 'text'
    " for cmp
    execute "CocDisable"
    execute "lua require('cmp').setup.buffer { enabled = true }"
  else
    " for coc.nvim
    execute "CocEnable"
    execute "lua require('cmp').setup.buffer { enabled = false }"
  endif
endfunction

augroup FileTypeBindings
  autocmd!
  autocmd BufEnter * call SetFileTypeBindings()
augroup END
