" 基本設定 {{{1
" ==========================================================
" グローバル変数と基本オプションの定義
" ==========================================================
let s:claude_base_command = 'claude '
let g:claude_floatwin_width = 100
let g:claude_floatwin_height = 50
let g:claude_buffer_open_type = 'floating'
let g:claude_floatwin_border = 'double'
let g:claude_floatwin_style = 'minimal'

" キーマッピング設定 {{{2
" ---------------------------------------------------------
" <leader>c プレフィックスを使った一貫したキーバインド
" ---------------------------------------------------------
let s:keymaps = [
  \ ['n', '<leader>cs', ':ClaudeRun<CR>',               'モード切替'],
  \ ['n', '<leader>ca', ':ClaudeSilentAddCurrentFile<CR>', 'ファイルを無視リスト追加後追加'],
  \ ['n', '<leader>cl', ':ClaudeSilentAddCurrentFileReadOnly<CR>', '読み取り専用で追加'],
  \ ['n', '<leader>cx', ':ClaudeExit<CR>',                  '終了'],
  \ ['n', '<leader>ch', ':ClaudeHide<CR>',                  '非表示'],
  \ ['v', '<leader>cs', ':ClaudeAddFileVisualSelected<CR>', '選択範囲からファイル追加'],
  \ ['v', '<leader>cv', ':ClaudeVisualTextWithPrompt<CR>',  '選択テキストでプロンプト'],
  \ ['n', '<leader>cv', ':ClaudeVisualTextWithPrompt<CR>',  'ビジュアル選択でプロンプト']
  \ ]
nnoremap <leader>cc :ClaudeSendPromptByCommandline 

for [mode, lhs, rhs, desc] in s:keymaps
  execute printf('%snoremap <silent> %s %s " %s', mode, lhs, rhs, desc)
endfor

let g:claude_additional_prompt = [
      \ "- ► THINKINGの内容を日本語に翻訳してください。",
      \ "- 翻訳したTHINKINGの内容を表示してください。",
      \ "- quoteで囲まれたところに対象コードがある場合は、対象コードを出力コードに置き換えることのみを行ってください。",
      \ "- 選択された範囲のコードのみが変更対象であり、その他のコードを変更することは禁止されています。",
      \ "- 出力結果を、ファイルに反映してください。"
      \]

augroup ClaudeOpenGroup
  autocmd!
  autocmd User ClaudeOpen call s:ClaudeOpenHandler()
augroup END

function! s:ClaudeOpenHandler() abort
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-x><C-x> <C-\><C-n><C-\><C-n><ESC>:ClaudeHide<CR>
  tnoremap <C-x><C-c> <Esc> <C-\><C-n><C-w>w
  nnoremap <C-x><C-x> :ClaudeHide<CR>
endfunction
" }}}1

" 選択範囲からパスを抽出してclaudeに追加 {{{1
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
function! s:ClaudeAddFileVisualSelected()
    " 選択範囲のテキストを取得
    let l:text = s:get_visual_text()
    if empty(l:text)
      let l:lines = [getline('.')]
    else
      let l:lines = []
      for line in split(l:text, '\n')
          call add(l:lines, "\t" . line)
      endfor
    endif

    let l:lines = map(l:lines, 'substitute(v:val, "[, ]*$", "", "g")')
    let l:lines = map(l:lines, 'substitute(v:val, "^[ ]*", "", "g")')

    " 各行からファイルパスを抽出
    for l:line in l:lines
      let l:path_pattern = '[~/]\?[a-zA-Z0-9_/.-]\+'
      let l:matched_path = matchstr(l:line, l:path_pattern)
      
      if !empty(l:matched_path)
        execute "ClaudeAddFile " . l:matched_path
      endif
    endfor
endfunction

command! -range -nargs=0 ClaudeAddFileVisualSelected call s:ClaudeAddFileVisualSelected()
" }}}1

" diffを取得してレビューコマンドをclaudeに送信する {{{1
function! s:ClaudeGitDiff(...)
  " 差分を取得
  let diff_result = ""
  if a:0 > 0
    " 引数が指定された場合は、その親ブランチとの差分を取得
    let parent_branch = a:1
    let current_branch = trim(system('git rev-parse --abbrev-ref HEAD'))
    let diff_result = system('git diff ' . parent_branch . '...' . current_branch)
  else
    " 引数がない場合は通常のgit diffを実行
    let diff_result = system('git diff')
  endif

  " g:claude_diff_promptを連結したモノを追加
  let diff_result = join(g:claude_diff_prompt, "\n") . "\n\n" . diff_result
  
  execute "ClaudeSendPromptByCommandline " . shellescape(diff_result)
endfunction
nnoremap <leader>cD :ClaudeGitDiff 
command! -range -nargs=? ClaudeGitDiff call s:ClaudeGitDiff(<f-args>)

let g:claude_diff_prompt = [
      \ "与えられたコードのdiffをレビューし、特に読みやすさと保守性に焦点を当ててください。",
      \ "以下に関連する問題を特定してください：",
      \ "- 名前付け規則が不明確、誤解を招く、または使用されている言語の規則に従っていない場合。",
      \ "- 不要なコメントの有無、または必要なコメントが不足している場合。",
      \ "- 複雑すぎる表現があり、簡素化が望ましい場合。",
      \ "- ネストのレベルが高く、コードが追いづらい場合。",
      \ "- 変数や関数に対して名前が過剰に長い場合。",
      \ "- 命名、フォーマット、または全体的なコーディングスタイルに一貫性が欠けている場合。",
      \ "- 抽象化や最適化によって効率的に処理できる繰り返しのコードパターンがある場合。",
      \ "- 数値や文字列などがハードコードされている場合。",
      \ "",
      \ "フィードバックは簡潔に行い、各特定された問題について次の要素を直接示してください：",
      \ "- 問題が見つかった具体的な行番号",
      \ "- 問題の明確な説明",
      \ "- 改善または修正方法に関する具体的な提案",
      \ "",
      \ "フィードバックの形式は次のようにしてください：",
      \ "line=<行番号>: <問題の説明>",
      \ "",
      \ "問題が複数行にわたる場合は、次の形式を使用してください：",
      \ "line=<開始行>-<終了行>: <問題の説明>",
      \ "",
      \ "同じ行に複数の問題がある場合は、それぞれの問題を同じフィードバック内でセミコロンで区切って記載してください。",
      \ "指摘が複数にわたる場合は、一行にまとめるように文字列を整形してください。",
      \ "",
      \ "コードスニペットに読みやすさの問題がない場合、その旨を簡潔に記し、コードが明確で十分に書かれていることを確認してください。",
      \ "",
      \ "diffの出力には、変更された行やその位置を示す情報が含まれています。この情報を用いて、**変更後のコードの正確な行番号**を特定し、その行番号に基づいて指摘を行ってください。",
      \ "",
      \ "重要度に応じて以下のキーワードを含めてください：",
      \ "- 重大な問題: \"error: または critical:",
      \ "- 警告: warning:",
      \ "- スタイル的な提案: style:",
      \ "- その他の提案: suggestion:",
      \ "diff code",
      \]
" }}}1

" vim-rule-switcher.vimのプロジェクトルールのパスをclaudeで開く {{{1
function! s:claude_toggle_context_for_vim_rule_switcher(...) abort
  let json_content = readfile(expand(g:switch_rule))
  let json_data = json_decode(join(json_content, "\n"))

  if !exists('json_data.projects') || empty(json_data.projects)
    echo "エラー: プロジェクトがルールファイルに見つからないか、ルールファイルが正しくありません。"
    return
  endif

  let l:project_data_to_use = {}
  let l:mode = 'read-only' " デフォルトモード
  let l:project_name_for_message = ''

  if a:0 == 0
    " 引数なしの場合: 最初のプロジェクトを使用
    let l:project_data_to_use = json_data.projects[0]
    let l:project_name_for_message = l:project_data_to_use.name
  else
    " 引数ありの場合
    let l:project_name_arg = a:1
    let filtered_projects = filter(copy(json_data.projects), 'v:val.name ==# l:project_name_arg')
    if empty(filtered_projects)
      echo "指定されたプロジェクト「" . l:project_name_arg . "」が見つかりません。"
      return
    endif
    let l:project_data_to_use = filtered_projects[0]
    let l:project_name_for_message = l:project_data_to_use.name
    if a:0 == 2
      let l:mode = a:2 " モードが指定されていれば上書き
    endif
  endif

  let paths = map(copy(l:project_data_to_use.rules), 'v:val.path')
  let paths = flatten(paths)
  let paths = map(paths, 'expand(v:val)')
  
  let command_action = l:mode ==# 'add' ? '/add' : '/read-only'
  
  for path in paths
    execute "ClaudeSendPromptByCommandline " . command_action . " " . path
  endfor
  echo "プロジェクト「" . l:project_name_for_message . "」のファイルを " . l:mode . " モードでClaudeに追加しました。"
endfunction
command! -nargs=* ClaudeProjectFiles call s:claude_toggle_context_for_vim_rule_switcher(<f-args>)

function! s:find_file_path_by_project_name(switch_rule, file_name) abort
  let json_content = readfile(expand(g:switch_rule))
  let json_data = json_decode(join(json_content, "\n"))

  let l:project = a:switch_rule
  let project = filter(json_data.projects, 'v:val.name ==# l:project')

  if len(project) > 0
      let paths = map(copy(project[0].rules), 'v:val.path')
      let paths = flatten(paths)
      let paths = map(paths, 'expand(v:val)')
      let target_paths = filter(paths, 'v:val =~# a:file_name')
      return !empty(target_paths) ? target_paths[0] : ''
  else
      echo "指定されたプロジェクト「" . l:project . "」が見つかりません。"
      return ''
  endif
endfunction
" }}}1
