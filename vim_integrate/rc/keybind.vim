let mapleader = "\<Space>"
 
" global keybind {{{1
nnoremap <silent><C-j> }
nnoremap <silent><C-k> {
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
vnoremap <silent>L 10l

inoremap <M-f> ／
inoremap <M-x><M-x> ？／
inoremap <M-b> →
inoremap <D-b> →

" move window
nnoremap <silent> <C-t> <C-w>w

" 単語移動
if has("mac")
	inoremap <D-k> <S-Left><S-Left>
	inoremap <D-l> <S-Right><S-Right>
  cnoremap <D-k> <S-Left>
  cnoremap <A-l> <S-Right>
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

au Filetype vim inoremap <silent> <buffer> <C-w> <C-w>
au Filetype shd,changelog,txt, inoremap <silent> <expr> <C-w> <SID>DeleteJapaneseWords() ? "\<BS>\<C-w>\<C-w>" : "\<C-w>\<C-w>" 
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

" leader {{{1
nnoremap Â :
nmap ; <PageDown>
nmap : <PageUp>
vmap ; <PageDown>
vmap : <PageUp>
vmap : :

nnoremap <silent> <Leader><Leader> :w!<CR>
nnoremap <silent> <Leader>e :e!<CR>
" }}}1

" Visual <, >で連続してインデントを操作 {{{1
xnoremap < <gv
xnoremap > >gv
" }}}1

" gfでいい感じに開く {{{1
autocmd FileType html setlocal includeexpr=substitute(v:fname,'^\\/','','') | setlocal path+=;/
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
nnoremap <silent> ,rr :<C-u>call <SID>source_script('%')<CR>
" }}}1

" カレントファイルのフルパスをクリプボぅ! {{{
command! CopyCurrentFilepath :let @* = expand("%:p")
nnoremap <silent> ,cp :CopyCurrentFilepath<CR>:echo "Copied: " . expand("%:p")<CR>

" }}}

" Command line buffer."{{{1
nnoremap <SID>(command-line-enter) q:
xnoremap <SID>(command-line-enter) q:
nnoremap <SID>(command-line-norange) q:<C-u>

" コマンドラインウィンドウの幅
set cmdwinheight=20
"}}}1

" カレントディレクトリ設定 {{{1
command! -nargs=0 CdCurrent cd %:p:h
nnoremap <silent> ,d :CdCurrent<CR>
" }}}1

" vを二回で行末まで選択 {{{1
vnoremap v $h
" }}}1

" 現在のバッファを分割して表示 {{{1
nnoremap <Leader>BH :vsp<CR> :exe("tjump ".expand('<cword>'))<CR>
nnoremap <Leader>BV :split<CR> :exe("tjump ".expand('<cword>'))<CR>
" }}}1

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

" }}}2

" text object {{{1
onoremap i<space> iw
xnoremap i<space> iw
onoremap i<CR> iW
xnoremap i<CR> iW
nnoremap <silent> <M-p> :normal! vip<CR>
nnoremap <silent> <D-p> :normal! vip<CR>
nnoremap <silent> <Space><CR> ciW
nnoremap <silent> <CR><Space> ciw

xnoremap a" 2i"
xnoremap a' 2i'
xnoremap a` 2i`
onoremap a" 2i"
onoremap a' 2i'
onoremap a` 2i`
" }}}1

" Fast switching to the alternate file {{{
inoremap <silent> <C-z> <Esc>:SwitchPreviousBuffer<CR>
nnoremap <silent> <C-z> <Esc>:SwitchPreviousBuffer<CR>

function! s:SwitchPreviousBuffer()
  silent! buffer#
endfunction
command! SwitchPreviousBuffer call <SID>SwitchPreviousBuffer()
" }}}1

" mac gvim {{{1
if g:IsMacGvim() || g:IsMacNeovim() || g:IsWsl()
	function! s:OpenTentask()
		if fnamemodify(expand('%'), ':t') == "01_ver01.txt.shd"
			execute ":VoomQuitAll"
		endif

		if expand("%") != "tenTask.txt" && bufnr('tenTask.txt') == -1
			execute ":silent! e ~/repos/changelog/tenTask.txt"
		endif

		if bufnr('tenTask.txt') != -1
			execute ":silent! buffer repos/changelog/tenTask.txt"
			execute ":silent! e %"
		endif

		" 現在のバッファの総行数を取得
		let l:total_lines = line('$')

		" 最後から30行前に移動する行数を計算
		let l:start_line = l:total_lines > 30 ? l:total_lines - 29 : 1

		" 指定された範囲のテキストを取得
		let l:lines = getline(l:start_line, '$')
		" l:linesを文字列に連結
		let l:lines = join(l:lines, " ")

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
	command! OpenChangelog call <SID>OpenChangelog()
	nnoremap <silent> ,l <ESC>:OpenChangelog<CR>:set showtabline=2<CR>
	nnoremap <silent> ,L <ESC>:OpenChangelog<CR><C-home>o<CR>i<C-r>=neosnippet#expand('cpw')<CR>

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

	let g:tabpagebuffer#command#bdelete_keeptabpage = 1

	inoremap <silent><C-g> <Esc>:wa<CR>

	" 単語削除
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
	command! RemoveContextWord call s:RemoveContextWord() 
	inoremap <silent> <expr> <C-w> <SID>RemoveContextWord()

	nnoremap <silent> <ESC><ESC> :nohlsearch<CR><ESC>
endif

"}}}1

" 2024/12/31 まで使わなかったら削除 {{{1
" if g:IsWindowsGvim()
" 	set backupdir=$HOME/time_backup
"
" 	nnoremap <silent> ,rr :source c:/takeda/tools/vim/vimrc<CR>:source c:/takeda/tools/vim/gvimrc<CR>
" 	nnoremap <silent> ,RR :Restart<CR>
"
" 	function! s:OpenChangelog()
" 		if expand("%") != "changelogmemo"
" 			execute ":e c:/takeda/repos/changelog/changelogmemo"
" 		endif
" 	endfunction
" 	command! OpenChangelog call <SID>OpenChangelog()
" 	nnoremap <silent> ,c <ESC>:OpenChangelog<CR>
"
" 	function! s:OpenTentask()
" 		if expand("%") != "tenTask.txt" && bufnr('tenTask.txt') == -1
" 			execute ":e c:/takeda/repos/changelog/tenTask.txt"
" 		endif
"
" 		call append("$", ['----- '.strftime('%Y-%m-%d %H:%M:%S'), '・'])
" 		exe "normal! GkA"
" 		redraw
" 	endfunction
" 	command! OpenTentask call <SID>OpenTentask()
" 	nnoremap <silent> ,c <ESC>:OpenChangelog<CR>
" 	nnoremap <silent> ,l :buffer changelogmemo<CR><C-home>o<CR>a<C-r>=neosnippet#expand('cpw')<CR>
" 	nnoremap <silent> ,L :buffer changelogmemo<CR><C-home>o<CR>a<C-r>=neosnippet#expand('cpwd')<CR>
"
" 	function! s:OpenTentask()
" 		if expand("%") != "tenTask.txt" && bufnr('tenTask.txt') == -1
" 			execute ":e c:/takeda/repos/changelog/tentask.txt"
" 		endif
"
" 		if bufnr('tenTask.txt') != -1
" 			execute ":buffer c:/takeda/repos/changelog/tentask.txt"
" 		endif
"
" 		call append("$", ['----- '.strftime('%Y-%m-%d %H:%M:%S'), '・'])
" 		exe "normal! GkA"
"
" 	endfunction
" 	command! OpenTentask call <SID>OpenTentask()
" 	nnoremap <silent> ,t :OpenTentask<CR>GA
"
" 	function! s:OpenOnlyTentask()
" 		if expand("%") != "tenTask.txt" && bufnr('tenTask.txt') == -1
" 			execute ":e c:/takeda/repos/changelog/tentask.txt"
" 		endif
"
" 		if bufnr('tenTask.txt') != -1
" 			execute ":buffer c:/takeda/repos/changelog/tentask.txt"
" 		endif
"
" 		exe "normal! Gz+"
" 		redraw
" 	endfunction
" 	command! OpenOnlyTentask call <SID>OpenOnlyTentask()
" 	nnoremap <silent> ,T :OpenOnlyTentask<CR>
"
" 	" TODO: use noremap!
" 	" imap <C-b> <Left>
" 	" imap <C-f> <Right>
" 	" imap <C-p> <Up>
" 	" imap <C-n> <Down>
" 	" imap <C-a> <C-o>
" 	" imap <C-e> <C-o>$
"
" 	cnoremap <C-b> <Left>
" 	cnoremap <C-f> <Right>
" 	cnoremap <C-a> <Home>
" 	cnoremap <C-e> <End>
" 	inoremap <C-f> ／
" 	inoremap <C-x><C-x> ？／
" 	cnoremap <C-f> ／
" 	inoremap <C-b> →
" 	" nnoremap <C-Tab> 0i	
" 	" nnoremap <S-Tab> 0x
"   nnoremap <silent>H 10h
"   nnoremap <silent>J 5gj
"   nnoremap <silent>K 5gk
"   nmap <silent>K 5gk
"   nnoremap <silent>L 10l
"
"
" endif
" }}}1

" init.vimから移動されたキーバインド設定 {{{1
" 基本的な編集操作
nnoremap M %
nnoremap <silent> <C-d> dd
nnoremap dp dip
nnoremap d<C-w> diw
nnoremap c<C-w> ciw
nnoremap dW daw
nnoremap cW ciW
nnoremap dW viwd
nnoremap d" di"
nnoremap c" ci"
nnoremap D" da"
nnoremap d' di'
nnoremap c' ci'
nnoremap D' da'
nnoremap d( di()
nnoremap c( ci(
nnoremap D( da()
nnoremap y" yi"
nnoremap y' yi'
nnoremap yw yiw
nnoremap yW yiW
nnoremap v<C-w> viw
nnoremap vW viW
nnoremap v" vi"
nnoremap v' vi'
nnoremap v( vi(
nmap dk dib
nmap ck cib
nmap dK dab
" }}}1
