noremap <silent> <Leader>l :<C-u>Denite -start-filter -direction=top -no-statusline line<CR>
noremap <silent> <Leader>o :<C-u>Denite -start-filter -no-statusline  unite:outline<CR>
noremap <silent> <Leader>c :<C-u>DeniteCursorWord -start-filter -no-statusline  grep<CR>
noremap <silent> <CR><CR> :<C-u>Denite-start-filter -direction=top -winheight=`90*winheight(0)/100` buffer file_mru<CR>
noremap <silent> <Leader><Leader> :<C-u>Denite -start-filter -no-statusline  buffer<CR>
noremap <silent> <Leader>y :<C-u>Denite -start-filter -no-statusline neoyank<CR>
noremap <silent> <Leader>R :<C-u>Denite -start-filter -no-statusline -resume<CR>
noremap <silent> <Leader>h :<C-u>Denite -start-filter -direction=top command_history<CR>
noremap <silent> <Leader>g :<C-u>Denite -start-filter -no-statusline grep<CR>

nnoremap <silent> <Leader>D  :<C-u>CloseSomeWindow
			\	(index(['qf','unite', 'denite', 'vimtest','taglist'], getwinvar(v:val,'&filetype')) != -1)
			\		\|\| (getwinvar(v:val, '&filetype') ==# 'help'
			\			&& !getwinvar(v:val, '&modifiable'))<CR>:<C-u>call Denite_project_grep_all('-auto-preview')<CR>
function! Denite_project_grep_all(options)
	let b:projectlocal_root_dir = '/home/kf/app/php/plugin'
	if exists('b:projectlocal_root_dir')
		execute ':Denite grep:' . b:projectlocal_root_dir . ' ' . a:options
	else
		echo "You are not in any project."
	endif
endfunction

" customize ignore globs
" call denite#custom#source('grep', 'matchers', ['matcher_fuzzy','matcher_ignore_globs'])

" call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
			\ [
			\ '.*.min.js',
			\ '.*.json',
			\ 'vendor/*',
			\ 'node_modules/*',
			\ '.git/', 'build/', '__pycache__/',
			\ 'images/', '*.o', '*.make',
			\ '*.min.*',
			\ 'img/', 'fonts/'])


" fruzzy
" " optional - but recommended - see below
" let g:fruzzy#usenative = 1
"
" let g:fruzzy#sortonempty = 1 " default value
"
" " tell denite to use this matcher by default for all sources
" " call denite#custom#source(command_history', 'matchers', ['matcher/fruzzy'])

" denite ui branch {{{1
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
	nnoremap <silent><buffer><expr> <CR>
				\ denite#do_map('do_action')
	nnoremap <silent><buffer><expr> d
				\ denite#do_map('do_action', 'delete')
	nnoremap <silent><buffer><expr> p
				\ denite#do_map('do_action', 'preview')
	nnoremap <silent><buffer><expr> q
				\ denite#do_map('quit')
	nnoremap <silent><buffer><expr> i
				\ denite#do_map('open_filter_buffer')
	nnoremap <silent><buffer><expr> <Space>
				\ denite#do_map('toggle_select').'j'
	imap <buffer> jj <Plug>(denite_filter_update)
endfunction

call denite#custom#var('file/rec', 'command',
			\ ['pt', '--follow', '--nocolor', '--nogroup',
			\ (has('win32') ? '-g:' : '-g='), ''])


" Change matchers.
call denite#custom#source(
			\ 'file_mru', 'matchers', ['matcher/fuzzy'])

" Change sorters.
call denite#custom#source(
			\ 'file/rec', 'sorters', ['sorter/sublime'])
" Change sorters.
call denite#custom#source(
			\ 'buffer', 'sorters', ['sorter/sublime'])
call denite#custom#source(
			\ 'file_mru', 'sorters', ['sorter/sublime'])


" Add custom menus
let s:menus = {}

let s:menus.zsh = {
			\ 'description': 'Edit your import zsh configuration'
			\ }
let s:menus.zsh.file_candidates = [
			\ ['zshrc', '~/.config/zsh/.zshrc'],
			\ ['zshenv', '~/.zshenv'],
			\ ]

let s:menus.my_commands = {
			\ 'description': 'Example commands'
			\ }
let s:menus.my_commands.command_candidates = [
			\ ['Split the window', 'vnew'],
			\ ['Open zsh menu', 'Denite menu:zsh'],
			\ ['Format code', 'FormatCode', 'go,python'],
			\ ]

call denite#custom#var('menu', 'menus', s:menus)


" Pt command on grep source
call denite#custom#var('grep', 'command', ['pt'])
call denite#custom#var('grep', 'default_opts',
			\ ['-i', '--nogroup', '--nocolor', '--smart-case'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" }}}1
