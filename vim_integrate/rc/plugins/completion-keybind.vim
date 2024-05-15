function! s:enable_coc_for_type() 
  let l:filesuffix_whitelist = ['php', 'ts', 'vim', 'sh', 'py', 'shd', 'json', 'changelog', 'md', 'txt', 'copilot-chat']
  if index(l:filesuffix_whitelist, expand('%:e')) == -1
    echo 'ok'
    let b:coc_enabled = 0
  endif
endfunction
autocmd BufRead,BufNewFile * call s:enable_coc_for_type()

" .vimrc や任意のVim設定ファイルに追加

" filetypeに基づいてキーバインドを設定する関数
function! SetFileTypeBindings()
  " filetypeを取得
  let l:filetype = &filetype

  " filetypeがmarkdownの場合
  if l:filetype   == 'changelog'
    " for ddc.vim
    inoremap <silent><expr> <TAB>
          \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
          \ (col('.') < = 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
          \ '<TAB>' : ddc#map#manual_complete()
    inoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
    inoremap <C-n>   <Cmd>call pum#map#select_relative(+1)<CR>
    inoremap <C-p>   <Cmd>call pum#map#select_relative(-1)<CR>
    inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
    inoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
    inoremap <expr><CR> pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : lexima#expand('<CR>', 'i')
  else
    " for coc.nvim
    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#_select_confirm()
          \: "\<C-g>u" . lexima#expand('<LT>CR>', 'i')

    inoremap <silent><expr> <C-n> coc#pum#visible() ? coc#pum#next(1) : "\<C-n>"
    inoremap <silent><expr> <C-p> coc#pum#visible() ? coc#pum#prev(1) : "\<C-p>"
    inoremap <silent><expr> <down> coc#pum#visible() ? coc#pum#next(0) : "\<down>"
    inoremap <silent><expr> <up> coc#pum#visible() ? coc#pum#prev(0) : "\<up>"

    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~ '\s'
    endfunction

    imap <silent><expr> <TAB>
          \ coc#pum#visible() ? coc#pum#next(1):
          \ <SID>check_back_space() ? "\<Tab>" :
          \ coc#refresh()
    imap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

    let g:coc_snippet_next = '<tab>'

    nmap <silent> <Leader>cd <Plug>(coc-definition)
    nmap <silent> <Leader>cy <Plug>(coc-type-definition)
    nmap <silent> <Leader>ci <Plug>(coc-implementation)
    nmap <silent> <Leader>cr <Plug>(coc-references)
    nmap <silent> <Leader>cn <Plug>(coc-rename)
    nmap <silent> <Leader>cf <Plug>(coc-format)
    vmap <silent> <Leader>cf <Plug>(coc-format)
    nmap <silent> <Leader>cR  <Plug>(coc-refactor)

    nnoremap <silent> <space>cla  :<C-u>CocFzfList diagnostics<CR>
    nnoremap <silent> <space>clb  :<C-u>CocFzfList diagnostics --current-buf<CR>
    nnoremap <silent> <space>clc  :<C-u>CocFzfList commands<CR>
    nnoremap <silent> <space>cle  :<C-u>CocFzfList extensions<CR>
    nnoremap <silent> <space>cls  :<C-u>CocFzfList symbols<CR>
    nnoremap <silent> <space>clS  :<C-u>CocFzfList services<CR>
    nnoremap <silent> <space>clp  :<C-u>CocFzfListResume<CR>
    nmap <silent> <Leader>caA <Plug>(coc-codeaction)
    nmap <silent> <Leader>cal <Plug>(coc-codeaction-line)
    xmap <silent> <Leader>cas <Plug>(coc-codeaction-selected)
    nmap <silent> <leader>caa <Plug>(coc-codeaction-cursor)

    autocmd FileType php,typescript,python,markdown,javascript,vim nnoremap <silent> <space>co  :<C-u>CocFzfList outline<CR>
  endif
endfunction

" BufEnterイベントが発生したときにSetFileTypeBindings関数を呼び出す
augroup FileTypeBindings
  autocmd!
  autocmd BufEnter * call SetFileTypeBindings()
augroup END

