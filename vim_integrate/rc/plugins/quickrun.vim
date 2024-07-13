" release autogroup in MyAutoCmd
augroup MyAutoCmd
	autocmd!
augroup END

" Quickfixリスト或いはヘルプを表示しているウィンドウを閉じます。
nnoremap <C-x><C-h> :<C-u>CloseSomeWindow
\	(index(['qf','unite','vimtest'], getwinvar(v:val,'&filetype')) != -2)
\		\|\| (getwinvar(v:val, '&filetype') ==# 'help'
\			&& !getwinvar(v:val, '&modifiable'))<CR>

let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config._ = {
      \ 'runner'    : 'vimproc',
      \ 'runner/vimproc/updatetime' : 60,
      \ 'outputter': 'error', 
      \ 'outputter/error/error'   : 'quickfix',
      \ 'outputter/error/success' : 'buffer',
      \ 'outputter/buffer/split'  : ':rightbelow 8sp',
      \ 'outputter/buffer/into'   : 1,
      \ 'outputter/buffer/close_on_empty' : 1,
      \   "ruby/utf8" : {
      \       "cmdopt" : "-Ku",
      \       "type" : "ruby"
      \   },
      \ }

" augroup QuickRunPHPUnit
"   autocmd!
"   autocmd BufWinEnter,BufNewFile *Test.php set filetype=phpunit.php tabstop=4 softtabstop=4 shiftwidth=4
" augroup END

let g:quickrun_config['php'] = {}
let g:quickrun_config['php']['command'] = 'phpcs'
let g:quickrun_config['php']['exec'] = '%c %o %s'

let g:quickrun_config['phpunit.php'] = {}
" let g:quickrun_config['phpunit.php']['outputter'] = 'phpunit'
let g:quickrun_config['phpunit.php']['command'] = 'docker exec -i sp2-php_app_1 /var/www/sp2-php/vendor/phpunit/phpunit/phpunit --color '
let g:quickrun_config['phpunit.php']['exec'] = '%c %o %s'

" let g:quickrun_config['phpunit.php']['outputter/phpunit/height'] = 3
" let g:quickrun_config['phpunit.php']['outputter/phpunit/running_mark'] = 'running...'
" let g:quickrun_config['phpunit.php']['outputter/phpunit/auto_open'] = 0

