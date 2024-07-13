" -----------------------------------------------------------
" unite.vim
" 起動時にインサートモードで開始

let mapleader = "\<Space>"

let g:unite_enable_start_insert = 1
let g:unite_source_file_mru_limit = 5000
let g:unite_update_time=10
let g:unite_source_file_rec_max_cache_files = 20000
let g:unite_source_rec_min_cache_files = 1000
if has("mac")
elseif has("win64")
endif

" Ignore build directories
call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
      \ 'ignore_pattern', join([
      \ '\.git/',
      \ '\/*build*',
      \ '\target/',
      \ 'node_modules/',
      \ ], '\|'))

" Search
let g:unite_source_grep_max_candidates = 2000
let g:unite_source_find_max_candidates = 2000

" 高速化
let g:unite_source_file_mru_filename_format = ''


let s:pat = '\v' . join([
      \   '\~$',
      \   '\.%(o|exe|dll|bak|DS_Store|zwc|pyc|sw[po]|class|meta)$',
      \   '%(^|[/\\])%(\.|\.hg|\.git|\.bzr|\.svn|tags%(-.*)?)%($|[/\\])$',
      \   '\.bundle/', 'vendor/',
      \ ], '|')
let g:unite_source_alias_aliases = {
      \   'proj_mru': {
      \     'source': 'file_mru',
      \   }
      \ }
call unite#custom#source('file', 'ignore_pattern',
      \                        '/\.\%(svn\|/\)\?$\|/tags\%(-..\)\?$\|\.meta$')
call unite#custom#source('file', 'ignore_globs', [])
call unite#custom#source('file_rec', 'ignore_pattern', s:pat)
call unite#custom#source('file_rec/async', 'ignore_pattern', s:pat)
call unite#custom#source('file_rec/git', 'ignore_pattern', s:pat)
call unite#custom#source('proj_mru', 'matchers',
      \                        ['matcher_project_files', 'matcher_default'])
call unite#custom#source('proj_mru', 'converters',
      \                        ['converter_relative_word'])
let s:unite_default_options = {
      \   'update_time': 50,
      \   'start_insert': 1,
      \ }
call unite#custom#profile('default', 'context', s:unite_default_options)
let g:unite_source_rec_max_cache_files = 100000


" アウトライン
nnoremap <silent> <Leader>o :<C-u>CloseSomeWindow
\	(index(['qf','unite','vimtest','taglist'], getwinvar(v:val,'&filetype')) != -1)
\		\|\| (getwinvar(v:val, '&filetype') ==# 'help'
\			&& !getwinvar(v:val, '&modifiable'))<CR>:<C-u>Unite outline -start-insert<CR>
nnoremap <silent> <Leader>O       :<C-u>CloseSomeWindow
\	(index(['qf','unite','vimtest','taglist'], getwinvar(v:val,'&filetype')) != -1)
\		\|\| (getwinvar(v:val, '&filetype') ==# 'help'
\			&& !getwinvar(v:val, '&modifiable'))<CR>:<C-u>Unite -no-quit -vertical -start-insert -winwidth=30 outline<CR>
let g:unite_source_outline_filetype_options = {
						\ '*': {
						\   'auto_update': 1,
						\   'auto_update_event': 'write',
						\ },
						\ 'cpp': {
						\   'auto_update': 0,
						\ },
						\ 'javascript': {
						\   'ignore_types': ['comment'],
						\ },
						\}
" grep
nnoremap <silent> <Leader>g :<C-u>Unite vimgrep<CR>
" grep検索
nnoremap <silent> ,g  :CdCurrent<CR>:<C-u>Unite grep:. -buffer-name=search-buffer<CR>
" ディレクトリを指定してgrep検索
nnoremap <silent> ,dg  :<C-u>Unite grep -buffer-name=search-buffer<CR>
nnoremap <silent> ,R  :<C-u>UniteResume search-buffer<CR>

if executable('pt')
  let g:unite_source_grep_command = 'pt'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor'
  let g:unite_source_grep_recursive_opt = ''
  let g:unite_source_grep_encoding = 'utf-8'
endif

" mark
let g:unite_source_mark_marks = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'

" ctag
nnoremap <silent> ,ut :<C-u>Unite tag -start-insert<CR>

" 常用セット
nnoremap <silent> <Leader><Leader> :<C-u>CloseSomeWindow
\	(index(['qf','unite','vimtest','taglist'], getwinvar(v:val,'&filetype')) != -1)
\		\|\| (getwinvar(v:val, '&filetype') ==# 'help'
\			&& !getwinvar(v:val, '&modifiable'))<CR>:<C-u>Unite -silent -start-insert buffer<CR>
nnoremap <silent> <Del> :<C-u>Unite -silent buffer file_mru<CR>
nnoremap <silent> <CR> :<C-u>CloseSomeWindow
\	(index(['qf','unite','vimtest','taglist'], getwinvar(v:val,'&filetype')) != -1)
\		\|\| (getwinvar(v:val, '&filetype') ==# 'help'
\			&& !getwinvar(v:val, '&modifiable'))<CR>mT:<C-u>Unite -silent -start-insert buffer file_mru<CR>
" call unite#custom#source('file,file/new,file_mru,buffer,file_rec',
" 			\ 'matchers', 'matcher_fuzzy')


autocmd MyAutoCmd FileType help,qf nnoremap <buffer> <C-o> <CR>

" yankround 
nnoremap <silent> <Leader>y :<C-u>Unite yankround -start-insert<CR>
" " ref/php
" nnoremap <silent> ,up :<C-u>Unite ref/phpmanual<CR>

" bookmark
nnoremap <silent> <Leader>b :<C-u>Unite bookmark -start-insert<cr>
if has("mac")
else
	let g:unite_source_bookmark_directory = "c:/tools/vim/bookmark"
endif
"call unite#custom_default_action('source/bookmark/directory' , 'vimfiler')

" command history
nnoremap <silent> <Leader>h mT:<C-u>Unite history/command -start-insert<cr>

" help
nnoremap <silent> <Leader>H :<C-u>Unite help<cr>

" file
nnoremap <silent> <Leader>F :CdCurrent<CR>:<C-u>Unite file -buffer-name=files -start-insert<Cr>
" nnoremap <silent> <Leader>f :<C-u>Unite file_rec/async -buffer-name=files -start-insert<Cr>

" " code change history
" nnoremap <silent> <Leader>j :<C-u>Unite jump -start-insert<cr>

" tab
" nnoremap <silent> <Leader>T :<C-u>Unite tab -start-insert<Cr>

" source
nnoremap <silent> <Leader>us :<C-u>Unite source<CR>

" ctag
" nnoremap <silent> <Leader>uT :<C-u>Unite tag<CR>

nnoremap <silent> <Leader>l :<C-u>Unite -buffer-name=search line -start-insert<CR>
call unite#custom#source('line', 'matchers', 'matcher_vigemo')
" 3文字入力した時から絞り込みを開始する
let g:unite#filters#matcher_vigemo#filtering_input_length = 4

" unite.vimのマッチャ設定
call unite#custom#source('grep', 'matchers', 'matcher_fuzzy')
call unite#custom#source('history/command', 'matchers', 'matcher_fuzzy')
" call unite#custom#source('file', 'matchers', 'matcher_vigemo')
" call unite#custom#source('line', 'matchers', 'matcher_vigemo')
" call unite#custom#source('yankround', 'matchers', 'matcher_vigemo')
" call unite#custom#source('outline', 'matchers', 'matcher_vigemo')
" call unite#custom#source('neomru/file', 'matchers', 'matcher_vigemo')
" call unite#custom#source('outline', 'syntax', 'shd')
" call unite#custom#source('toggl/task', 'matchers', 'matcher_vigemo')

" unite.vim上でのキーマッピング
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
		" 単語単位からパス単位で削除するように変更
		imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
		" ESCキーを2回押すと終了する
		nmap <silent><buffer> <ESC><ESC> q
		imap <silent><buffer> <ESC><ESC> <ESC>q
endfunction

let g:unite_source_outline_indent_width = 0

let g:unite_source_outline_filetype_options = {
						\ '*': {
						\   'auto_update': 1,
						\   'auto_update_event': 'hold',
						\ },
						\ 'cpp': {
						\   'auto_update': 0,
						\ },
						\ 'javascript': {
						\   'ignore_types': ['comment'],
						\ },
						\ 'markdown': {
						\   'auto_update_event': 'hold',
						\ },
						\}

augroup myuniteautocmd
  autocmd!
augroup END
autocmd myuniteautocmd FileType unite call s:my_unite_settings()
function! s:my_unite_settings()
  imap <silent><buffer> <C-q> <Plug>(unite_exit)
  imap <buffer><C-w> <Plug>(unite_delete_backward_path)
  map <silent><buffer><nowait> <Esc> <Plug>(unite_exit)
  noremap <silent><buffer><expr> s unite#smart_map("s", unite#do_action('right'))
  noremap <silent><buffer><expr> S unite#smart_map("S", unite#do_action('split'))
  noremap <silent><buffer><expr> n unite#smart_map("n", unite#do_action('insert'))
  noremap <silent><buffer><expr> f unite#smart_map("f", unite#do_action('vimfiler'))
  noremap <silent><buffer><expr> F unite#smart_map("f", unite#do_action('tabvimfiler'))
  imap <silent><buffer> <C-n> <Plug>(unite_select_next_line)<Esc>
  imap <silent><buffer><expr>     <C-s>  unite#do_action('split')
  imap <silent><buffer><expr>     <C-v>  unite#do_action('vsplit')
  imap <silent><buffer>           jj     <Plug>(unite_insert_leave)
  imap <silent><buffer><expr>     j      unite#smart_map('j', '')
  nmap <silent><buffer> <C-n> <Plug>(unite_loop_cursor_down)
  nmap <silent><buffer> <C-p> <Plug>(unite_loop_cursor_up)
  map <silent><buffer> <M-n> <Plug>(unite_rotate_next_source)
  map <silent><buffer> <M-p> <Plug>(unite_rotate_previous_source)
  imap <silent><buffer> <Esc> <Plug>(unite_insert_leave)

  inoremap <silent><buffer><expr> <C-t> unite#do_action('tabopen')
  nnoremap <silent><buffer><expr> <C-t> unite#do_action('tabopen')

  inoremap <silent><buffer><expr> <C-y> unite#do_action('yank')
  nnoremap <silent><buffer><expr> <C-y> unite#do_action('yank')

  inoremap <silent><buffer><expr> <C-z> unite#do_action('preview')
  nnoremap <silent><buffer><expr> <C-z> unite#do_action('preview')

  inoremap <silent><buffer><expr> <C-e> unite#do_action('rec')
  nnoremap <silent><buffer><expr> <C-e> unite#do_action('rec')

  inoremap <silent><buffer><expr> <C-k> unite#do_action('create')
  nnoremap <silent><buffer><expr> <C-k> unite#do_action('create')

  inoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
nnoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
endfunction

" project
let $JVGREP_OUTPUT_ENCODING = 'sjis'
set grepprg=jvgrep


let g:unite_source_rec_async_command=['pt', '--nocolor', '--nogroup', '-g', '.']
nnoremap <silent> <Space>P  :<C-u>CloseSomeWindow
      \	(index(['qf','unite','vimtest','taglist'], getwinvar(v:val,'&filetype')) != -1)
      \		\|\| (getwinvar(v:val, '&filetype') ==# 'help'
      \			&& !getwinvar(v:val, '&modifiable'))<CR>:<C-u>call Unite_project_files('-start-insert -auto-preview')<CR>
function! Unite_project_files(options)
  cd c:/vagrant
  let b:projectlocal_root_dir = ''
  if exists('b:projectlocal_root_dir')
    echo b:projectlocal_root_dir
    execute ':Unite file_rec:' . ' -start-insert'
    " execute ':Unite file_rec/async:' . b:projectlocal_root_dir . ' ' . a:options
  else
    echo "You are not in any project."
  endif
endfunction

nnoremap <silent> <Space>p  :<C-u>CloseSomeWindow
      \	(index(['qf','unite','vimtest','taglist'], getwinvar(v:val,'&filetype')) != -1)
      \		\|\| (getwinvar(v:val, '&filetype') ==# 'help'
      \			&& !getwinvar(v:val, '&modifiable'))<CR>:<C-u>call Unite_project_grep('-start-insert')<CR>
function! Unite_project_grep(options)
  let b:projectlocal_root_dir = 'c:/vagrant/web/stg-m39_app'
  cd c:/vagrant
  if exists('b:projectlocal_root_dir')
    execute ':Unite grep:' . '.' . ' -no-quit ' . a:options
    " execute ':Unite grep:' . b:projectlocal_root_dir . ' ' . a:options
  else
    echo "You are not in any project."
  endif
endfunction


