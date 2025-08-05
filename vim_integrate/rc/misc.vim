"A Neovim plugin that allows one to quickly create, navigate to, and edit subfiles which are integrated into a main file. This way, a codebase becomes more modular and easier to manage. 簡単終了 {{{0
command! -nargs=0 QC call CloseQuickRunWindow()
function! CloseQuickRunWindow()
  " 全てのバッファを取得
  let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val)')

  " term://で始まるバッファを削除
  for buf in buffers
    if bufname(buf) =~ '^kulala://ui'
      silent! execute 'bdelete! ' . buf
    endif
  endfor
	" execute "normal \<c-c>\<c-w>\<C-w>ZZ"

endfunction

nnoremap <silent> <Leader>q :call CloseQuickRunWindow()<CR>

" 指定のウインドウを閉じる
nnoremap <C-h> :<C-u>CloseSomeWindow
\	(index(['qf','unite','dbout', 'ui'], getwinvar(v:val,'&filetype')) != -1)
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

" Change Ime off status {{{1
if g:IsMacGvim()
  function! s:ImeOff()
    let g:IMState = 0
  endfunction
  command! ImeOff call <SID>ImeOff()
  inoremap <silent><C-g> <C-o>:ImeOff<CR>
  nnoremap <silent> i :ImeOff<CR>i
  nnoremap <silent> a :ImeOff<CR>a
  nnoremap <silent> A :ImeOff<CR>A
  nnoremap <silent> o :ImeOff<CR>o
  nnoremap <silent> O :ImeOff<CR>O
endif
" }}}1

" ・や「」を文脈に応じて行複製する {{{1
function! s:DuplicateLineFormat()
	let line = getline('.')

	if line =~ "^[\t　 ]*- \\[ \\] " 
		return "\<End>\n- [ ] "
	endif
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
	if line =~ "^[\t　]*→" 
		return "\<End>\n→"
	endif
	if line =~ "^[\t　]*\+ "
		return "\<End>\n+ "
	end
	if line =~ "^[\t　 ]*\- "
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
if g:IsMacGvim() || g:IsMacNeovim() || g:IsWsl()
  nnoremap <silent> <F4> :DuplicateLineFormatNormal<CR>
  inoremap <expr> <F4> <SID>DuplicateLineFormat()
  inoremap <expr> <C-o> <SID>DuplicateLineFormat()
endif
if g:IsWindowsGvim()
  nnoremap <silent> <F4> :DuplicateLineFormatNormal<CR>
  inoremap <expr> <C-o> <SID>DuplicateLineFormat()
endif
" }}}1

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

 " plantumlのマインドマップを開く {{{1
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
" }}}1

" hugo {{{1
function! s:HugoGeneratePost()
  let s:path = ''
	if g:IsMacGvim() || g:IsMacNeovimInWezterm()
    let s:path = '/Users/takets/Dropbox/files/blog/'
    cd /Users/takets/Dropbox/files/blog/
	endif
	if g:IsWindowsGvim()
    let s:path = 'g:/dropbox/files/blog/'
    cd g:/dropbox/files/blog/
	endif
  if g:IsWsl()
    let s:path = '/home/takets/words/blog/'
    cd /home/takets/words/blog/
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
nnoremap <silent> ,Hg :HugoGeneratePost<CR>

function! s:HugoRunServer()
	if g:IsMacGvim()
		cd /Users/takets/Dropbox/files/blog/
	endif
	if g:IsWindowsGvim()
		cd g:/dropbox/files/blog
	endif
  if g:IsWsl()
    let s:path = '/home/takets/words/blog'
    cd /home/takets/words/blog/
  endif

  execute "OpenBrowser localhost:1313"
  execute "!hugo server --buildDrafts --watch"
endfunction

command! HugoRunServer call s:HugoRunServer() 
nnoremap <silent> ,Hr :HugoRunServer<CR>

function! s:HugoDeploy()
	if g:IsMacNeovim() || g:IsMacNeovimInWezterm()
		let cmd = '/Users/takets/Dropbox/files/blog/deploy.sh'
    execute "terminal ".cmd
	endif
	if g:IsWindowsGvim()
		cd g:/dropbox/files/blog
	endif
  if g:IsWsl()
		let cmd = '/home/takets/words/blog/deploy.sh'
    execute "terminal ".cmd
  endif
endfunction

command! HugoDeploy call s:HugoDeploy() 
nnoremap <silent> ,Hd :HugoDeploy<CR>
" }}}1

" changelogメモの項目を一番上に移動する {{{1
function! s:MoveChangelogItemToTop()
    execute "normal! zR"
	let txt = MoveSectionToTop()
	call append(2, txt)
  call feedkeys("ggzC")
	" execute "normal! z0"
endfunction
command! -range MoveChangelogItemToTop call s:MoveChangelogItemToTop() 
nnoremap ,C :MoveChangelogItemToTop<CR>

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
" }}}1

" iPhoneショートカットでメモした内容をchangelogに貼り付け {{{1
function! s:PasteWatchMemo()
  if g:IsMacNeovimInWork()
    let g:shortcuts_dir = '/Users/ttakeda/repos/changelog/'
  elseif g:IsWsl()
    let g:shortcuts_dir = '/home/takets/repos/changelog/'
	else
    let g:shortcuts_dir = '/Users/takets/repos/changelog/'
  endif

	let files = glob(g:shortcuts_dir . "shortcuts/*.md", 0, 1)

  " ファイルが存在しない場合は処理を終了
  if empty(files)
    return
  endif

  let l:header = '* 音声入力メモ' . strftime("%Y-%m-%d %H:%M") . '  takets [idea]:'
  call append(2, l:header)

	let current_line = 4

	for file in files
		let content = readfile(file)
		call append(current_line - 1, content)
		let current_line = current_line + len(content)
		silent execute "!rm " . shellescape(file)
	endfor
endfunction
command! -range PasteWatchMemo call s:PasteWatchMemo() 
" }}}1

" changelogをpush, pullする {{{1
function! s:PullChangelog()
  execute "cd ".g:GetChangelogDirectory()
  let checkout_result = system("git checkout -f")
  if v:shell_error != 0
    echoerr 'git checkout failed: ' . checkout_result
    return
  endif
  let pull_result = system("git pull")
  if v:shell_error != 0
    echoerr 'git pull failed: ' . pull_result
    return
  endif
	execute "PasteWatchMemo"
  echo 'pull done.'
endfunction
command! -range PullChangelog call s:PullChangelog()

function! s:PushChangelog()
  execute "cd ".g:GetChangelogDirectory()
  call system("git add .")
  call system("git commit -m 'update.'")
  call system("git push")
  execute "silent :e %"
  echo 'push done'
endfunction
command! -range PushChangelog call s:PushChangelog() 
nnoremap <silent> ,p :PushChangelog<CR>
" }}}1

" OpenByCursor {{{1
function! s:OpenByCursor()
  let l:path = expand('%:p')
  let l:line = line('.')
  " コマンド実行結果を表示することなく実行
  silent! exe '!cursor --g '.l:path.':'.l:line
endfunction
command! -range Cursor call s:OpenByCursor()
" }}}1

" OpenByVscode {{{1
function! s:OpenByVscode()
  let l:path = expand('%:p')
  let l:line = line('.')
  " コマンド実行結果を表示することなく実行
  silent! exe '!code --g '.l:path.':'.l:line
endfunction
command! -range VSCode call s:OpenByVscode()
" }}}1

" テキスト用リンクジャンプ {{{1
function! s:GenerateTextLinkTag()
	let l:link_hash = GenerateRandomString(8)

  let l:full_path = expand('%:p')
  let l:home_dir = expand('~')
  if l:full_path =~ '^' . l:home_dir
    let l:current_path = '~' . strpart(l:full_path, len(l:home_dir))
  else
    let l:current_path = l:full_path
  endif

	let l:link = "[link](" . l:current_path . "#" . l:link_hash . ")"
	let pos = getpos(".")
	execute ":normal a" . l:link
	call setpos('.', pos)
	" 構文ハイライトを更新
	syntax sync fromstart
	redraw
endfunction
command! GenerateTextLinkTag call s:GenerateTextLinkTag() 
command! -range GenerateTextLinkTag call s:GenerateTextLinkTag() 

function! GenerateRandomString(length)
    let l:chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    let l:result = ''
    for i in range(a:length)
        let l:result .= l:chars[rand() % len(l:chars)]
    endfor
    return l:result
endfunction

function! s:JumpHashLink()
	let l:line = getline('.')
	let l:link = matchstr(l:line, '\[.*\](.*)')

  if l:link != ''
    " カーソル行から、[link](/path/to/file#hash) 形式の()内の文字列を取得
    let l:location = matchstr(l:line, '\[.*\](\zs.*\ze)')
    let l:location_list = split(l:location, '#')

    let l:file_path = l:location_list[0]
    let l:absolute_path = fnamemodify(l:file_path, ':p')

    let l:hash = l:location_list[1]

    if expand('%:p') != l:absolute_path
      execute "e " . l:file_path
      call cursor(1, 1)
    endif

		let l:save_cursor = getpos(".")
		
    normal! j
		
    let l:search_result = search(l:hash, 'W')
		
		if l:search_result == 0
			" 見つからなかった場合はファイルの先頭から現在位置まで検索
			call cursor(1, 1)
      let l:search_result = search(l:hash, 'W', l:save_cursor[1])
    else
		endif
	else
		let l:cword = expand("<cword>")
		call feedkeys("*", 'n')
	endif
endfunction

command! JumpHashLink call s:JumpHashLink() 
command! -range JumpHashLink call s:JumpHashLink() 
nnoremap <silent> * :JumpHashLink<CR>
" }}}1

" ヤンクした内容を、カーソルの単語に対してファイル全体で置換 {{{1
function! ReplaceCurrentWordWithYank()
    " ヤンクした内容をデフォルトのレジスタから取得
    let l:yanked = @"

    " 現在のカーソル下の単語を取得
    let l:current_word = expand('<cword>')

    " ファイル全体で置換
    execute '%s/\V'.escape(l:current_word, '/\').'/'.escape(l:yanked, '/\').''
endfunction


nnoremap <silent> ,rw :call ReplaceCurrentWordWithYank()<CR>
" }}}1

" -----------------------------------------------------------
function! s:Test() range
  " 選択範囲の全行を処理（a:firstlineからa:lastlineまで）
  for lnum in range(a:firstline, a:lastline)
    call s:ProcessLine(lnum)
  endfor
endfunction

function! s:ProcessLine(line_num)
  " 指定行のテキストを取得
  let l:line = getline(a:line_num)
  
  " フルパスのパターンマッチ（Unix/Windowsパス対応）
  let l:path_pattern = '\v(/[^[:space:]]+|[a-zA-Z]:\\[^[:space:]]+|\~[^[:space:]]+)'
  let l:match = matchstr(l:line, l:path_pattern)
  
  if l:match != ''
    " フルパスを取得
    let l:fullpath = expand(l:match)
    
    " ファイルが存在するか確認
    if !filereadable(l:fullpath)
      " ファイルが存在しない場合はスキップ
      return
    endif
    
    " ファイル名を変数に取得
    let l:filename = fnamemodify(l:fullpath, ':t')
    
    " フルパスをhome directoryからの相対パスに変換
    let l:home = expand('~')
    if l:fullpath =~ '^' . l:home
      let l:relpath = '~' . strpart(l:fullpath, len(l:home))
    else
      let l:relpath = l:fullpath
    endif
    
    " markdownリンクを生成 [ファイル名](相対パス)
    let l:markdown_link = '[' . l:filename . '](' . l:relpath . ')'
    
    " フルパスをmarkdownリンクに変換
    let l:new_line = substitute(l:line, escape(l:match, '/\'), l:markdown_link, '')
    call setline(a:line_num, l:new_line)
  endif
endfunction

command! -range -nargs=0 Test <line1>,<line2>call s:Test()

nnoremap <silent> <F2> :Test<CR>
vnoremap <silent> <F2> :Test<CR>
" }}}1

nnoremap x "_x
xnoremap x "_x
nnoremap X "_X
xnoremap X "_X
