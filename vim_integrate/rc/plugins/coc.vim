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
  \, 'coc-biome'
  \, 'coc-lua'
  \, 'coc-deno'
  \ ]


  " \, '@hexuhua/coc-copilot'
  " \, 'coc-stylua'

let g:markdown_fenced_languages = [
     \ 'vim',
     \ 'help'
     \]

let g:coc_fzf_opts = ['--layout=reverse']
let g:fzf_layout = { 'up': '~40%' }
let g:fzf_layout = { 'window': { 'width': 0.7, 'height': 0.6,} }

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

autocmd BufNew,BufEnter *.json,*.vim,*.php,*.ts execute "silent! CocEnable"
autocmd BufLeave,BufNew,BufEnter *changelogmemo,*.txt,*.md execute "silent! CocDisable"

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

