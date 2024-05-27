" coc.nvim

let g:coc_global_extensions = [
  \  'coc-json'
  \, 'coc-lists'
  \, 'coc-eslint'
  \, 'coc-tsserver'
  \, 'coc-diagnostic'
  \, 'coc-vimlsp'
  \, 'coc-git'
  \, 'coc-github-users'
  \, '@yaegassy/coc-intelephense'
  \, '@yaegassy/coc-laravel'
  \, '@yaegassy/coc-phpstan'
  \, '@yaegassy/coc-typescript-vue-plugin'
  \, 'coc-swagger'
  \, '@yaegassy/coc-volar-tools'
  \, '@yaegassy/coc-volar'
  \, 'coc-php-cs-fixer'
  \, 'coc-fzf-preview'
  \, 'coc-sh'
  \, 'coc-yaml'
  \, 'coc-blade'
  \, 'coc-deno'
  \, 'coc-markdownlint'
  \ ]

  "\, 'coc-sql'
  "\, 'coc-db'
  "\, 'coc-phpactor'


let g:markdown_fenced_languages = [
     \ 'vim',
     \ 'help'
     \]

" " Remap keys for gotos
" nmap <silent> <Leader>cd <Plug>(coc-definition)
" nmap <silent> <Leader>cy <Plug>(coc-type-definition)
" nmap <silent> <Leader>ci <Plug>(coc-implementation)
" nmap <silent> <Leader>cr <Plug>(coc-references)
" nmap <silent> <Leader>cn <Plug>(coc-rename)
" nmap <silent> <Leader>cf <Plug>(coc-format)
" vmap <silent> <Leader>cf <Plug>(coc-format)
" nmap <silent> <Leader>R  <Plug>(coc-refactor)
" 
" nnoremap <silent> <space>cla  :<C-u>CocFzfList diagnostics<CR>
" nnoremap <silent> <space>clb  :<C-u>CocFzfList diagnostics --current-buf<CR>
" nnoremap <silent> <space>clc  :<C-u>CocFzfList commands<CR>
" nnoremap <silent> <space>cle  :<C-u>CocFzfList extensions<CR>
" nnoremap <silent> <space>cls  :<C-u>CocFzfList symbols<CR>
" nnoremap <silent> <space>clS  :<C-u>CocFzfList services<CR>
" nnoremap <silent> <space>clp  :<C-u>CocFzfListResume<CR>
" 
" autocmd FileType php,typescript,python,markdown,javascript,vim nnoremap <silent> <space>o  :<C-u>CocFzfList outline<CR>
" 
" nmap <silent> <Leader>caA <Plug>(coc-codeaction)
" nmap <silent> <Leader>cal <Plug>(coc-codeaction-line)
" xmap <silent> <Leader>cas <Plug>(coc-codeaction-selected)
" nmap <silent> <leader>caa <Plug>(coc-codeaction-cursor)

let g:coc_fzf_opts = ['--layout=reverse']
let g:fzf_layout = { 'up': '~40%' }
let g:fzf_layout = { 'window': { 'width': 0.7, 'height': 0.6,} }

" Use K to show documentation in preview window
nnoremap <silent> <Leader>ck :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

augroup command_window
    function! ReInitCoc()
        execute("CocDisable")
        execute("CocEnable")
    endfunction
    autocmd CmdwinEnter * startinsert
    autocmd CmdwinEnter * call ReInitCoc()
augroup END

" for PHP
" autocmd BufWritePre *.php call CocAction('format')
" 
" function! CustomPhpFormat()
"     " 現在のファイル名が '*.blade.php' で終わるかどうかをチェック
"     if expand('%:t') !~ '\.blade\.php$'
"         " '*.blade.php' で終わらない場合はフォーマットを実行
"         call CocAction('format')
"     endif
" endfunction
" 
" PHPファイルを保存前にCustomPhpFormat関数を呼び出す
" autocmd BufWritePre *.php call CustomPhpFormat()
