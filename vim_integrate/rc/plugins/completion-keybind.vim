function! SetFileTypeBindings()
  if &filetype   == 'changelog' || &filetype == 'markdown' || &filetype == 'text' || &filetype == '' || &filetype == 'help'
    " for cmp
    silent execute "CocDisable"
    " silent execute "lua require('cmp').setup.buffer { enabled = true }"
  elseif &filetype == 'ddu-ff'
    silent execute "CocDisable"
    " silent execute "lua require('cmp').setup.buffer { enabled = false }"
  else
    " for coc.nvim
    silent execute "CocEnable"
    " silent execute "lua require('cmp').setup.buffer { enabled = false }"
  endif
endfunction

augroup FileTypeBindings
  autocmd!
  autocmd BufEnter * call SetFileTypeBindings()
augroup END
