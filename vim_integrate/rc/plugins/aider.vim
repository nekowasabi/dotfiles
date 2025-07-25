" 基本設定 {{{1
" ==========================================================
" グローバル変数と基本オプションの定義
" ==========================================================
let s:aider_base_command = 'aider '
let g:aider_floatwin_width = 100
let g:aider_floatwin_height = 50
let g:aider_buffer_open_type = 'floating'
let g:aider_floatwin_border = 'double'
let g:aider_floatwin_style = 'minimal'
if g:IsMacNeovimInWezterm()
  let g:convension_path = "~/.config/nvim/plugged/aider.vim/CONVENTION.md"
  let g:init_load_command = "~/.config/nvim/plugged/aider.vim/init.md"
  let g:dev_plan_path = "~/.config/nvim/plugged/aider.vim/aidoc/dev_plan.md"
endif
if g:IsWsl()
  let g:convension_path = "~/.config/nvim/plugged/aider.vim/CONVENTION.md"
  let g:init_load_command = "~/.config/nvim/plugged/aider.vim/init.md"
endif
if g:IsMacNeovimInWork()
  let g:convension_path = $BACKEND_LARAVEL_DIR . "/aidoc/CONVENTION.md"
  let g:init_load_command = $BACKEND_LARAVEL_DIR . "/aidoc/init.md"
  let g:dev_plan_path = $BACKEND_LARAVEL_DIR . "/aidoc/dev_plan.md"
endif

let g:aider_process_number = ''
function! s:get_rule_name()
    try
        let rule_path = expand('~/.config/nvim/rule')
        let content = readfile(rule_path)
        let g:aider_switch_rule = join(content, "\n")
        return g:aider_switch_rule
    catch
        let g:aider_switch_rule = ''
        echo 'Error: ルールファイルが見つかりません。'
        return ''
    endtry
endfunction
let g:aider_switch_rule = s:get_rule_name()

" キーマッピング設定 {{{2
" ---------------------------------------------------------
" <leader>a プレフィックスを使った一貫したキーバインド
" ---------------------------------------------------------
let s:keymaps = [
  \ ['n', '<leader>as',  ':AiderSwitch<CR>',               'モード切替'],
  \ ['n', '<leader>aS',  ':AiderSwitch watch<CR>',         '監視モード切替'],
  \ ['n', '<leader>aA',  ':AiderSilentAddCurrentFile<CR>', '現在のファイルを追加'],
  \ ['n', '<leader>aa',  ':AiderAddIgnoreCurrentFile<CR>:AiderSilentAddCurrentFile<CR>', 'ファイルを無視リスト追加後追加'],
  \ ['n', '<leader>al',  ':AiderAddIgnoreCurrentFile<CR>:AiderSilentAddCurrentFileReadOnly<CR>', '読み取り専用で追加'],
  \ ['n', '<leader>aL',  ':AiderAddIgnoreCurrentFile<CR>:AiderAddCurrentFileReadOnly<CR>', '対話的に読み取り専用追加'],
  \ ['n', '<leader>aw',  ':AiderAddWeb<CR>',                'Webコンテンツを追加'],
  \ ['n', '<leader>ax',  ':AiderExit<CR>',                  '終了'],
  \ ['n', '<leader>ai',  ':AiderAddIgnoreCurrentFile<CR>',  '現在のファイルを無視リストに追加'],
  \ ['n', '<leader>aI',  ':AiderOpenIgnore<CR>',            '無視リストを開く'],
  \ ['n', '<leader>ah',  ':AiderHide<CR>',                  '非表示'],
  \ ['v', '<leader>as',  ':AiderAddFileVisualSelected<CR>', '選択範囲からファイル追加'],
  \ ['v', '<leader>av',  ':AiderVisualTextWithPrompt<CR>',  '選択テキストでプロンプト'],
  \ ['n', '<leader>av',  ':AiderVisualTextWithPrompt<CR>',  'ビジュアル選択でプロンプト']
  \ ]

for [mode, lhs, rhs, desc] in s:keymaps
  execute printf('%snoremap <silent> %s %s " %s', mode, lhs, rhs, desc)
endfor

let g:aider_additional_prompt = [
      \ "- ► THINKINGの内容を日本語に翻訳してください。",
      \ "- 翻訳したTHINKINGの内容を表示してください。",
      \ "- quoteで囲まれたところに対象コードがある場合は、対象コードを出力コードに置き換えることのみを行ってください。",
      \ "- 選択された範囲のコードのみが変更対象であり、その他のコードを変更することは禁止されています。",
      \ "- コードはシンプルに保ちます。"
      \]

augroup AiderOpenGroup
  autocmd!
  autocmd User AiderOpen call s:AiderOpenHandler()
augroup END

function! s:AiderOpenHandler() abort
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-x><C-x> <C-\><C-n><C-\><C-n><ESC>:AiderHide<CR>
  tnoremap <C-x><C-c> <Esc> <C-\><C-n><C-w>w
  nnoremap <C-x><C-x> :AiderHide<CR>
endfunction
" }}}1

" モデル設定 {{{2
" ---------------------------------------------------------
" 各AIモデルのコマンドラインオプション定義
" ---------------------------------------------------------
let s:models = {
  \ 'default':    ' --no-auto-commits --model openrouter/anthropic/claude-sonnet-4 --editor-model openrouter/google/gemini-2.5-flash-preview-05-20',
  \ 'claude':    ' --no-auto-commits --model architect/anthropic/claude-4 --editor-model editor/anthropic/claude-4',
  \ 'gpt':       ' --reasoning-effort medium --weak-model openai/gpt-4.1-nano --model openai/o3-mini --editor-model openai/gpt-4o',
  \ 'gpt_41_mini':    ' --weak-model openrouter/openai/gpt-4.1-mini --model openrouter/openai/gpt-4.1-mini --editor-model openrouter/openai/gpt-4.1-mini',
  \ 'gpt_41_nano':    ' --weak-model openrouter/openai/gpt-4.1-nano --model openrouter/openai/gpt-4.1-nano --editor-model openrouter/openai/gpt-4.1-nano',
  \ 'gemini':    ' --no-auto-commits --model openrouter/google/gemini-2.5-pro-preview --editor-model openrouter/google/gemini-2.5-flash-preview-05-20',
  \ 'gemini_not_thinking':    ' --no-auto-commits --model my-openrouter/google/gemini-2.5-preview --editor-model my-openrouter/google/gemini-2.5-preview ',
  \ 'gemini_flash_not_thinking': ' --no-auto-commits --model my-openrouter/google/gemini-2.5-flash-preview --editor-model my-openrouter/google/gemini-2.5-flash-preview ',
  \ 'deepseek':  ' --no-auto-commits --model my-openai/firework/deepseek-r1-fast --editor-model my-openai/firework/deepseek-v3',
  \ 'copilot':   ' --weak-model openrouter/google/gemini-2.5-flash-preview-05-20 --model openai/gemini-2.5-pro --editor-model copilot/gpt-4.1',
  \ 'copilot_claude': ' --weak-model openrouter/openai/gpt-4.1-nano --model copilot/claude-sonnet-4 --editor-model openrouter/google/gemini-2.5-flash-preview-05-20',
  \ 'copilot_gemini': ' --weak-model openrouter/openai/gpt-4.1-nano --model copilot/openai/gemini-2.5-pro --editor-model openrouter/google/gemini-2.5-flash-preview-05-20',
  \ 'experimental': ' --no-auto-commits --model openrouter/google/gemini-2.5-pro-exp-03-25:free --editor-model my-openai/firework/deepseek-v3 --weak-model openrouter/gpt-4.1-nano',
  \ 'testing':   ''
  \ }

" 共通のAider設定プリセット
function! s:get_aider_common_options()
  let options = ' --no-detect-urls --no-auto-accept-architect --notifications'
        \ . ' --no-auto-commits --no-show-model-warnings'
        \ . ' --chat-language ja --no-stream'
        \ . ' --cache-prompts --cache-keepalive-pings 6'
        \ . ' --suggest-shell-commands --map-refresh auto'
  if exists('g:init_load_command') && !empty(g:init_load_command)
    let options .= ' --load ' . g:init_load_command
  endif
  return options
endfunction

function! s:build_options(base, model, watch_files) abort
  let options = a:base . s:get_aider_common_options()
  let options .= ' --architect ' . s:models[a:model]
  return a:watch_files ? options . ' --watch-files' : options
endfunction

let s:common_aider_settings = {
      \ 'architect_copilot':  s:build_options(s:aider_base_command, 'copilot',           0),
      \ 'architect_claude':   s:build_options(s:aider_base_command, 'claude',            0),
      \ 'architect_deepseek': s:build_options(s:aider_base_command, 'deepseek',          0),
      \ 'architect_gemini':   s:build_options(s:aider_base_command, 'gemini',            0),
      \ 'architect_testing':  s:build_options(s:aider_base_command, 'testing',           0),
      \ 'architect_experimental':  s:build_options(s:aider_base_command, 'experimental', 0),
      \ 'architect_default':  s:build_options(s:aider_base_command, 'default',            0),
      \ 'architect_gpt':      s:build_options(s:aider_base_command, 'gpt',               0),
      \ 'doc':                s:aider_base_command . s:models.gemini_flash_not_thinking . s:get_aider_common_options() . ' --chat-mode ask',
      \ 'vhs':                s:aider_base_command . s:models.claude . s:get_aider_common_options() . ' --chat-mode code ',
      \ 'watch_deepseek':     s:build_options(s:aider_base_command, 'deepseek',          1),
      \ 'watch':              s:build_options(s:aider_base_command, 'deepseek',          1),
      \ 'watch_claude':       s:build_options(s:aider_base_command, 'claude',            1)
      \ }

function! s:setup_environment() abort
  " imakoko
  if g:IsMacNeovimInWork()
    let s:aider_settings = copy(s:common_aider_settings)
    let s:aider_settings['watch'] = s:aider_base_command . s:models.claude . ' --watch-files'
    let g:aider_command = s:aider_settings['architect_default']
  else
    let s:aider_settings = extend(copy(s:common_aider_settings), {
          \ 'architect_experimental': s:build_options(s:aider_base_command, 'experimental', 0),
          \ 'gpt': s:build_options(s:aider_base_command, 'gpt', 0)
          \ })
    let g:aider_command = s:aider_settings['architect_gemini']
  endif
endfunction

call s:setup_environment()
" }}}2

" 異なるAider設定を切り替える {{{1
"
" @param {string} setting_name - 切り替える設定の名前
"                               利用可能な設定: default, architect, watch, gpt, vhs
"                               空の場合は'architect'がデフォルト値として使用される
" @return void - なし
function! s:switch_aider_setting(setting_name) abort
  let l:setting_name = empty(a:setting_name) ? 'architect' : a:setting_name
  if has_key(s:aider_settings, l:setting_name)
    let g:aider_command = s:aider_settings[l:setting_name]
  endif

  if l:setting_name ==# 'watch'
    let g:aider_buffer_open_type = 'split'
  else
    " let g:aider_buffer_open_type = 'floating'
  endif

  " execute 'AiderExit'
  execute 'AiderRun'

  echo 'Switched to ' . a:setting_name . ' setting'
endfunction
command! -nargs=? -complete=customlist,<SID>aider_setting_complete AiderSwitch call s:switch_aider_setting(<q-args>)

function! s:aider_setting_complete(ArgLead, CmdLine, CursorPos) abort
  return filter(keys(s:aider_settings), 'v:val =~ "^" . a:ArgLead')
endfunction
" }}}1

" 選択範囲からパスを抽出してaiderに追加 {{{1
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
function! s:AiderAddFileVisualSelected()
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
    let l:lines = map(l:lines, "^[ ]*", "", "g")')

    " 各行からファイルパスを抽出
    for l:line in l:lines
      let l:path_pattern = '[~/]\?[a-zA-Z0-9_/.-]\+'
      let l:matched_path = matchstr(l:line, l:path_pattern)
      
      if !empty(l:matched_path)
        execute "AiderAddFile " . l:matched_path
      endif
    endfor
endfunction

command! -range -nargs=0 AiderAddFileVisualSelected call s:AiderAddFileVisualSelected()
" }}}1

" diffを取得してレビューコマンドをaiderに送信する {{{1
function! s:AiderGitDiff(...)
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

  " g:aider_diff_promptを連結したモノを追加
  let diff_result = join(g:aider_diff_prompt, "\n") . "\n\n" . diff_result
  
  execute "AiderSendPromptByCommandline " . shellescape(diff_result)
endfunction
nnoremap <leader>aD :AiderGitDiff 
command! -range -nargs=? AiderGitDiff call s:AiderGitDiff(<f-args>)

let g:aider_diff_prompt = [
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

" vim-rule-switcher.vimのプロジェクトルールのパスをaiderで開く {{{1
function! s:aider_toggle_context_for_vim_rule_switcher(...) abort
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
    execute "AiderSendPromptByCommandline " . command_action . " " . path
  endfor
  echo "プロジェクト「" . l:project_name_for_message . "」のファイルを " . l:mode . " モードでAiderに追加しました。"
endfunction
command! -nargs=* AiderProjectFiles call s:aider_toggle_context_for_vim_rule_switcher(<f-args>)

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

" 計画プロセス実行 {{{1
function! s:run_process_helper(pre_commands) abort
  let template =<< trim END
{process
以下の処理を、リストの先頭から順番に実行してください。
処理ごとに実施した内容をログとして具体的にどのような編集をした内容も出力してください

1. 確認のため、dev_plan.mdの%sの作業内容すべてを、表示してください
2. dev_plan.mdの%sを、チェックリストの上から順番に実施してください
3. すでに実装済みだった場合は、『なにもしなかった』ことを教えてください
4. 3.を実施後に、##### goalに定義されたタスクが、実装されたコードのどこで実現されているかを1つずつ説明してください

process}
  END

  let process_num = empty(g:aider_process_number) ? input('Process number: ') : input('Process number: ', g:aider_process_number)
  let g:aider_process_number = process_num
  let input = printf(join(template, "\n"), process_num, process_num)
  
  for cmd in a:pre_commands
    execute cmd
  endfor
  
  execute "AiderSendPromptByCommandline " . shellescape(input)
endfunction

function! s:run_process_dev_plan() abort
  call s:run_process_helper([])
endfunction
command! AiderRunProcessDevPlan call s:run_process_dev_plan()

function! s:run_process_dev_plan_single_file() abort
  let pre_commands = [
    \ 'AiderSendPromptByCommandline /drop ',
    \ 'AiderProjectFiles ' . g:aider_switch_rule,
    \ 'AiderSendPromptByCommandline /add ' . expand('%:p')
    \ ]
  call s:run_process_helper(pre_commands)
endfunction
command! AiderRunProcessDevPlanSingleFile call s:run_process_dev_plan_single_file()

function! s:run_process_check_list_update() abort
  let template =<< trim END
/code {process
@target: dev_plan.md
以下の処理を、チェックリストの先頭から順番に実行してください。
処理ごとに実施した内容をログとして具体的にどのような編集をした内容も出力してください

1. dev_plan.mdの%sにおいて、実装が完了しているものは、チェックリストをONにすることだけを実行してください。
チェックをONにする根拠を教えてください。
dev_plan.mdの更新だけをしてください。他のファイルの編集を禁止します。

process}

  END

  " dev_plan.md以外を/read-onlyで開く
  execute "AiderSendPromptByCommandline /drop "
  execute "AiderProjectFiles ". g:aider_switch_rule
  call system("git add ". g:dev_plan_path)
  execute "AiderSendPromptByCommandline /add aidoc/dev_plan.md"


  " プロセス実行
  let process_num = empty(g:aider_process_number) ? input('Process number: ') : input('Process number: ', g:aider_process_number)
  let g:aider_process_number = process_num
  let input = printf(join(template, "\n"), process_num)
  execute "AiderSendPromptByCommandline " . shellescape(input)
endfunction
command! AiderRunProcessCheckListUpdate call s:run_process_check_list_update()


" /copy-contextを実行し、context.mdに保存する
function! s:copy_context_to_file() abort
  execute "AiderSendPromptByCommandline /copy"
  let l:context = getreg('*')
  let l:context_file = s:find_file_path_by_project_name(g:aider_switch_rule, 'context.md')

  " save context to file
  call writefile(split(l:context, '\n'), l:context_file)

  " /read-onlyで開く
  execute "AiderSendPromptByCommandline /drop "
  execute "AiderSendPromptByCommandline /read-only " . l:context_file
endfunction
command! AiderCopyContextToFile call s:copy_context_to_file()

" }}}1

function! s:open_by_copilot() abort
  execute 'terminal ~/copilot_aider.sh'
endfunction
command! AiderOpenByCopilot call s:open_by_copilot()

" Aiderをcopilot設定で切り替える {{{1
"
" @param {string} setting_name - 切り替える設定の名前
"                               利用可能な設定: default, architect, watch, gpt, vhs
"                               空の場合は'architect'がデフォルト値として使用される
" @return void - なし
function! s:switch_aider_with_copilot() abort
  let g:aider_command = '~/.config/nvim/plugged/aider.vim/copilot.sh ' . s:models['copilot_claude'] . s:build_options(s:aider_base_command, 'copilot_gemini', 0)

  execute 'AiderRun'
endfunction
command! -nargs=0 AiderWithCopilot call s:switch_aider_with_copilot()

function! s:doc_aider_with_copilot() abort
  let g:aider_command = '~/.config/nvim/plugged/aider.vim/copilot.sh ' . s:models['copilot_claude'] . s:get_aider_common_options()

  execute 'AiderRun'
	execute "5sleep"
  execute "AiderSendPromptByCommandline /run deno run --allow-read ~/repos/changelog/extract.ts ~/repos/changelog/changelogmemo -- tips idea knowledge memo"
endfunction
command! -nargs=0 AiderDocWithCopilot call s:doc_aider_with_copilot()

" }}}1

" GitHub Copilot Token更新 {{{1
function! s:RefreshCopilotToken()
  if !executable('curl')
    return
  endif

  if &buftype !=# 'terminal'
    return
  endif

  try
    let l:config_path = expand('~/.config/github-copilot/apps.json')

    if !filereadable(l:config_path)
      echohl ErrorMsg
      echo "Could not find " . l:config_path . ". Please check the path and try again."
      echohl None
      return
    endif

    let l:json_content = readfile(l:config_path)->join("\n")
    let l:config_data = json_decode(l:json_content)

    if empty(l:config_data) || type(l:config_data) != v:t_dict
      echohl ErrorMsg
      echo "Invalid JSON format in " . l:config_path
      echohl None
      return
    endif

    let l:first_key = get(keys(l:config_data), 0, '')
    if empty(l:first_key) || !has_key(l:config_data[l:first_key], 'oauth_token')
      echohl ErrorMsg
      echo "No oauth_token found in the first entry of " . l:config_path
      echohl None
      return
    endif
    let l:oauth_token = l:config_data[l:first_key].oauth_token

    if empty(l:oauth_token) || l:oauth_token ==# 'null'
      echohl ErrorMsg
      echo "No oauth_token found in the first entry of " . l:config_path
      echohl None
      return
    endif

    let l:api_url = "https://api.github.com/copilot_internal/v2/token"
    let l:auth_header = "Authorization: Bearer " . l:oauth_token
    let l:curl_command = printf('curl -s -H %s %s', shellescape(l:auth_header), shellescape(l:api_url))

    let l:api_response = system(l:curl_command)
    if v:shell_error
        echohl ErrorMsg
        echo "curl command failed."
        echohl None
        return
    endif

    let l:response_data = json_decode(l:api_response)

    if empty(l:response_data) || !has_key(l:response_data, 'token') || empty(l:response_data.token) || l:response_data.token ==# 'null'
      echohl ErrorMsg
      echo "No 'token' field found in the API response."
      echohl None
      return
    endif

    let l:copilot_token = l:response_data.token

    let $OPENAI_API_KEY = l:copilot_token
    let $GITHUB_COPILOT_TOKEN = l:copilot_token
  catch
    echohl ErrorMsg
    echo "An error occurred: " . v:exception
    echohl None
  endtry
  echo 'refreshed copilot token successfully.'
endfunction

command! RefreshCopilotToken call s:RefreshCopilotToken()

augroup CopilotTokenRefresh
  autocmd!
  autocmd BufEnter * call s:RefreshCopilotToken()
augroup END

" }}}1
