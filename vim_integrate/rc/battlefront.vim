" -----------------------------------------------------------
" battlefront.vim
" ~/repos/changelog/ai/battlefront/progress/{private,work}.md 専用の
" タスク移動・タグ表示・週次タスク挿入機能

let g:battlefront_weekly_tasks = {
  \ 'work': {
  \   '1': ['週次計画'],
  \   '5': [],
  \ },
  \ 'private': {
  \   '0': ['生活レビュー', '翌週の予定確認'],
  \   '5': [],
  \   '6': ['部屋の片付け'],
  \ },
  \ }

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

      " Why: タグ優先復元 ではなく テキスト完全一致フォールバック。
      "   タグがある場合はヘッダ名で復元先を特定し、タグを除去して挿入する。
      "   タグがない場合（既存データ）は旧フォールバック（行テキスト一致）を使用。
      let child_tag  = s:ExtractOriginTag(child_text)
      let parent_tag = s:ExtractOriginTag(parent_text)
      let restore_tag = child_tag !=# '' ? child_tag : parent_tag

      if restore_tag !=# ''
        " タグ優先経路: ヘッダ行を探して直下に復元
        let dest_header_line = s:FindHeaderLineByName(restore_tag)
        if g:debug_battlefront | echom "[BF:Tag] restore_tag=" . restore_tag . " dest_header_line=" . dest_header_line | endif
        if dest_header_line > 0
          let clean_parent = s:StripOriginTag(parent_text)
          let clean_child  = s:StripOriginTag(child_text)
          " Delete child first (higher line), then parent (lower line)
          silent execute a:firstline . 'delete _'
          silent execute parent_in_today . 'delete _'
          " 挿入位置: ヘッダ直下の非空行末尾（子タスクのインデントが親より深い場合は末尾）
          " ヘッダ行番号はファイル変化後なので再取得
          let dest_header_line = s:FindHeaderLineByName(restore_tag)
          " origin に同一親がいるか確認（タグなし本文で比較）
          let restore_parent_pos = 0
          let rp = dest_header_line + 1
          while rp <= line('$')
            let rpline = getline(rp)
            if rpline =~# '^#'
              break
            endif
            if s:StripOriginTag(rpline) ==# clean_parent
              let restore_parent_pos = rp
              break
            endif
            let rp += 1
          endwhile
          if restore_parent_pos > 0
            " 親が origin に存在 → 既存親の子末尾に挿入
            let rp_indent = strlen(matchstr(clean_parent, '^\s*'))
            let rp_insert = restore_parent_pos
            let rk = restore_parent_pos + 1
            while rk <= line('$')
              let rkline = getline(rk)
              if rkline =~# '^\s*$'
                let rk += 1
                continue
              endif
              if strlen(matchstr(rkline, '^\s*')) > rp_indent
                let rp_insert = rk
                let rk += 1
              else
                break
              endif
            endwhile
            call append(rp_insert, [clean_child])
            call cursor(rp_insert + 1, 1)
            echo "Returned (tag): " . clean_child
          else
            " 親が origin にいない → ヘッダ直下に親＋子を挿入
            call append(dest_header_line, [clean_parent, clean_child])
            call cursor(dest_header_line + 1, 1)
            echo "Returned (tag): " . clean_parent
          endif
          return
        endif
      endif

      " フォールバック: 旧テキスト一致による親検索
      let parent_match_line = 0
      let k = 1
      while k < today_line
        if s:StripOriginTag(getline(k)) ==# s:StripOriginTag(parent_text)
          let parent_match_line = k
          break
        endif
        let k += 1
      endwhile
      " Delete child (higher line) first, then parent (lower line)
      silent execute a:firstline . 'delete _'
      silent execute parent_in_today . 'delete _'
      let clean_child = s:StripOriginTag(child_text)
      if parent_match_line > 0
        call append(parent_match_line, [clean_child])
      else
        let clean_parent = s:StripOriginTag(parent_text)
        call append(today_line - 1, [clean_parent, clean_child])
      endif
      return
    endif
  endif

  " Default: remove from Today, search for matching line outside Today
  " Why: タグ優先で復元先ヘッダを特定し、タグなしの場合は行テキスト一致にフォールバック（後方互換）
  let first_tag = ''
  for line_text in lines
    if line_text !=# ''
      let first_tag = s:ExtractOriginTag(line_text)
      break
    endif
  endfor

  if first_tag !=# ''
    " タグ優先経路
    let dest_header_line = s:FindHeaderLineByName(first_tag)
    if g:debug_battlefront | echom "[BF:Tag] default restore first_tag=" . first_tag . " dest=" . dest_header_line | endif
    if dest_header_line > 0
      let clean_lines = []
      for lt in lines
        call add(clean_lines, s:StripOriginTag(lt))
      endfor
      execute a:firstline . ',' . a:lastline . 'delete _'
      " 再取得（削除によりヘッダ行番号が変化する場合がある）
      let dest_header_line = s:FindHeaderLineByName(first_tag)
      " ヘッダ直下の末尾（既存子の後ろ）に挿入する位置を探す
      let dest_insert = dest_header_line
      let di = dest_header_line + 1
      while di <= line('$')
        let diline = getline(di)
        if diline =~# '^#'
          break
        endif
        if diline !~# '^\s*$'
          let dest_insert = di
        endif
        let di += 1
      endwhile
      call append(dest_insert, clean_lines)
      call cursor(dest_insert + 1, 1)
      let mid = matchaddpos('Search', [dest_insert + 1])
      call timer_start(1500, {-> matchdelete(mid)})
      echo "Returned (tag): " . first_tag
      return
    endif
  endif

  " フォールバック: 旧テキスト一致検索（タグなし既存データ用）
  let match_line = 0
  for line_text in lines
    if line_text !=# ''
      let k = 1
      while k < today_line
        if s:StripOriginTag(getline(k)) ==# s:StripOriginTag(line_text)
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
    let clean_child_lines = []
    for lt in child_lines
      call add(clean_child_lines, s:StripOriginTag(lt))
    endfor

    if g:debug_battlefront | echom "[BF:MoveToToday] match_line=" . match_line . " matched_idx=" . matched_idx . " child_count=" . len(child_lines) | endif

    " Today から全選択行を削除（match_line < a:firstline なので行番号シフトなし）
    execute a:firstline . ',' . a:lastline . 'delete _'

    if len(clean_child_lines) > 0
      if g:debug_battlefront | echom "[BF:MoveToToday] inserting " . len(clean_child_lines) . " children after line " . match_line | endif
      call append(match_line, clean_child_lines)
      call cursor(match_line, 1)
      let mid = matchaddpos('Search', [match_line])
      call timer_start(1500, {-> matchdelete(mid)})
      echo "Returned: line " . match_line . " (with " . len(clean_child_lines) . " children)"
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

" ── Battlefront ヘルパー関数群 ──────────────────────────────────────

" 指定行から上方探索して最初の ^# ヘッダ名本体を返す。見つからなければ ''
function! s:GetOriginHeaderName(line_num)
  let i = a:line_num
  while i >= 1
    let line = getline(i)
    if line =~# '^#\s'
      " Why: matchstr で # と空白を除いてヘッダ名本体のみ取得
      return matchstr(line, '^#\s\+\zs.\{-}\ze\s*$')
    endif
    let i -= 1
  endwhile
  return ''
endfunction

" 行末に @<header_name> タグを注入。既にタグがあれば無変更で返す
" Why: 二重注入防止のため既存タグチェックを先行させる
function! s:InjectOriginTag(text, header_name)
  if a:header_name ==# ''
    return a:text
  endif
  if a:text =~# '\s*@\S\+\s*$'
    return a:text
  endif
  return a:text . ' @' . a:header_name
endfunction

" 行末タグ @<name> からヘッダ名を抽出。なければ ''
function! s:ExtractOriginTag(text)
  let l:tag = matchstr(a:text, '\s*@\zs\S\+\ze\s*$')
  return l:tag ==# 'routine' ? '' : l:tag
endfunction

" タグを除去した本文を返す
" Why: 単発 substitute ではなく 末尾 @tag を繰り返し剥がす実装。
"   理由: 過去の不具合や手編集で @tagA @tagB と多重注入された行が Today 内に
"   残留した場合でも、<Up> 復元時に全タグを確実に除去するための防御。
function! s:StripOriginTag(text)
  return substitute(a:text, '\%(\s*@\S\+\)\+\s*$', '', '')
endfunction

" ^# <name> 行番号を返す。見つからなければ 0
function! s:FindHeaderLineByName(header_name)
  if a:header_name ==# ''
    return 0
  endif
  let total = line('$')
  let i = 1
  while i <= total
    if getline(i) =~# '^#\s\+' . a:header_name . '\s*$'
      return i
    endif
    let i += 1
  endwhile
  return 0
endfunction

" last_selected_line+1 以降、次ヘッダ/ファイル末まで parent_line より深いインデント行が
" 存在するか判定。存在すれば 1（残り子あり）、なければ 0（全子選択済み）
" Why: 全子選択判定により、親を origin から安全に削除できるかを決定する
function! s:HasRemainingChildrenAfter(parent_line, last_selected_line)
  let parent_text   = getline(a:parent_line)
  let parent_indent = strlen(matchstr(parent_text, '^\s*'))
  let total = line('$')
  let i = a:last_selected_line + 1
  while i <= total
    let line = getline(i)
    if line =~# '^#'
      break
    endif
    if line =~# '^\s*$'
      let i += 1
      continue
    endif
    if strlen(matchstr(line, '^\s*')) > parent_indent
      return 1
    endif
    break
  endwhile
  return 0
endfunction

" 行リストの全行にタグを注入して返す
function! s:InjectTagToLines(lines, header_name)
  let result = []
  for line in a:lines
    call add(result, s:InjectOriginTag(line, a:header_name))
  endfor
  return result
endfunction

" work/private の # Today 直下に曜日別定期タスクを挿入する
function! s:GetBattlefrontProgressKind() abort
  let l:path = expand('%:p')
  if l:path =~# '/battlefront/progress/work\.md$'
    return 'work'
  endif
  if l:path =~# '/battlefront/progress/private\.md$'
    return 'private'
  endif
  return ''
endfunction

function! s:FindBattlefrontTodayRange() abort
  let l:today_line = 0
  let l:i = 1
  while l:i <= line('$')
    if getline(l:i) =~# '^# Today'
      let l:today_line = l:i
      break
    endif
    let l:i += 1
  endwhile
  if l:today_line == 0
    return [0, 0]
  endif

  let l:end_line = line('$')
  let l:i = l:today_line + 1
  while l:i <= line('$')
    if getline(l:i) =~# '^#'
      let l:end_line = l:i - 1
      break
    endif
    let l:i += 1
  endwhile
  return [l:today_line, l:end_line]
endfunction

function! s:GetBattlefrontWeeklyTasks(kind, dow) abort
  if !exists('g:battlefront_weekly_tasks')
    let g:battlefront_weekly_tasks = {'work': {}, 'private': {}}
  endif
  let l:file_tasks = get(g:battlefront_weekly_tasks, a:kind, {})
  return copy(get(l:file_tasks, string(a:dow), []))
endfunction

function! s:NormalizeBattlefrontWeeklyTask(task) abort
  if type(a:task) == type({})
    let l:text = get(a:task, 'text', '')
  else
    let l:text = a:task
  endif

  if l:text ==# ''
    return {}
  endif
  if l:text !~# '^\s*[-*]\s*\['
    let l:text = '- [ ] ' . l:text
  endif
  if l:text !~# '\s@routine\s*$'
    let l:text = l:text . ' @routine'
  endif
  return {'text': l:text}
endfunction

function! s:NormalizeBattlefrontTaskForCompare(text) abort
  let l:text = s:StripOriginTag(a:text)
  let l:text = substitute(l:text, '^\(\s*[-*]\s*\[\)[ xX]\(\]\s*\)', '\1 \2', '')
  return substitute(l:text, '\s\+$', '', '')
endfunction

function! s:BattlefrontTodayHasRoutineTask(start_line, end_line, task_text) abort
  if a:start_line <= 0 || a:end_line < a:start_line
    return 0
  endif
  let l:target = s:NormalizeBattlefrontTaskForCompare(a:task_text)
  for l:line_text in getline(a:start_line, a:end_line)
    if s:NormalizeBattlefrontTaskForCompare(l:line_text) ==# l:target
      return 1
    endif
  endfor
  return 0
endfunction

function! s:BattlefrontInsertWeeklyTasks() abort
  let l:kind = s:GetBattlefrontProgressKind()
  if l:kind ==# ''
    return
  endif

  let l:range = s:FindBattlefrontTodayRange()
  if l:range[0] == 0
    return
  endif

  let l:dow = str2nr(strftime('%w'))
  let l:tasks = s:GetBattlefrontWeeklyTasks(l:kind, l:dow)
  if empty(l:tasks)
    return
  endif

  let l:insert_lines = []
  for l:task in l:tasks
    let l:normalized = s:NormalizeBattlefrontWeeklyTask(l:task)
    if empty(l:normalized)
      continue
    endif
    if s:BattlefrontTodayHasRoutineTask(l:range[0] + 1, l:range[1], l:normalized.text)
      continue
    endif
    call add(l:insert_lines, l:normalized.text)
  endfor

  if !empty(l:insert_lines)
    call append(l:range[0], l:insert_lines)
  endif
endfunction

" ── ヘルパー関数群ここまで ────────────────────────────────────────

function! s:BattlefrontMoveDown() range
  if !exists('g:debug_battlefront')
    let g:debug_battlefront = 0
  endif
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

      " Why: origin_header は削除前に取得する（削除後は行番号が変わるため）
      let origin_header = s:GetOriginHeaderName(a:firstline)
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
        let tagged_child = s:InjectOriginTag(child_text, origin_header)
        if g:debug_battlefront | echom "[BF:Tag] injected: " . tagged_child | endif
        silent execute a:firstline . 'delete _'
        call append(insert_pos - 1, [tagged_child])
        call cursor(insert_pos, 1)
      else
        " ケース1: 親が Today にいない → 子のみ削除し、親をコピーして Today 先頭に挿入
        let tagged_parent = s:InjectOriginTag(parent_text, origin_header)
        let tagged_child  = s:InjectOriginTag(child_text,  origin_header)
        if g:debug_battlefront | echom "[BF:Tag] injected parent: " . tagged_parent | endif
        silent execute a:firstline . 'delete _'
        let new_today_line = today_line - 1
        call append(new_today_line, [tagged_parent, tagged_child])
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
      " Why: origin_header は削除前に取得する（削除後は行番号が変わるため）
      let ml_origin_header = s:GetOriginHeaderName(a:firstline)
      let ml_tagged_lines  = s:InjectTagToLines(selected_lines, ml_origin_header)
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
      if g:debug_battlefront | echom "[BF:Tag] ml tagged_lines[0]: " . ml_tagged_lines[0] | endif
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
        call append(ml_insert, ml_tagged_lines)
        call cursor(ml_insert + 1, 1)
      else
        " ケース1: 親をコピーして Today 先頭に挿入
        let ml_tagged_parent = s:InjectOriginTag(ml_parent_text, ml_origin_header)
        call append(new_today_line, [ml_tagged_parent] + ml_tagged_lines)
        call cursor(new_today_line + 1, 1)
      endif
      return
    endif
    " 先頭行が親タスク自体（子タスクを含む選択）の場合
    let pa_first_text = getline(a:firstline)
    let pa_first_indent = strlen(matchstr(pa_first_text, '^\s*'))
    if pa_first_text =~# '^\s*[-*]\s*\[' && a:firstline + 1 <= a:lastline
      let pa_next_indent = strlen(matchstr(getline(a:firstline + 1), '^\s*'))
      if pa_next_indent > pa_first_indent
        let pa_parent_text = pa_first_text
        let pa_children    = getline(a:firstline + 1, a:lastline)
        let pa_origin_header = s:GetOriginHeaderName(a:firstline)

        " Why: 全子選択判定方式 ではなく 子のみ削除方式。
        "   理由: 親に未選択子がある場合のデータ消失を防ぐ。
        "   全子選択済みなら親も origin から削除し、孤児親の残存を解消する。
        let pa_all_children_selected = !s:HasRemainingChildrenAfter(a:firstline, a:lastline)
        if g:debug_battlefront
          echom "[BF:Tag] pa_all_children_selected=" . pa_all_children_selected . " header=" . pa_origin_header
        endif

        if pa_all_children_selected
          " 全子選択済み → 親も含めて全行削除
          let pa_child_count = a:lastline - a:firstline + 1
          execute a:firstline . ',' . a:lastline . 'delete _'
          let new_today_line = today_line - pa_child_count
        else
          " 一部子選択 → 子のみ削除（親は origin に残す）
          let pa_child_count = a:lastline - a:firstline
          execute (a:firstline + 1) . ',' . a:lastline . 'delete _'
          let new_today_line = today_line - pa_child_count
        endif

        " タグ注入
        let pa_tagged_parent   = s:InjectOriginTag(pa_parent_text, pa_origin_header)
        let pa_tagged_children = s:InjectTagToLines(pa_children, pa_origin_header)
        if g:debug_battlefront | echom "[BF:Tag] injected pa_parent: " . pa_tagged_parent | endif

        " Today 内に同じ親がいるか確認
        " Why: 親テキストの完全一致でなくタグなし本文で比較する（既存タグ付き行との一致を保証）
        let pa_has_parent = 0
        let pa_parent_pos = -1
        let pp = new_today_line + 1
        while pp <= line('$')
          if getline(pp) =~# '^#'
            break
          endif
          if s:StripOriginTag(getline(pp)) ==# s:StripOriginTag(pa_parent_text)
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
          call append(pa_insert, pa_tagged_children)
          call cursor(pa_insert + 1, 1)
        else
          " ケース1: 親（タグ付き）＋子（タグ付き）を Today 先頭に挿入
          call append(new_today_line, [pa_tagged_parent] + pa_tagged_children)
          call cursor(new_today_line + 1, 1)
        endif
        return
      endif
    endif
  endif
  " 通常ライン (非子タスク or レンジ選択): そのまま Today へ（タグ注入付き）
  let lines = getline(a:firstline, a:lastline)
  let norm_origin_header = s:GetOriginHeaderName(a:firstline)
  let tagged_lines = s:InjectTagToLines(lines, norm_origin_header)
  if g:debug_battlefront | echom "[BF:Tag] normal tagged_lines[0]: " . tagged_lines[0] | endif
  let count = a:lastline - a:firstline + 1
  execute a:firstline . ',' . a:lastline . 'delete _'
  let new_today_line = today_line - count
  call append(new_today_line, tagged_lines)
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

augroup BattlefrontWeeklyTasks
  autocmd!
  autocmd BufEnter */battlefront/progress/private.md,
    \*/battlefront/progress/work.md call s:BattlefrontInsertWeeklyTasks()
augroup END
" }}}1

" Battlefront Tag Display (inline conceal + right-align virt_text) {{{1
" Why: タグを inline 表示 ではなく 右端 virt_text + conceal。理由: 可読性向上とデータ保持の両立

" Why: has('nvim-0.6') でガードする理由: virt_text_pos='right_align' は Neovim 0.6 で追加された機能。
"   Vim には prop_add しかなく挙動が異なるため、Vim ユーザーには機能を提供しない選択とする。
if has('nvim-0.6')
  let s:battlefront_tag_ns = nvim_create_namespace('battlefront_tag_display')

  function! s:BattlefrontClearTagDisplay(buf) abort
    call nvim_buf_clear_namespace(a:buf, s:battlefront_tag_ns, 0, -1)
  endfunction

  function! s:BattlefrontApplyTagDisplay() abort
    let l:buf = bufnr('%')
    call s:BattlefrontClearTagDisplay(l:buf)
    let l:total = line('$')
    let l:i = 1
    while l:i <= l:total
      let l:line = getline(l:i)
      let l:tag_name = matchstr(l:line, '@\zs\S\+\ze\s*$')
      if !empty(l:tag_name)
        " Why: hl_mode='combine' にする理由: 既存 syntax ハイライトと色を併用するため。
        "   'replace' にすると Comment の色で元の行ハイライトを上書きしてしまう。
        call nvim_buf_set_extmark(l:buf, s:battlefront_tag_ns, l:i - 1, 0, {
              \ 'virt_text': [['[' . l:tag_name . ']', 'BattlefrontTag']],
              \ 'virt_text_pos': 'right_align',
              \ 'hl_mode': 'combine'
              \ })
      endif
      let l:i += 1
    endwhile
  endfunction

  function! s:BattlefrontSetupTagDisplay() abort
    " syntax conceal でインラインタグを非表示
    " Why: containedin=ALL にする理由: markdown の他 syntax 要素との干渉を避け安全側に倒す
    syntax match BattlefrontTagInline /\s\+@\S\+\s*$/ conceal containedin=ALL
    setlocal conceallevel=2
    " Why: concealcursor=nc にする理由: 挿入モード中のカーソル行でタグ編集時にちらつかないようにする
    setlocal concealcursor=nc
    " ハイライトグループ（未定義時のみ Comment にフォールバック）
    " Why: Comment リンク ではなく 明示的な暗灰色。理由: タグは補助情報のため base01 (#586e75) より暗く設定し solarized dark で目立たなくする
    highlight default BattlefrontTag guifg=#4a5a62 ctermfg=239 gui=NONE cterm=NONE
    call s:BattlefrontApplyTagDisplay()
  endfunction

  " Why: TextChanged も採用する理由: 通常の行追加・削除時もタグ表示を即座に反映させるため。
  "   負荷が問題になる場合は TextChanged を除去し InsertLeave のみとすることも可。
  augroup BattlefrontTagDisplay
    autocmd!
    autocmd BufEnter,BufWinEnter */battlefront/progress/*.md call s:BattlefrontSetupTagDisplay()
    autocmd InsertLeave,BufWritePost,TextChanged */battlefront/progress/*.md call s:BattlefrontApplyTagDisplay()
  augroup END
endif
" }}}1

