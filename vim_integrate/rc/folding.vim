" general {{{1
set foldmethod=marker
set foldcolumn=0
set foldtext=FoldCCtext()
set fillchars=vert:\|
set fillchars=

let g:fold_mark = ""

let g:foldCCtext_maxchars = 500
let g:foldCCtext_head = 'printf("%s%s",
			\ repeat("", v:foldlevel), repeat("  ", v:foldlevel).repeat(g:fold_mark, v:foldlevel))'
let g:foldCCtext_tail = 'printf(" [%4d line]",
			\ v:foldend-v:foldstart+1)'

autocmd BufRead,BufNewFile *.{shd} setfiletype shd|setlocal commentstring=%s
autocmd BufRead,BufNewFile changelogmemo setfiletype changelog|setlocal commentstring=%s
autocmd BufRead,BufNewFile * redraw

" " Save fold settings.
" autocmd BufWritePost * if expand('%') != '' && &buftype !~ 'nofile' | mkview | endif
" autocmd BufRead * if expand('%') != '' && &buftype !~ 'nofile' | silent loadview | endif
" " Don't save options.
" set viewoptions-=options

" }}}1

" 選択範囲をfoldingで囲む
let g:surround_{char2nr("s")} = "\r {{{1\n\n}}}1"

" toggle folding
nnoremap <silent> <D-f> za
nnoremap <silent> zz za

" カーソルがあるところ以外を折り畳む
nnoremap <silent>z<C-f>    zMzv
" 現在の折り畳みを閉じて、他の折り畳みをすべて閉じる
nnoremap <silent>Z<C-f>    zMzvzc
" すべてを折り畳む
nnoremap <silent>zC    zRggvGzc
" 現在の折り畳み以外を閉じる
" nnoremap <silent>z0    :<C-u>set foldlevel=<C-r>=foldlevel('.')<CR><CR>

" 親に遡っていい感じに折り畳みを閉じる {{{1
function! s:smart_foldcloser()
		if foldlevel('.') == 0
				norm! zM
				return
		endif

		let foldc_lnum = foldclosed('.')
		norm! zc
		if foldc_lnum == -1
				return
		endif

		if foldclosed('.') != foldc_lnum
				return
		endif
		norm! zM
endfunction
command! -nargs=1 -complete=file Rename f <args>|call delete(expand('#'))
" }}}1
" nnoremap <silent><C-]> :<C-u>call <SID>smart_foldcloser()<CR>

" fold one line {{{1
function! s:put_foldmarker(foldclose_p)
  let line = getline('.')
  let start_line = line('.')
	let markdown_header = '# '.line
	call setline(start_line, markdown_header)

	let tab = matchstr(line, '^[\t]*')

	let level = 1
	if len(tab) == 2
		let level = 2
	elseif len(tab) == 4
		let level = 3
	endif

	if 6 <= len(tab)
		let level = len(tab) -2
	endif

  let padding = line=='' ? '' : line=~'\s$' ? '' : ' '
	if level == 1
		let fmr = split(&fmr, ',')[0]. (v:count ? v:count : '1')."\n\n".split(&fmr, ',')[1]. (v:count ? v:count : '1')
	else
		let fmr = split(&fmr, ',')[0]. level."\n".repeat("a\<Bs>", level)."\n".split(&fmr, ',')[1]. level
	endif
  exe 'norm! A'. padding. fmr
endfunction
nnoremap <silent> zl :<C-u>call <SID>put_foldmarker(0)<CR>za
" }}}1

" " fold one line text {{{1
" function! s:put_foldmarker_text2(foldclose_p)
"   let crrstr = getline('.')
"   let padding = crrstr=='' ? '' : crrstr=~'\s$' ? '' : ' '
"   let fmr = split(&fmr, ',')[0]."{". (v:count ? v:count : '1')."\n\n".split(&fmr, ',')[1]."}". (v:count ? v:count : '1')
"   exe 'norm! A'. padding. fmr
" endfunction
" " }}}1
" nnoremap <silent> zL :<C-u>call <SID>put_foldmarker_text2(0)<CR>za

" outlinerのzoom機能 PartEditを使用 {{{1
function! s:ZoomOutliner()
	if @% !~ "^.*#.*"
		execute "normal vizZP"
		execute "normal zR"
	else
		execute "normal :w\<Esc>"
		execute "normal ZPEzc"
	endif
endfunction
command! ZoomOutliner call <SID>ZoomOutliner()
xnoremap <Leader>pe :Partedit<CR>
xnoremap ZP :Partedit<CR>
nnoremap ZPE :<C-U>ParteditEnd<CR>
" }}}1
" zoomする and zoom解除
nnoremap <D-z> :ZoomOutliner<CR>

" " foldingの階層変更 {{{1
" function! s:IncrementFolding()
"   execute "normal lzozc0vZU"
"   execute "normal! \<Esc>"
"   execute "normal za"
" endfunction
" command! IncFolding call s:IncrementFolding() 
" 
" function! s:DecrementFolding()
"   execute "normal lzozcvZD"
"   execute "normal! \<Esc>"
"   execute "normal zc"
" endfunction
" command! DecFolding call s:DecrementFolding()
" 
" function! s:IncrementFolding2()
"   let l = getline('.')
" 	let level = substitute(matchstr(l, '{{{[0-9]'), "{{{", "", "") 
" 
" 	if l =~ '{{{[0-9]'
" 		execute "normal lmt"
" 	elseif l =~ '}}}[0-9]'
" 		execute "normal lmt0F{"
" 	else
" 		execute "normal lmtF{"
" 	endif
" 
" 	" インデントを維持するために、空行の場合は適当な文字を挿入
" 	if level == 1
" 		silent exe "normal! j"
" 		if getline('.') == ""
" 			silent exe "normal! dd"
" 		endif
" 		silent execute "normal zcv2>zkzo"
" 	else
" 		silent execute "normal zcv2>zkzo"
" 	endif
" 
"   silent execute "normal! \<Esc>"
"   silent execute "normal! mtzc"
" endfunction
" command! IncFolding2 call s:IncrementFolding2() 
" 
" function! s:DecrementFolding2()
"   " silent execute "normal  wmtf}viz<f}viz<vizZDZD`t"
"   silent execute "normal  zozcv2<zcvZD"
"   execute "normal!  \<Esc>"
"   silent execute "normal! zc"
" endfunction
" command! DecFolding2 call s:DecrementFolding2()
" 
" vmap ZU <Plug>ChalkUp
" vmap ZU <Plug>ChalkDown
" xmap ZU <Plug>ChalkUp
" xmap ZD <Plug>ChalkDown
" 
" " }}}1

function! s:IncrementFoldingMarkdownHeader()

  let saved_cursor = getpos('.')

  " カーソル位置から次の "}}}" までを対象とする
	call search('}}}', "W")

  " 対象範囲の終了行番号を取得
  let saved_end_cursor = getpos('.')
  let end_line = line('.')

  call setpos('.', saved_cursor)
	let start_line = line('.')

	" markdownのヘッダをインクリメント
	let line = getline('.')
	let markdown_header = '#'.line
	call setline(start_line, markdown_header)

	" {{{[0-9]をインクリメント
  let line = getline('.')
  let regex = '.*\(\d\+\)'
  let number = substitute(line, regex, '\1', '')
	let new_number = number + 1
	let new_folding_level = '{{{' . new_number
	let new_line = substitute(line, "{{{[0-9]", new_folding_level, '')
	call setline(start_line, new_line)

	" }}}[0-9]をインクリメント
  call setpos('.', saved_end_cursor)
	let end_line = line('.')
  let line = getline('.')
  let regex = '.*\(\d\+\)'
  let number = substitute(line, regex, '\1', '')
	let new_number = number + 1
	let new_folding_level = '}}}' . new_number

	let new_line = substitute(line, "}}}[0-9]", new_folding_level, '')
	call setline(end_line, new_line)
  call setpos('.', saved_cursor)
endfunction
command! IncFolding call s:IncrementFoldingMarkdownHeader()

function! s:DecrementFoldingMarkdownHeader()

  let saved_cursor = getpos('.')

  " カーソル位置から次の "}}}" までを対象とする
	call search('}}}', "W")

  " 対象範囲の終了行番号を取得
  let saved_end_cursor = getpos('.')
  let end_line = line('.')

  call setpos('.', saved_cursor)
	let start_line = line('.')

	" markdownのヘッダをインクリメント
	let line = getline('.')
	let markdown_header = strpart(line, 1)
	call setline(start_line, markdown_header)

	" {{{[0-9]をインクリメント
  let line = getline('.')
  let regex = '.*\(\d\+\)'
  let number = substitute(line, regex, '\1', '')
	let new_number = number - 1
	let new_folding_level = '{{{' . new_number
	let new_line = substitute(line, "{{{[0-9]", new_folding_level, '')
	call setline(start_line, new_line)

	" }}}[0-9]をインクリメント
  call setpos('.', saved_end_cursor)
	let end_line = line('.')
  let line = getline('.')
  let regex = '.*\(\d\+\)'
  let number = substitute(line, regex, '\1', '')
	let new_number = number - 1
	let new_folding_level = '}}}' . new_number

	let new_line = substitute(line, "}}}[0-9]", new_folding_level, '')
	call setline(end_line, new_line)
  call setpos('.', saved_cursor)
endfunction
command! DecFolding call s:DecrementFoldingMarkdownHeader()

" foldingの階層をインクリメント・デクリメント
nnoremap <silent> zk :IncFolding<CR>
nnoremap <silent> zj :DecFolding<CR>
" " iterm
" nnoremap <silent> <C-x>. :IncFolding2<CR>
" nnoremap <silent> <C-x>, :DecFolding2<CR>

" let g:fold_cycle_default_mapping = 0 "disable default mappings
" nmap <Tab><Tab> <Plug>(fold-cycle-open)
" nmap <S-Tab><S-Tab> <Plug>(fold-cycle-close)

" foldingの階層構造のみ表示
function! s:ShowFoldingHeading()
	exe "normal! ?{{{1\<CR>"
	call fold_cycle#close_all()
	exe "normal! za"
endfunction
command! ShowFoldingHeading call s:ShowFoldingHeading() 
" nnoremap <silent> <F3> :ShowFoldingHeading<CR>

" アウトラインを移動
function! s:MoveDownFolding()
  silent execute "normal  zcddpzc"
  " silent execute "normal  v1]e"
  execute "normal!  \<Esc>"
endfunction
command! MoveDownFolding call s:MoveDownFolding()

function! s:MoveUpFolding()
  silent execute "normal  v1[e"
  execute "normal!  \<Esc>"
endfunction
command! MoveUpFolding call s:MoveUpFolding()


nnoremap <silent> zd :MoveDownFolding<CR>
nnoremap <silent> zu :MoveUpFolding<CR>

" ファイルタイプがmarkdownであるときだけ実行

function! MarkdownSetupFolds()
  setlocal foldmethod=expr
  setlocal foldexpr=s:MarkdownFoldExpr(v:lnum)
	setlocal foldlevel=2
	let v:folddashes = ''
endfunction

function! s:MarkdownFoldExpr(lnum)
	let this_line = getline(a:lnum)
	let next_line = getline(a:lnum + 1)
	" echo '^#\{'. (len(matchstr(this_line, '#\+')) ) .',} '

	" 見出し行を確認
	if this_line =~ '^#\+ '
		" 次の行が同じまたは大きいレベルの見出しでない場合、この行から次の空行までをフォールドする
		if next_line !~ '^#\{'. (len(matchstr(this_line, '#\+')) ) .',}¥+ ' && next_line =~ '\S'
			return '>1'
		endif

		" そうでない場合、この行は独立した見出しとなる
		return '>1'
	endif

	" 空行でないか、次の行が新しい見出しであればフォールドを続ける
	if this_line =~ '\S' && next_line !~ '^#\{'. (len(matchstr(getline(a:lnum - 1), '#\+')) + 1) .',}¥+ '
		return '1'
	endif

	" それ以外はフォールディングしない
	return '='
endfunction

" END
