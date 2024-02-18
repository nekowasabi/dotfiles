" 簡単終了 {{{1
command! -nargs=0 QC call CloseQuickRunWindow()
function! CloseQuickRunWindow()
    execute "normal \<c-c>\<c-w>\<C-w>ZZ"
endfunction
nnoremap <Leader>q :call CloseQuickRunWindow()<CR>

" 指定のウインドウを閉じる
nnoremap <C-h> :<C-u>CloseSomeWindow
\	(index(['qf','unite','dbout'], getwinvar(v:val,'&filetype')) != -1)
\		\|\| (getwinvar(v:val, '&filetype') ==# 'help'
\		\|\| (getwinvar(v:val, '&filetype') ==# 'httpRequest'
\		\|\| (getwinvar(v:val, '&filetype') ==# 'dbout'
\			&& !getwinvar(v:val, '&modifiable'))<CR>


command! -nargs=0 QC call QuickExit()
function! QuickExit()
	execute "wqall!"
endfunction
nnoremap <Leader>Q :call QuickExit()<CR>
" }}}1

if g:IsMacGvim()
  " Change Ime off status {{{1
  function! s:ImeOff()
    let g:IMState = 0
  endfunction
  command! ImeOff call <SID>ImeOff()
  " }}}1
  inoremap <silent><C-g> <C-o>:ImeOff<CR>
  nnoremap <silent> i :ImeOff<CR>i
  nnoremap <silent> a :ImeOff<CR>a
  nnoremap <silent> A :ImeOff<CR>A
  nnoremap <silent> o :ImeOff<CR>o
  nnoremap <silent> O :ImeOff<CR>O
endif

" ・や「」を文脈に応じて行複製する {{{1
function! s:DuplicateLineFormat()
	let line = getline('.')

	if line =~ "^[\t　]*・" 
		return "\<End>\n・"
	endif
	if line =~ "^[\t　]*→" 
		return "\<End>\n→"
	endif
	if line =~ "^「"
		return "\<End>\n「」\<Left>"
	endif
	if line =~ "^[\t　]*\\* "
		return "\<End>\n\* "
	end
	if line =~ "^[\t　]*\+ "
		return "\<End>\n+ "
	end
	if line =~ "^[\t　]*\- "
		return "\<End>\n- "
	end
	return  ''
endfunction
function! s:DuplicateLineFormatNormal()
	let line = getline('.')

	if line =~  "^[\t　]*・" 
	 	exe 'norm! A'."\n".'・'
		let g:IMState = 2
		exe 'normal A'
	endif
endfunction
command! DuplicateLineFormat call <SID>DuplicateLineFormat()
command! DuplicateLineFormatNormal call <SID>DuplicateLineFormatNormal()
" }}}1
if g:IsMacGvim() || g:IsMacNeovim()
  nnoremap <silent> <F4> :DuplicateLineFormatNormal<CR>
  inoremap <expr> <F4> <SID>DuplicateLineFormat()
endif
if g:IsWindowsGvim()
  nnoremap <silent> <F4> :DuplicateLineFormatNormal<CR>
  inoremap <expr> <C-o> <SID>DuplicateLineFormat()
endif

 "ビジュアルモードで選択中のテクストを取得する {{{
function! s:get_visual_text()
    try
        " ビジュアルモードの選択開始/終了位置を取得
        let pos = getpos('')
        normal `<
        let start_line = line('.')
        let start_col = col('.')
        normal `>
        let end_line = line('.')
        let end_col = col('.')
        call setpos('.', pos)

        let tmp = @@
        silent normal gvy
        let selected = @@
        let @@ = tmp
        return selected
    catch
        return ''
    endtry
endfunction
" }}}

" plantumlのマインドマップを開く
function! s:OpenMindMap()
  exe "WriteToFile ~/aaa.md"
  exe "e ~/aaa.md"
	call append(0, "```plantuml")
	call append("$", "```")
	exe "write!"
  exe "PrevimOpen"
	exe "bdelete!"
endfunction

command! -range -nargs=1 WriteToFile '<,'>write! <args>

command! -range OpenMindMap call s:OpenMindMap() 


" hugo {{{1
function! s:HugoGeneratePost()
  let s:path = ''
	if g:IsMacGvim()
    let s:path = '/Users/takets/Dropbox/files/blog/'
    cd /Users/takets/Dropbox/files/blog/
	endif
	if g:IsWindowsGvim()
    let s:path = 'g:/dropbox/files/blog/'
    cd g:/dropbox/files/blog/
	endif
  let s:markdown = input("file name > ", strftime("%Y%m%d%H%M")."_ss.md")
  redraw
  if s:markdown == ''
    return
  endif
  execute "!hugo new post/".s:markdown
  execute ":e ".s:path.'content/post/'.s:markdown

endfunction

command! HugoGeneratePost call s:HugoGeneratePost() 

function! s:HugoRunServer()
	if g:IsMacGvim()
		cd /Users/takets/Dropbox/files/blog/
	endif
	if g:IsWindowsGvim()
		cd g:/dropbox/files/blog
	endif
  execute "OpenBrowser localhost:1313"
  execute "!hugo server --buildDrafts --watch"
endfunction

command! HugoRunServer call s:HugoRunServer() 

function! s:HugoDeploy()
	if g:IsMacGvim()
		cd /Users/takets/Dropbox/files/blog/
	endif
	if g:IsWindowsGvim()
		cd g:/dropbox/files/blog
	endif
  execute "!./deploy.sh"
endfunction

command! DeployHugo call s:DeployHugo() 
" }}}1

" changelogメモの項目を一番上に移動する
function! s:MoveChangelogItemToTop()
    execute "normal! zR"
	let txt = MoveSectionToTop()
	call append(2, txt)
	" execute "normal! z0"
endfunction
command! -range MoveChangelogItemToTop call s:MoveChangelogItemToTop() 
nnoremap <silent> ,C :MoveChangelogItemToTop<CR>

function! MoveSectionToTop()
    let current_section = []
    let cursor_position = getpos('.')
    let pattern = '^\* \zs.*\ze\(\s\[\w*\]:\)*$'
    let pattern_datetime_header = '^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]  takets.*$'
    
    " Check if the current line matches the header format
    if getline('.') !~ pattern
        echo "Current line is not a header."
        return current_section
    endif

    " Save the header line
    call add(current_section, getline('.'))

    " Move to the next line
    normal! j

    " Collect lines until the next header is found or the end of the buffer
    while getline('.') !~ pattern &&  getline('.') !~ pattern_datetime_header
        call add(current_section, getline('.'))
        " Delete the current line
        execute "normal! dd"
    endwhile

    " Delete the header line
    call setpos('.', cursor_position)
    execute "normal! dd"

    " Restore the cursor position
    call setpos('.', cursor_position)

		return current_section
endfunction

" Dropboxのwatchmemoをバッファに出力して、ファイル削除
function! s:PasteWatchMemo()
  if g:IsMacGvim() || g:IsMacNeovim()
    let g:dropbox_dir = '/Users/takets/Library/CloudStorage/Dropbox/files/'
  endif
  if g:IsWindowsGvim()
    let g:dropbox_dir = 'g:/dropbox/files/'
  endif

	let files = glob(g:dropbox_dir . "/watchmemo/*.doc", 0, 1)

	let content = ''

	for file in files
		" 以下の条件はユーザー定義の関数が存在することを前提としています。
		if g:IsMacGvim() || g:IsMacNeovim()
			let content = readfile(file)->join("\n") . "\n"  " Macの現代のテキストフォーマットに合わせてLFを使用
			" let content = substitute(content, "\n", "\r", 'g')  " この行は不要であれば削除してください
			execute "normal! i" . content
			" silent execute "!rm " . file  " 実際にファイルを削除する場合はコメントを解除してください
		endif
		if g:IsWindowsGvim()
			let content = readfile(file)->join("\r\n") . "\r\n"  " Windowsのテキストフォーマットに合わせてCRLFを使用
			let content = substitute(content, "\r\n\r\n", "\r\n", 'g')
			execute "normal! i" . content
			silent execute "!del " . file
		endif
	endfor
	" for file in files
 "    if g:IsMacGvim() || g:IsMacNeovim()
 "      let content = readfile(file)->join("\r") . "\r"
 "      " let content = substitute(content, "", "\r", 'g')
 "      execute "normal! i" . content
 "      " silent execute "!rm " . file
 "    endif
 "    if g:IsWindowsGvim()
 "      let content = readfile(file)->join("\r") . "\r"
 "      let content = substitute(content, "", "\r", 'g')
 "      execute "normal! i" . content
 "      silent execute "!del " . file
 "    endif
	" endfor
endfunction

command! -range PasteWatchMemo call s:PasteWatchMemo() 


" changelogをpull
function! s:PullChangelog()
  execute "cd ".g:GetChangelogDirectory()
  execute "Git pull"
endfunction

command! -range PullChangelog call s:PullChangelog() 

" changelogをgitに更新
function! s:PushChangelog()
  execute "cd ".g:GetChangelogDirectory()
  execute "Git add ."
  execute "Git commit -m 'update.'"
  execute "Git push"
endfunction

command! -range PushChangelog call s:PushChangelog() 

" -----------------------------------------------------------
" test
function! s:Test()
endfunction

command! -range Test call s:Test() 
nnoremap <silent> <F2> :Test<CR>
vnoremap <silent> <F2> :Test<CR>

function! SendCommandToTerminalWindows()
    " すべてのウィンドウをループ
    for win_id in range(1, winnr('$'))
        " ウィンドウのバッファ番号を取得
        let bufnr = winbufnr(win_id)
        " バッファタイプを確認
        if getbufvar(bufnr, '&buftype') ==# 'terminal'
            " ターミナルバッファのジョブIDを取得
            let job_id = getbufvar(bufnr, 'terminal_job_id')
            if job_id != 0
                " ターミナルにコマンドを送信
                call jobsend(job_id, "echo 'Hello from terminal two'\n")
            endif
        endif
    endfor
endfunction
