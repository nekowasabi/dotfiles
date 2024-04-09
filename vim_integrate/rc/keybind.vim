" Insert & Comandline Mode "{{{

let mapleader = "\<Space>"

" nnoremap <silent> qq  q:itgs
nnoremap <silent> Q q:i<C-r>=neosnippet#expand('tgs')<CR>

" カレントディレクトリ設定
command! -nargs=0 CdCurrent cd %:p:h
nnoremap ,d :CdCurrent<CR>

" reload and restart
if has("mac")
	nnoremap <silent> ,rr :source ~/.vimrc<CR>:source ~/.gvimrc<CR>
	nnoremap <silent> ,RR :Restart<CR>
else
	nnoremap <silent> ,rr :source c:/takeda/tools/vim/vimrc<CR>:source c:/takeda/tools/vim/gvimrc<CR>
	nnoremap <silent> ,RR :Restart<CR>
endif

nnoremap <silent><C-j> }
nnoremap <silent><C-k> {
" nnoremap <silent><C-j> :<C-u>keepjumps normal! }<CR>
" nnoremap <silent><C-k> :<C-u>keepjumps normal! {<CR>
vnoremap <C-j> }
vnoremap <C-k> {

nnoremap j gj
nnoremap k gk<ESC>
nnoremap gj j<ESC>
nnoremap gk k

nnoremap gf gF
nnoremap gF gf

vnoremap <silent>H 10h
vnoremap <silent>J 5gj
vnoremap <silent>K 5gk
vmap <silent>K 5gk
vnoremap <silent>L 10l

inoremap <C-f> ／
inoremap <C-x><C-x> ？／
cnoremap <C-f> ／
inoremap <C-b> →
nnoremap <C-Tab> 0i	
nnoremap <S-Tab> 0x

" 単語移動
if has("mac")
	nnoremap <D-k> :<C-U>call jasegment#MoveN(g:jasegment#model, 'jasegment#MoveB', v:count1, 0, 0, 0)<CR>
	nnoremap <D-l> :<C-U>call jasegment#MoveN(g:jasegment#model, 'jasegment#MoveW', v:count1, 0, 0, 0)<CR>
	inoremap <D-k> <S-Left><S-Left>
	inoremap <D-l> <S-Right><S-Right>
else
	nnoremap <A-k> :<C-U>call jasegment#MoveN(g:jasegment#model, 'jasegment#MoveB', v:count1, 0, 0, 0)<CR>
	nnoremap <A-l> :<C-U>call jasegment#MoveN(g:jasegment#model, 'jasegment#MoveW', v:count1, 0, 0, 0)<CR>
	vnoremap <A-k> :<C-U>call jasegment#MoveN(g:jasegment#model, 'jasegment#MoveB', v:count1, 0, 0, 0)<CR>
	vnoremap <A-l> :<C-U>call jasegment#MoveN(g:jasegment#model, 'jasegment#MoveW', v:count1, 0, 0, 0)<CR>
	inoremap <A-k> <S-Left><S-Left>
	inoremap <A-l> <S-Right><S-Right>
	cnoremap <A-k> <S-Left>
	cnoremap <A-l> <S-Right>
endif


" " backward
nnoremap <silent> D :<C-U>call jasegment#select_function_wrapper(g:jasegment#model, 'jasegment#select_i','o', v:count1)<CR>xh
function! s:DeleteJapaneseWords()
	let l:moji =  s:prev_cursor_char(0)
	if l:moji =~  "[。、？！]"
		return 1
	endif

	let l:moji =  s:prev_cursor_char(1)
	if l:moji =~  "[。、！？]"
		return 1
	endif
endfunction
" inoremap <silent> <expr> <C-w> <SID>DeleteJapaneseWords() ? "\<BS>\<C-w>\<C-w>" : "\<C-w>\<C-w>" 
au Filetype vim inoremap <silent> <buffer> <C-w> <C-w>
au Filetype shd,changelog,txt, inoremap <silent> <expr> <C-w> <SID>DeleteJapaneseWords() ? "\<BS>\<C-w>\<C-w>" : "\<C-w>\<C-w>" 

function! s:prev_cursor_char(n)
	let chars = split(getline('.')[0 : col('.')-1], '\zs')
	let len = len(chars)
	if a:n >= len
		return ''
	else
		return chars[len(chars) - a:n - 1]
	endif
endfunction

nnoremap <ESC><ESC> :nohlsearch<CR><ESC>

nnoremap ,d :CdCurrent<CR>

" ""---------------------------------------------------- 
" " change encoding
" nnoremap <silent> ,o :set fenc=cp932<CR>
" nnoremap <silent> ,u :set fenc=utf-8<CR>
" nnoremap <silent> ,p :set ff=dos<CR>

""---------------------------------------------------- 
" mark
nnoremap <silent> ,W mW
nnoremap <silent> ,w `W

" leader
nnoremap Â :
nnoremap <Leader>: :
nmap ; <PageDown>
nmap : <PageUp>
vmap ; <PageDown>
vmap : <PageUp>
vmap : :

nnoremap <silent> <Leader>w :w<CR>

""---------------------------------------------------- 
" vimshell
augroup my-vimshell
	" Recommended key-mappings.
	" <CR>: close popup and save indent.
	inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
	function! s:my_cr_function()
		return pumvisible() ? "\<C-y>" : "\<CR>"
	endfunction
	autocmd!
	autocmd FileType vimshell
				\       imap <expr> <buffer> <C-n> pumvisible() ? "\<C-n>" : "\<Plug>(vimshell_history_neocomplete)"
augroup END


" gfでいい感じに開く
autocmd FileType html setlocal includeexpr=substitute(v:fname,'^\\/','','') | setlocal path+=;/

"" ---------------------------------------------------
" ctags
if g:IsWsl()
	autocmd FileType php :set tags=/home/takets/php.tags
	autocmd BufEnter *.php :set tags=/home/takets/php.tags
	autocmd FileType javascript :set tags=/home/takets/jstags
	autocmd BufEnter *.js :set tags=/home/takets/jstags
	" for linux setting
	noremap <silent> ,tp :!/home/linuxbrew/.linuxbrew/bin/ctags -r --php-kinds=+cdfint-a --fields=+laims --languages=php  -f /home/takets/php.tags /home/takets/source/spider/sp2-php<cr>
	noremap <silent> ,tj :!/home/linuxbrew/.linuxbrew/bin/ctags -r --exclude=\*core.js --exclude=\*.min.js --exclude=\*.debug.js  --exclude=node_modules --fields=+laims --languages=javascript -f /home/kf/jstags /home/kf/app/<cr>

	" tagsジャンプの時に複数ある時は一覧表示
	nnoremap <c-]> g<c-]>
endif

if g:IsLinux()
	autocmd FileType php :set tags=/home/kf/php.tags
	autocmd BufEnter *.php :set tags=/home/kf/php.tags
	autocmd FileType javascript :set tags=/home/kf/jstags
	autocmd BufEnter *.js :set tags=/home/kf/jstags
	" for linux setting
	noremap <silent> ,tp :!/usr/bin/ctags -R --php-kinds=+cdfint -a --fields=+laims --languages=php -f /home/kf/php.tags /home/kf/app/php<cr>
	noremap <silent> ,tj :!/usr/bin/ctags -R --exclude=\*core.js --exclude=\*.min.js --exclude=\*.debug.js  --exclude=node_modules --fields=+laims --languages=javascript -f /home/kf/jstags /home/kf/app/web/js<cr>

	" tagsジャンプの時に複数ある時は一覧表示
	nnoremap <c-]> g<c-]>
endif



" 辞書検索 {{{1
function! s:DictionaryTranslate(...)
	let l:word = a:0 == 0 ? expand('<cword>') : a:1
	call histadd('cmd', 'DictionaryTranslate '  . l:word)
	if l:word ==# '' | return | endif
	let l:gene_path = 'c:/takeda/tools/vim/bin/GENE.TXT'
	let l:jpn_to_eng = l:word !~? '^[a-z_]\+$'
	let l:output_option = l:jpn_to_eng ? '-B 1' : '-A 1' " 和英 or 英和

	silent pedit Translate\ Result | wincmd P | %delete " 前の結果が残っていることがあるため
	setlocal buftype=nofile noswapfile modifiable
	silent execute 'read !grep -ihw' l:output_option l:word l:gene_path
	silent 0delete
	let l:esc = @z
	let @z = ''
	while search("^" . l:word . "$", "Wc") > 0 " 完全一致したものを上部に移動
		silent execute line('.') - l:jpn_to_eng . "delete Z 2"
	endwhile
	silent 0put z
	let @z = l:esc
	silent call append(line('.'), '==')
	silent 1delete
	silent wincmd l
endfunction
command! -nargs=? -complete=command DictionaryTranslate call <SID>DictionaryTranslate(<f-args>)
nnoremap <silent> ,D :DictionaryTranslate 
" }}}1

" エンコーディング指定オープン {{{1 
command! -bang -complete=file -nargs=? Utf8 edit<bang> ++enc=utf-8 ++bad=keep<args>
command! -bang -complete=file -nargs=? Sjis edit<bang> ++enc=cp932 ++bad=keep<args>
command! -bang -complete=file -nargs=? Euc edit<bang> ++enc=eucjp ++bad=keep<args>
command! -bang -complete=file -nargs=? WUtf8 write<bang> ++enc=utf-8 ++bad=keep<args>
command! -bang -complete=file -nargs=? WSjis write<bang> ++enc=cp932 ++bad=keep<args>
command! -bang -complete=file -nargs=? WEuc write<bang> ++enc=eucjp ++bad=keep<args>
" }}}1

" <F10> で編集中の Vim script をソース {{{1
if !exists('*s:source_script')
	" ~/.vimrc をソースすると関数実行中に関数の上書きを行うことになりエラーとなるため
	" 'function!' による強制上書きではなく if によるガードを行っている
	function s:source_script(path) abort
		let path = expand(a:path)
		if !filereadable(path)
			return
		endif
		execute 'source' fnameescape(path)
		echomsg printf(
					\ '"%s" has sourced (%s)',
					\ simplify(fnamemodify(path, ':~:.')),
					\ strftime('%c'),
					\)
	endfunction
endif
nnoremap <silent> <F10> :<C-u>call <SID>source_script('%')<CR>
" }}}1

" カレントファイルのパスをクリプボぅ! {{{
command! -nargs=* -bang -bar CopyCurrentFilepath :call s:copy_current_filepath('<bang>', <q-args>)

function! s:copy_current_filepath (bang, modifier)
	let l:path = expand('%' . a:modifier)
	if a:bang ==# '!'
		let l:path = printf('L%d@%s', line('.'), l:path)
	endif
	let @* = l:path
	let @+ = l:path
	echo printf('>> %s', l:path)
endfunction

" }}}

" Grep and Open current buffer
command! -nargs=1 GrepNow vimgrep <args> % | cwindow

" Command line buffer."{{{1
nnoremap <SID>(command-line-enter) q:
xnoremap <SID>(command-line-enter) q:
nnoremap <SID>(command-line-norange) q:<C-u>

" コマンドラインウィンドウの幅
set cmdwinheight=20


"}}}1

" remove highlighting and redraw
" nnoremap <silent> <BS> :nohlsearch<CR><C-L>

" vを二回で行末まで選択
vnoremap v $h

" 現在のバッファを分割して表示
nnoremap <Leader>BH :vsp<CR> :exe("tjump ".expand('<cword>'))<CR>
nnoremap <Leader>BV :split<CR> :exe("tjump ".expand('<cword>'))<CR>

" 画面分割トグル {{{1
let g:toggle_window_size = 0
function! ToggleWindowSize()
	if g:toggle_window_size == 1
		exec "normal \<C-w>="
		let g:toggle_window_size = 0
	else
		:resize
		:vertical resize
		let g:toggle_window_size = 1
	endif
endfunction
nnoremap <Leader><C-m> :call ToggleWindowSize()<CR>
" }}}1

" cn->なんか入力-> . で繰り返し置換できるようになる {{{1
let g:mc = "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>"
nnoremap cn *``cgn
nnoremap cN *``cgN
vnoremap <expr> cn g:mc . "``cgn"
vnoremap <expr> cN g:mc . "``cgN"
" }}}1

" vim type {{{1
" mac gvim {{{2
if g:IsMacGvim() || g:IsMacNeovim()
	function! s:OpenTentask()
		if fnamemodify(expand('%'), ':t') == "01_ver01.txt.shd"
			execute ":VoomQuitAll"
		endif

		if expand("%") != "tenTask.txt" && bufnr('tenTask.txt') == -1
			execute ":e ~/repos/changelog/tenTask.txt"
		endif

		if bufnr('tenTask.txt') != -1
			execute ":buffer repos/changelog/tenTask.txt"
			execute ":e %"
		endif

		" 現在のバッファの総行数を取得
		let l:total_lines = line('$')

		" 最後から30行前に移動する行数を計算
		let l:start_line = l:total_lines > 30 ? l:total_lines - 29 : 1

		" 指定された範囲のテキストを取得
		let l:lines = getline(l:start_line, '$')
		" l:linesを文字列に連結
		let l:lines = join(l:lines, " ")
		echomsg l:lines

		" 現在のタイムスタンプを取得
		let current_timestamp = localtime()

		" 昨日のタイムスタンプを計算（1日 = 86400秒）
		let yesterday_timestamp = current_timestamp - 86400

		" 昨日の日付をYYYY-MM-DD形式で取得
		let yesterday_date = strftime('%Y-%m-%d', yesterday_timestamp)

		let today_date = strftime('%Y-%m-%d', current_timestamp)

		" l:linesにyesterday_dateが含まれていて、today_dateが含まれていない場合
		let l:found = 0
		" if l:lines =~ yesterday_date && l:lines !~ today_date
		if l:lines !~ today_date
			let l:found = 1
		endif
		if l:found == 1
			call append("$", ['',  '--------------------------------------- '.strftime('%Y-%m-%d')])
			call append("$", ['----- '.strftime('%Y-%m-%d %H:%M:%S'), '・'])
			exe "normal! GA"
		else
			call append("$", ['----- '.strftime('%Y-%m-%d %H:%M:%S'), '・'])
			exe "normal! GA"
		endif

	endfunction
	command! OpenTentask call <SID>OpenTentask()
	nnoremap <silent> ,t :OpenTentask<CR>GA

	function! s:OpenOnlyTentask()
		if fnamemodify(expand('%'), ':t') == "01_ver01.txt.shd"
			execute ":VoomQuitAll"
		endif

		" execute "tabn 2"

		if expand("%") != "tenTask.txt" && bufnr('tenTask.txt') == -1
			execute ":e ~/repos/changelog/tenTask.txt"
		endif

		if bufnr('tenTask.txt') != -1
			execute ":buffer repos/changelog/tenTask.txt"
			execute ":e %"
		endif
		exe "normal! G"
		redraw
	endfunction
	command! OpenOnlyTentask call <SID>OpenOnlyTentask()
	nnoremap <silent> ,T :OpenOnlyTentask<CR>

	" function! s:OpenPraygroundFile()
	" 	if fnamemodify(expand('%'), ':t') != "01_ver01.txt.shd"
	" 		execute ":e ~/words/prayground/text/01_ver01.txt.shd"
	" 	endif
	" 	exe 'Voom'
	" 	exe 'wincmd l'
	" 	redraw
	" endfunction
	" command! OpenPraygroundFile call <SID>OpenPraygroundFile()
	" nnoremap <silent> ,o :OpenPraygroundFile<CR>

	function! s:OpenChangelog()

		if fnamemodify(expand('%'), ':t') == "01_ver01.txt.shd"
			execute ":VoomQuitAll"
		endif

		" execute "tabn 3"
		if expand("%") != "changelogmemo" && bufnr('changelogmemo') == -1
			execute ":e ~/repos/changelog/changelogmemo"
		endif

		if bufnr('changelogmemo') != -1
			execute ":buffer changelog/changelogmemo"
		endif
	endfunction
	" TODO: use noremap!
	imap <C-b> <Left>
	imap <C-f> <Right>
	imap <C-p> <Up>
	imap <C-n> <Down>
	" imap <C-a> <C-o>^
	" imap <C-e> <C-o>$

	cnoremap <C-b> <Left>
	cnoremap <C-f> <Right>
	cnoremap <C-a> <Home>
	cnoremap <C-e> <End>
	inoremap <C-f> ／
	inoremap <C-x><C-x> ？／
	cnoremap <C-f> ／
	inoremap <C-b> →
	nnoremap <C-Tab> 0i	
	nnoremap <S-Tab> 0x
  nnoremap <silent>H 10h
  nnoremap <silent>J 5gj
  nnoremap <silent>K 5gk
  nmap <silent>K 5gk
  nnoremap <silent>L 10l



	"}}}

	" Change current directory.
	" nnoremap <silent> ,cd :<C-u>call <SID>cd_buffer_dir()<CR>
	function! s:cd_buffer_dir()
		let filetype = getbufvar(bufnr('%'), '&filetype')
		if filetype ==# 'vimfiler'
			let dir = getbufvar(bufnr('%'), 'vimfiler').current_dir
		elseif filetype ==# 'vimshell'
			let dir = getbufvar(bufnr('%'), 'vimshell').save_dir
		else
			let dir = isdirectory(bufname('%')) ?
						\ bufname('%') : fnamemodify(bufname('%'), ':p:h')
		endif

		execute 'lcd' fnameescape(dir)
	endfunction


	let g:tabpagebuffer#command#bdelete_keeptabpage = 1

	inoremap <silent><C-g> <Esc>:wa<CR>

	" inoremap <expr> j getline('.')[col('.') - 2] ==# 'j' ? "\<BS>\<ESC>" : 'j'

	imap <F6> <ESC>i■<C-R>=strftime("%Y/%m/%d (%a) %H:%M")<CR><CR>・<CR>
	nmap <F6> <ESC>i■<C-r>=strftime("%Y-%m-%d %H:%M:%S")<CR><CR>


	command! OpenChangelog call <SID>OpenChangelog()
	nnoremap <silent> ,c <ESC>:OpenChangelog<CR>:set showtabline=2<CR>
	nnoremap <silent> ,l <ESC>:OpenChangelog<CR><C-home>o<CR>i<C-r>=neosnippet#expand('cpw')<CR>
	nnoremap <silent> ,Cp <ESC>:OpenChangelog<CR><C-home>o<CR>i<C-r>=neosnippet#expand('cpp')<CR>

	" setting reload
	nnoremap <silent> ,rr :source ~/.vimrc<CR>:source ~/.gvimrc<CR>
	nnoremap <silent> ,RR :Restart<CR>

	" 単語削除 {{{1
	function! s:RemoveContextWord()
		if s:prev_cursor_char(0) =~  "[a-zA-z]"
			return "\<C-w>" 
		endif

		if s:prev_cursor_char(0) =~ "[。、]"
			return "\<BS>"
		endif

		if s:prev_cursor_char(1) =~ "[ァ-ヴ一-龠][ァ-ヴ一-龠]"
			return "\<BS>\<C-w>\<C-w>"
		else
			return "\<C-w>\<C-w>" 
		endif

		return "\<BS>\<C-w>\<C-w>"
	endfunction

	function! s:prev_cursor_char(n)
		let chars = split(getline('.')[0 : col('.')-1], '\zs')
		let len = len(chars)
		if a:n >= len
			return ''
		else
			return chars[len(chars) - a:n - 1]
		endif
	endfunction
	" }}}1
	command! RemoveContextWord call s:RemoveContextWord() 
	inoremap <silent> <expr> <C-w> <SID>RemoveContextWord()

	nnoremap <ESC><ESC> :nohlsearch<CR><ESC>


endif
" }}}2

if g:IsWindowsGvim()
	set backupdir=$HOME/time_backup

	nnoremap <silent> ,rr :source c:/takeda/tools/vim/vimrc<CR>:source c:/takeda/tools/vim/gvimrc<CR>
	nnoremap <silent> ,RR :Restart<CR>

	function! s:OpenChangelog()
		if expand("%") != "changelogmemo"
			execute ":e c:/takeda/repos/changelog/changelogmemo"
		endif
	endfunction
	command! OpenChangelog call <SID>OpenChangelog()
	nnoremap <silent> ,c <ESC>:OpenChangelog<CR>

	function! s:OpenTentask()
		if expand("%") != "tenTask.txt" && bufnr('tenTask.txt') == -1
			execute ":e c:/takeda/repos/changelog/tenTask.txt"
		endif

		call append("$", ['----- '.strftime('%Y-%m-%d %H:%M:%S'), '・'])
		exe "normal! GkA"
		redraw
	endfunction
	command! OpenTentask call <SID>OpenTentask()
	nnoremap <silent> ,c <ESC>:OpenChangelog<CR>
	nnoremap <silent> ,l :buffer changelogmemo<CR><C-home>o<CR>a<C-r>=neosnippet#expand('cpw')<CR>

	function! s:OpenTentask()
		if expand("%") != "tenTask.txt" && bufnr('tenTask.txt') == -1
			execute ":e c:/takeda/repos/changelog/tentask.txt"
		endif

		if bufnr('tenTask.txt') != -1
			execute ":buffer c:/takeda/repos/changelog/tentask.txt"
		endif

		call append("$", ['----- '.strftime('%Y-%m-%d %H:%M:%S'), '・'])
		exe "normal! GkA"

	endfunction
	command! OpenTentask call <SID>OpenTentask()
	nnoremap <silent> ,t :OpenTentask<CR>GA

	function! s:OpenOnlyTentask()
		if expand("%") != "tenTask.txt" && bufnr('tenTask.txt') == -1
			execute ":e c:/takeda/repos/changelog/tentask.txt"
		endif

		if bufnr('tenTask.txt') != -1
			execute ":buffer c:/takeda/repos/changelog/tentask.txt"
		endif

		exe "normal! Gz+"
		redraw
	endfunction
	command! OpenOnlyTentask call <SID>OpenOnlyTentask()
	nnoremap <silent> ,T :OpenOnlyTentask<CR>

	" TODO: use noremap!
	imap <C-b> <Left>
	imap <C-f> <Right>
	imap <C-p> <Up>
	imap <C-n> <Down>
	" imap <C-a> <C-o>
	" imap <C-e> <C-o>$

	cnoremap <C-b> <Left>
	cnoremap <C-f> <Right>
	cnoremap <C-a> <Home>
	cnoremap <C-e> <End>
	inoremap <C-f> ／
	inoremap <C-x><C-x> ？／
	cnoremap <C-f> ／
	inoremap <C-b> →
	" nnoremap <C-Tab> 0i	
	" nnoremap <S-Tab> 0x
  nnoremap <silent>H 10h
  nnoremap <silent>J 5gj
  nnoremap <silent>K 5gk
  nmap <silent>K 5gk
  nnoremap <silent>L 10l


endif

if g:IsWindowsNeovim()
	nnoremap <silent> ,rr :source ~/.config/nvim/init.vim<CR>
endif

if g:IsLinux()
	" TODO: use noremap!
	imap <C-b> <Left>
	imap <C-f> <Right>
	imap <C-p> <Up>
	imap <C-n> <Down>
	" imap <C-a> <C-o>^
	" imap <C-e> <C-o>$

	cnoremap <C-b> <Left>
	cnoremap <C-f> <Right>
	cnoremap <C-a> <Home>
	cnoremap <C-e> <End>
	inoremap <C-f> ／
	inoremap <C-x><C-x> ？／
	cnoremap <C-f> ／
	inoremap <C-b> →
	nnoremap <C-Tab> 0i	
	nnoremap <S-Tab> 0x
  nnoremap <silent>H 10h
  nnoremap <silent>J 5gj
  nnoremap <silent>K 5gk
  nmap <silent>K 5gk
  nnoremap <silent>L 10l


endif


" Fast switching to the alternate file
" <BS>に割り当てると、<PageUp>後にkkkとすると、コマンドが暴発する謎が発生する
nnoremap <silent> <Leader>a :buffer#<CR>
