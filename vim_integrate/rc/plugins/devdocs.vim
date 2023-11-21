"" -----------------------------------------------------------
" devdocs.vim
augroup plugin-devdocs
  autocmd!
  autocmd FileType php,ruby nmap <buffer>dK <Plug>(devdocs-under-cursor)
augroup END
