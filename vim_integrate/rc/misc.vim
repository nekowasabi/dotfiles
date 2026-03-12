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
  inoremap <expr> <C-o> <SID>DuplicateLineFormat() . "\<C-r>=timer_start(50, {-> exists('*coc#refresh') && g:is_coc_enabled ? coc#refresh() : ''})\<CR>"
endif
if g:IsWindowsGvim()
  nnoremap <silent> <F4> :DuplicateLineFormatNormal<CR>
  inoremap <expr> <C-o> <SID>DuplicateLineFormat() . "\<C-r>=timer_start(50, {-> exists('*coc#refresh') && g:is_coc_enabled ? coc#refresh() : ''})\<CR>"
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
    silent execute "normal! zR"
	let txt = MoveSectionToTop()
	silent call append(2, txt)
  call feedkeys("ggzC")
endfunction
command! -range MoveChangelogItemToTop call s:MoveChangelogItemToTop()
nnoremap <silent> ,C :MoveChangelogItemToTop<CR>

function! MoveSectionToTop()
    let current_section = []
    let pattern = '^\* \zs.*\ze\(\s\[\w*\]:\)*$'
    let pattern_datetime_header = '^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]  takets.*$'

    " Check if the current line matches the header format
    if getline('.') !~ pattern
        " ヘッダ行でない場合、上方向に検索してヘッダ行を探す
        let header_line = search(pattern, 'bnW')
        if header_line == 0
            echo "セクションヘッダが見つかりません"
            return current_section
        endif
        " ヘッダ行にカーソルを移動
        call cursor(header_line, 1)
    endif

    let start_line = line('.')

    " 次の行から検索を開始するため、一時的に移動
    silent normal! j

    " 次のヘッダ行または日付ヘッダを検索して終了行を特定
    let next_header = search(pattern, 'nW')
    let next_date = search(pattern_datetime_header, 'nW')

    " カーソルを元のヘッダ行に戻す
    call cursor(start_line, 1)

    " 終了行を決定（見つからない場合はファイル末尾）
    if next_header == 0 && next_date == 0
        let end_line = line('$')
    elseif next_header == 0
        let end_line = next_date - 1
    elseif next_date == 0
        let end_line = next_header - 1
    else
        let end_line = min([next_header, next_date]) - 1
    endif

    " end_lineがstart_lineより小さい場合は、ヘッダ行のみ
    if end_line < start_line
        let end_line = start_line
    endif

    " セクションの内容を取得（一括）
    let current_section = getline(start_line, end_line)

    " セクションを一括削除
    silent execute start_line . ',' . end_line . 'delete _'

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

function! s:PushChangelogOnExit(job_id, exit_code, event) dict
  if a:exit_code == 0
    echomsg '✅ push done'
  else
    echohl ErrorMsg | echomsg '❌ push FAILED (exit=' . a:exit_code . ')' | echohl None
  endif
endfunction

function! s:PushChangelog()
  let l:dir = expand(g:GetChangelogDirectory())
  execute "cd " . l:dir
  let l:cmd = ['sh', '-c',
    \ 'cd ' . shellescape(l:dir)
    \ . ' && git add .'
    \ . ' && MSG=$(git diff --cached | env -u CLAUDECODE /opt/homebrew/bin/claude'
    \ . ' -p ' . shellescape('このgit diffから日本語でコミットメッセージを1行生成。形式: <type>: <内容>')
    \ . ' --model haiku --tools "" --no-session-persistence --output-format text)'
    \ . ' && git commit -m "$MSG"'
    \ . ' && git push'
    \ ]
  call jobstart(l:cmd, {'on_exit': function('s:PushChangelogOnExit')})
  echo 'pushing changelog...'
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

" 選択範囲のパスをMarkdownリンクに変換 {{{1
function! s:ConvertMarkdownLink() range
  " visual modeかどうかを判定
  let is_visual = (a:firstline != a:lastline) || (visualmode() != '')
  
  if is_visual
    " visual modeの場合は選択範囲のテキストを取得
    let selected_text = s:get_visual_text()
    
    if empty(selected_text)
      echo "テキストが選択されていません"
      return
    endif
    
    " テキストを行ごとに分割
    let lines = split(selected_text, '\n')
  else
    " normal modeの場合はカーソル行のみを処理
    let lines = [getline('.')]
  endif
  
  let result = []
  
  " ホームディレクトリのパスを取得
  let home_dir = expand('~')
  
  " 各行を処理
  for line in lines
    " ファイルパスのパターンを検出（/で始まるパス）
    if line =~ '/[^[:space:]]*'
      " パス部分を抽出
      let path_match = matchstr(line, '/[^[:space:]]*')
      
      if !empty(path_match)
        " ファイル名を取得（最後の/以降）
        let filename = fnamemodify(path_match, ':t')
        
        " フルパスを相対パスに変換
        let relative_path = path_match
        " ホームディレクトリのパスを取得
        let home = expand('~')
        " フルパスがホームディレクトリで始まる場合は ~ に置換
        if relative_path =~ '^' . home
          let relative_path = substitute(relative_path, '^' . home, '~', '')
        elseif relative_path =~ '^/Users/[^/]*/'
          " /Users/username/ を ~/ に置換（Mac用のフォールバック）
          let relative_path = substitute(relative_path, '^/Users/[^/]*/', '~/', '')
        elseif relative_path =~ '^/home/[^/]*/'
          " /home/username/ を ~/ に置換（Linux/WSL用のフォールバック）
          let relative_path = substitute(relative_path, '^/home/[^/]*/', '~/', '')
        endif
        
        " Markdown形式のリンクを作成
        let markdown_link = '- [' . filename . '](' . relative_path . ')'
        
        " 元の行でパスより前の部分を保持（インデントやリストマーカーなど）
        let prefix = substitute(line, path_match . '.*', '', '')
        
        " プレフィックスがリストマーカーを含む場合はそのまま使用、含まない場合は追加
        if prefix =~ '^\s*-\s*$'
          call add(result, prefix . '[' . filename . '](' . relative_path . ')')
        else
          call add(result, markdown_link)
        endif
      else
        " パスが含まれない行はそのまま
        call add(result, line)
      endif
    else
      " パスが含まれない行はそのまま
      call add(result, line)
    endif
  endfor
  
  " 結果を結合
  let output = join(result, "\n")
  
  if is_visual
    " visual modeの場合は選択範囲を結果で置換
    normal! gvd
    let @" = output
    normal! P
  else
    " normal modeの場合はカーソル行を置換
    call setline('.', result[0])
  endif
  
  echo "Markdownリンクに変換しました"
endfunction

command! -range -nargs=0 ConvertMarkdownLink call s:ConvertMarkdownLink()
" }}}1



" -----------------------------------------------------------
" test {{{1
function! s:Test()
  " 選択範囲のテキストを取得
  let selected_text = s:get_visual_text()
  
  if empty(selected_text)
    echo "テキストが選択されていません"
    return
  endif
  
  " テキストを行ごとに分割
  let lines = split(selected_text, '\n')
  let result = []
  
  " ホームディレクトリのパスを取得
  let home_dir = expand('~')
  
  " 各行を処理
  for line in lines
    " ファイルパスのパターンを検出（/で始まるパス）
    if line =~ '/[^[:space:]]*'
      " パス部分を抽出
      let path_match = matchstr(line, '/[^[:space:]]*')
      
      if !empty(path_match)
        " ファイル名を取得（最後の/以降）
        let filename = fnamemodify(path_match, ':t')
        
        " フルパスを相対パスに変換
        let relative_path = path_match
        " ホームディレクトリのパスを取得
        let home = expand('~')
        " フルパスがホームディレクトリで始まる場合は ~ に置換
        if relative_path =~ '^' . home
          let relative_path = substitute(relative_path, '^' . home, '~', '')
        elseif relative_path =~ '^/Users/[^/]*/'
          " /Users/username/ を ~/ に置換（Mac用のフォールバック）
          let relative_path = substitute(relative_path, '^/Users/[^/]*/', '~/', '')
        elseif relative_path =~ '^/home/[^/]*/'
          " /home/username/ を ~/ に置換（Linux/WSL用のフォールバック）
          let relative_path = substitute(relative_path, '^/home/[^/]*/', '~/', '')
        endif
        
        " Markdown形式のリンクを作成
        let markdown_link = '- [' . filename . '](' . relative_path . ')'
        
        " 元の行でパスより前の部分を保持（インデントやリストマーカーなど）
        let prefix = substitute(line, path_match . '.*', '', '')
        
        " プレフィックスがリストマーカーを含む場合はそのまま使用、含まない場合は追加
        if prefix =~ '^\s*-\s*$'
          call add(result, prefix . '[' . filename . '](' . relative_path . ')')
        else
          call add(result, markdown_link)
        endif
      else
        " パスが含まれない行はそのまま
        call add(result, line)
      endif
    else
      " パスが含まれない行はそのまま
      call add(result, line)
    endif
  endfor
  
  " 結果を結合して表示
  let output = join(result, "\n")
  
  " 選択範囲を結果で置換
  normal! gvd
  let @" = output
  normal! P
  
  echo "Markdownリンクに変換しました"
endfunction

command! -range -nargs=0 Test call s:Test()

nnoremap <silent> <F2> :Test<CR>
vnoremap <silent> <F2> :Test<CR>
" }}}1

nnoremap x "_x
xnoremap x "_x
nnoremap X "_X
xnoremap X "_X

" 教訓記録機能 (AiEditOutput使用) {{{1
" 選択テキストをAIで教訓形式に変換し、changelogmemoに追記
function! s:CreateLessonLearned() range
  " 1. 選択テキスト取得
  let selected_text = s:get_visual_text()
  if empty(selected_text)
    echo "テキストが選択されていません"
    return
  endif

  " 2. 追加指示を取得
  let instruction = input("教訓の観点・指示 > ")
  redraw

  " 3. AIプロンプト作成
  let prompt = "以下のテキストを教訓として記録します。\n"
  let prompt .= "指示: " . instruction . "\n\n"
  let prompt .= "以下の形式でMarkdownに整理してください:\n"
  let prompt .= "1. 冒頭に「## 理解度確認」として、この教訓の理解度を確認する質問を2-3個追加\n"
  let prompt .= "2. 「## 教訓」として本文を整理\n"
  let prompt .= "3. 「## ポイント」として重要点を箇条書き\n\n"
  let prompt .= "対象テキスト:\n" . selected_text

  " 4. AiEditOutput()でAI変換（同期）
  echo "AIで教訓を生成中..."
  let result = AiEditOutput(prompt)
  if empty(result)
    echo "AI変換に失敗しました"
    return
  endif

  " 5. changelogmemoに追記
  call s:AppendToChangelogMemo(result)
endfunction

function! s:AppendToChangelogMemo(content)
  " changelogmemoを開く
  let changelog_path = expand('~/repos/changelog/changelogmemo')
  execute "silent! e " . changelog_path

  " ヘッダー行を生成（cpwスニペット形式）
  let header = "* 教訓メモ " . strftime("%Y-%m-%d %H:%M:%S") . " [lesson]:"

  " 先頭（3行目）に挿入
  call cursor(1, 1)
  call append(2, ['', header])
  call append(4, split(a:content, "\n"))

  " 保存
  silent! write
  echo "教訓をchangelogmemoに追記しました"
endfunction

command! -range CreateLessonLearned call s:CreateLessonLearned()
vnoremap <silent> ,ll :CreateLessonLearned<CR>
" }}}1

" Battlefront Progress Navigation Keys {{{1
" Arrow key bindings for ~/repos/changelog/ai/battlefront/progress/{private,work}.md
" <Down>  : move current line/selection to end of file
" <Left>  : move current line/selection above previous # header
" <Right> : move current line/selection below next # header
" <Up>    : move current line/selection to just below # Today (dedup if already present)

function! s:BattlefrontMoveToBottom() range
  let lines = getline(a:firstline, a:lastline)
  execute a:firstline . ',' . a:lastline . 'delete _'
  let total = line('$')
  call append(total, lines)
  call cursor(total + 1, 1)
endfunction

function! s:BattlefrontMoveAbovePrevHeader() range
  let header_line = 0
  let i = a:firstline - 1
  while i >= 1
    if getline(i) =~# '^#'
      let header_line = i
      break
    endif
    let i -= 1
  endwhile
  if header_line == 0
    echo "No previous # header"
    return
  endif
  let lines = getline(a:firstline, a:lastline)
  execute a:firstline . ',' . a:lastline . 'delete _'
  " header_line is above firstline, so no offset shift needed
  " Skip blank lines just before the header to insert before them
  let insert_pos = header_line - 1
  while insert_pos >= 1 && getline(insert_pos) =~# '^$'
    let insert_pos -= 1
  endwhile
  call append(insert_pos, lines)
  call cursor(insert_pos + 1, 1)
endfunction

function! s:BattlefrontMoveBelowNextHeader() range
  let total = line('$')
  let header_line = 0
  let i = a:lastline + 1
  while i <= total
    if getline(i) =~# '^#'
      let header_line = i
      break
    endif
    let i += 1
  endwhile
  if header_line == 0
    echo "No next # header"
    return
  endif
  let lines = getline(a:firstline, a:lastline)
  let count = a:lastline - a:firstline + 1
  execute a:firstline . ',' . a:lastline . 'delete _'
  " header_line was below firstline, so it shifts up by count after deletion
  let new_insert_pos = header_line - count
  call append(new_insert_pos, lines)
  call cursor(new_insert_pos + 1, 1)
endfunction

function! s:BattlefrontMoveToToday() range
  if !exists('g:debug_battlefront')
    let g:debug_battlefront = 0
  endif
  let lines = getline(a:firstline, a:lastline)
  let total = line('$')
  let today_line = 0
  let i = 1
  while i <= total
    if getline(i) =~# '^# Today'
      let today_line = i
      break
    endif
    let i += 1
  endwhile
  if today_line == 0
    echo "No # Today header found"
    return
  endif
  let already_in_today = a:firstline > today_line
  if !already_in_today
    echo "Use <Down> to move to # Today"
    return
  endif
  " already_in_today = true: restore from Today
  if a:firstline == a:lastline
    let parent_in_today = s:GetParentTaskLineNum(a:firstline)
    if parent_in_today > today_line
      let parent_text = getline(parent_in_today)
      let child_text  = getline(a:firstline)
      let parent_match_line = 0
      let k = 1
      while k < today_line
        if getline(k) ==# parent_text
          let parent_match_line = k
          break
        endif
        let k += 1
      endwhile
      " Delete child (higher line) first, then parent (lower line)
      silent execute a:firstline . 'delete _'
      silent execute parent_in_today . 'delete _'
      if parent_match_line > 0
        call append(parent_match_line, [child_text])
      else
        call append(today_line - 1, [parent_text, child_text])
      endif
      return
    endif
  endif
  " Default: remove from Today, search for matching line outside Today
  let match_line = 0
  for line_text in lines
    if line_text !=# ''
      let k = 1
      while k < today_line
        if getline(k) ==# line_text
          let match_line = k
          break
        endif
        let k += 1
      endwhile
      if match_line > 0
        break
      endif
    endif
  endfor
  if match_line > 0
    " match_line に対応する lines[] のインデックスを特定
    let matched_idx = 0
    for i in range(len(lines))
      if lines[i] !=# ''
        let matched_idx = i
        break
      endif
    endfor
    let child_lines = lines[matched_idx + 1:]

    if g:debug_battlefront | echom "[BF:MoveToToday] match_line=" . match_line . " matched_idx=" . matched_idx . " child_count=" . len(child_lines) | endif

    " Today から全選択行を削除（match_line < a:firstline なので行番号シフトなし）
    execute a:firstline . ',' . a:lastline . 'delete _'

    if len(child_lines) > 0
      if g:debug_battlefront | echom "[BF:MoveToToday] inserting " . len(child_lines) . " children after line " . match_line | endif
      call append(match_line, child_lines)
      call cursor(match_line, 1)
      let mid = matchaddpos('Search', [match_line])
      call timer_start(1500, {-> matchdelete(mid)})
      echo "Returned: line " . match_line . " (with " . len(child_lines) . " children)"
    else
      let mid = matchaddpos('Search', [match_line])
      call timer_start(1500, {-> matchdelete(mid)})
      echo "Returned: line " . match_line
    endif
  else
    if g:debug_battlefront | echom "[BF:MoveToToday] No match found for lines: " . join(lines, ' | ') | endif
    echo "No corresponding task found outside Today"
  endif
endfunction

" 指定行が子タスクかどうか判定し、親行番号を返す (-1 = 子タスクではない)
function! s:GetParentTaskLineNum(line_num)
  let current_line = getline(a:line_num)
  if current_line !~# '^\s\+[-*]\s*\['
    return -1
  endif
  let current_indent = strlen(matchstr(current_line, '^\s*'))
  let i = a:line_num - 1
  while i >= 1
    let line = getline(i)
    if line =~# '^\s*$'
      let i -= 1
      continue
    endif
    let line_indent = strlen(matchstr(line, '^\s*'))
    if line_indent < current_indent
      return i
    endif
    let i -= 1
  endwhile
  return -1
endfunction

function! s:BattlefrontMoveDown() range
  let today_line = 0
  let i = 1
  while i <= line('$')
    if getline(i) =~# '^# Today'
      let today_line = i
      break
    endif
    let i += 1
  endwhile
  if today_line == 0
    echo "No # Today header found"
    return
  endif
  " 既に Today 内にいる場合は何もしない
  if a:firstline > today_line
    echo "Already in # Today"
    return
  endif
  " 単一行で子タスクの場合: 親+子を Today へ
  if a:firstline == a:lastline
    let parent_line_num = s:GetParentTaskLineNum(a:firstline)
    if parent_line_num > 0 && parent_line_num < today_line
      let parent_text = getline(parent_line_num)
      let child_text  = getline(a:firstline)
      " Today 内に同じ子タスクが既にある場合はスキップ
      let today_end = line('$')
      let j = today_line + 1
      while j <= line('$')
        if getline(j) =~# '^#'
          let today_end = j - 1
          break
        endif
        let j += 1
      endwhile
      for line_text in getline(today_line + 1, today_end)
        if line_text ==# child_text
          echo "Already in # Today"
          return
        endif
      endfor
      " Today 内に同じ親行があるか確認
      let today_has_parent = 0
      let today_parent_pos = -1
      let j2 = today_line + 1
      while j2 <= line('$')
        if getline(j2) =~# '^#'
          break
        endif
        if getline(j2) ==# parent_text
          let today_has_parent = 1
          let today_parent_pos = j2
          break
        endif
        let j2 += 1
      endwhile

      if today_has_parent
        " ケース2: 親が Today に存在する → 子のみ削除して既存親の最後の子の後に挿入
        let parent_indent = strlen(matchstr(parent_text, '^\s*'))
        let insert_pos = today_parent_pos
        let k = today_parent_pos + 1
        while k <= line('$')
          let kline = getline(k)
          if kline =~# '^\s*$'
            let k += 1
            continue
          endif
          let k_indent = strlen(matchstr(kline, '^\s*'))
          if k_indent > parent_indent
            let insert_pos = k
            let k += 1
          else
            break
          endif
        endwhile
        silent execute a:firstline . 'delete _'
        call append(insert_pos - 1, [child_text])
        call cursor(insert_pos, 1)
      else
        " ケース1: 親が Today にいない → 子のみ削除し、親をコピーして Today 先頭に挿入
        silent execute a:firstline . 'delete _'
        let new_today_line = today_line - 1
        call append(new_today_line, [parent_text, child_text])
        call cursor(new_today_line + 1, 1)
      endif
      return
    endif
  endif
  " 複数行選択でその先頭行が子タスクの場合: 親コピー + 選択行を Today へ
  if a:firstline < a:lastline
    let ml_parent = s:GetParentTaskLineNum(a:firstline)
    if ml_parent > 0 && ml_parent < today_line
      let ml_parent_text = getline(ml_parent)
      let selected_lines = getline(a:firstline, a:lastline)
      let sel_count = a:lastline - a:firstline + 1
      execute a:firstline . ',' . a:lastline . 'delete _'
      let new_today_line = today_line - sel_count
      " Today 内に同じ親がいるか確認
      let ml_has_parent = 0
      let ml_parent_pos = -1
      let jj = new_today_line + 1
      while jj <= line('$')
        if getline(jj) =~# '^#'
          break
        endif
        if getline(jj) ==# ml_parent_text
          let ml_has_parent = 1
          let ml_parent_pos = jj
          break
        endif
        let jj += 1
      endwhile
      if ml_has_parent
        " ケース2: 既存親の末尾に追加
        let ml_indent = strlen(matchstr(ml_parent_text, '^\s*'))
        let ml_insert = ml_parent_pos
        let kk = ml_parent_pos + 1
        while kk <= line('$')
          let kline = getline(kk)
          if kline =~# '^\s*$'
            let kk += 1
            continue
          endif
          if strlen(matchstr(kline, '^\s*')) > ml_indent
            let ml_insert = kk
            let kk += 1
          else
            break
          endif
        endwhile
        call append(ml_insert, selected_lines)
        call cursor(ml_insert + 1, 1)
      else
        " ケース1: 親をコピーして Today 先頭に挿入
        call append(new_today_line, [ml_parent_text] + selected_lines)
        call cursor(new_today_line + 1, 1)
      endif
      return
    endif
    " 先頭行が親タスク自体（子タスクを含む選択）の場合: 親コピー + 子のみ Today へ
    let pa_first_text = getline(a:firstline)
    let pa_first_indent = strlen(matchstr(pa_first_text, '^\s*'))
    if pa_first_text =~# '^\s*[-*]\s*\[' && a:firstline + 1 <= a:lastline
      let pa_next_indent = strlen(matchstr(getline(a:firstline + 1), '^\s*'))
      if pa_next_indent > pa_first_indent
        let pa_parent_text = pa_first_text
        let pa_children = getline(a:firstline + 1, a:lastline)
        let pa_child_count = a:lastline - a:firstline
        " 子のみ削除（親行 a:firstline は残す）
        execute (a:firstline + 1) . ',' . a:lastline . 'delete _'
        let new_today_line = today_line - pa_child_count
        " Today 内に同じ親がいるか確認
        let pa_has_parent = 0
        let pa_parent_pos = -1
        let pp = new_today_line + 1
        while pp <= line('$')
          if getline(pp) =~# '^#'
            break
          endif
          if getline(pp) ==# pa_parent_text
            let pa_has_parent = 1
            let pa_parent_pos = pp
            break
          endif
          let pp += 1
        endwhile
        if pa_has_parent
          " ケース2: 既存親の末尾に追加
          let pa_indent = strlen(matchstr(pa_parent_text, '^\s*'))
          let pa_insert = pa_parent_pos
          let pk = pa_parent_pos + 1
          while pk <= line('$')
            let pkline = getline(pk)
            if pkline =~# '^\s*$'
              let pk += 1
              continue
            endif
            if strlen(matchstr(pkline, '^\s*')) > pa_indent
              let pa_insert = pk
              let pk += 1
            else
              break
            endif
          endwhile
          call append(pa_insert, pa_children)
          call cursor(pa_insert + 1, 1)
        else
          " ケース1: 親コピー + 子を Today 先頭に挿入
          call append(new_today_line, [pa_parent_text] + pa_children)
          call cursor(new_today_line + 1, 1)
        endif
        return
      endif
    endif
  endif
  " 通常ライン (非子タスク or レンジ選択): そのまま Today へ
  let lines = getline(a:firstline, a:lastline)
  let count = a:lastline - a:firstline + 1
  execute a:firstline . ',' . a:lastline . 'delete _'
  let new_today_line = today_line - count
  call append(new_today_line, lines)
  call cursor(new_today_line + 1, 1)
endfunction

function! s:SetupBattlefrontProgressKeys()
  nnoremap <buffer> <silent> <Down>  :call <SID>BattlefrontMoveDown()<CR>
  xnoremap <buffer> <silent> <Down>  :call <SID>BattlefrontMoveDown()<CR>
  nnoremap <buffer> <silent> <Left>  :call <SID>BattlefrontMoveAbovePrevHeader()<CR>
  xnoremap <buffer> <silent> <Left>  :call <SID>BattlefrontMoveAbovePrevHeader()<CR>
  nnoremap <buffer> <silent> <Right> :call <SID>BattlefrontMoveBelowNextHeader()<CR>
  xnoremap <buffer> <silent> <Right> :call <SID>BattlefrontMoveBelowNextHeader()<CR>
  nnoremap <buffer> <silent> <Up>    :call <SID>BattlefrontMoveToToday()<CR>
  xnoremap <buffer> <silent> <Up>    :call <SID>BattlefrontMoveToToday()<CR>
endfunction

augroup BattlefrontProgress
  autocmd!
  autocmd BufEnter */battlefront/progress/private.md,
    \*/battlefront/progress/work.md call s:SetupBattlefrontProgressKeys()
augroup END
" }}}1
