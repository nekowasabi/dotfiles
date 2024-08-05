function! SetFileTypeBindings()
	if &filetype == 'ddu-ff'
		return
	endif

  if &filetype   == 'changelog' || &filetype == 'markdown' || &filetype == 'text' || &filetype == '' || &filetype == 'help' || &filetype == 'ddu-ff'
    " for cmp
    silent execute "CocDisable"
    silent execute "lua require('cmp').setup.buffer { enabled = true }"
  else
    " for coc.nvim
    silent execute "CocEnable"
    silent execute "lua require('cmp').setup.buffer { enabled = false }"
  endif
endfunction

augroup FileTypeBindings
  autocmd!
  autocmd BufEnter * call SetFileTypeBindings()
augroup END
