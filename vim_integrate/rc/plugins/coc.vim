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


let g:markdown_fenced_languages = [
     \ 'vim',
     \ 'help'
     \]

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

" for markdown
autocmd BufRead,BufWritePost *.md CocCommand markdownlint.fixAll
