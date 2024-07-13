" asynccomplete.vim
" lsp
if executable('typescript-language-server')
  au User lsp_setup call lsp#register_server({
      \ 'name': 'typescript-language-server',
      \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
      \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
      \ 'whitelist': ['typescript'],
      \ })
  let g:lsp_log_verbose = 1
  let g:lsp_log_file = expand('~/vim-lsp.log')

  let g:asyncomplete_log_file = expand('~/asyncomplete.log')
  let g:asyncomplete_auto_popup = 1
  let g:asyncomplete_remove_duplicates = 0
  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
  " autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
endif

