" 基本設定 {{{1
" ==========================================================
" グローバル変数と基本オプションの定義
" ==========================================================
let s:aider_base_command = 'aider '
let g:aider_floatwin_width = 100
let g:aider_floatwin_height = 50
let g:aider_buffer_open_type = 'vsplit'
let g:aider_floatwin_border = 'double'
let g:aider_floatwin_style = 'minimal'
if g:IsMacNeovimInWezterm()
  let g:convension_path = "~/.config/nvim/plugged/aider.vim/CONVENTION.md"
  let g:dev_plan_path = "~/.config/nvim/plugged/aider.vim/aidoc/dev_plan.md"
endif
if g:IsWsl()
  let g:convension_path = "~/.config/nvim/plugged/aider.vim/CONVENTION.md"
endif
if g:IsMacNeovimInWork()
  let g:convension_path = $BACKEND_LARAVEL_DIR . "/aidoc/CONVENTION.md"
  let g:dev_plan_path = $BACKEND_LARAVEL_DIR . "/aidoc/dev_plan.md"
endif

function! s:ensure_aiderignore() abort
  let l:path = getcwd() . '/.aiderignore'
  if !filereadable(l:path)
    call writefile([], l:path)
    echo 'Created .aiderignore: ' . l:path
  endif
endfunction

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
  \ ['n', '<leader>aA',  ':AiderSilentAddCurrentFile<CR>', '現在のファイルを追加'],
  \ ['n', '<leader>aa',  ':call <SID>ensure_aiderignore()<CR>:AiderAddIgnoreCurrentFile<CR>:AiderSilentAddCurrentFile<CR>', 'ファイルを無視リスト追加後追加'],
  \ ['n', '<leader>al',  ':call <SID>ensure_aiderignore()<CR>:AiderAddIgnoreCurrentFile<CR>:AiderSilentAddCurrentFileReadOnly<CR>', '読み取り専用で追加'],
  \ ['n', '<leader>aL',  ':call <SID>ensure_aiderignore()<CR>:AiderAddIgnoreCurrentFile<CR>:AiderAddCurrentFileReadOnly<CR>', '対話的に読み取り専用追加'],
  \ ['n', '<leader>aw',  ':AiderAddWeb<CR>',                'Webコンテンツを追加'],
  \ ['n', '<leader>ax',  ':AiderExit<CR>',                  '終了'],
  \ ['n', '<leader>ai',  ':call <SID>ensure_aiderignore()<CR>:AiderAddIgnoreCurrentFile<CR>',  '現在のファイルを無視リストに追加'],
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
      \ "- quoteで囲まれた対象となる内容の処理のみを実施してください。",
      \ "- 選択された範囲のコードのみが変更対象であり、その他のコードを対象とすることは禁止されています。",
      \ "- 処理結果のみの出力をしてください。説明や理由などの余計な内容は出力しないでください。",
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

" モデル設定 {{{1
" ---------------------------------------------------------
" Why: 6層パイプラインを1層に簡素化 — 間接参照が多すぎて切り替え時の挙動追跡が困難だったため
" ---------------------------------------------------------
let s:default_model = 'z-fast'

let s:models = {
  \ 'default': { 'model': 'openrouter/gpt-5.4', 'editor': 'claude-sonnet-4-6-thinking' },
  \ 'z': { 'model': 'z-glm-5.1', 'editor': 'z-glm-5-turbo', 'weak': 'z-glm-5-turbo' },
  \ 'z-fast': { 'model': 'z-glm-5-turbo', 'editor': 'z-glm-5-turbo', 'weak': 'z-glm-5-turbo' },
  \ 'alter': { 'model': 'alter-gpt-5-4', 'editor': 'alter-fair', 'weak': 'alter-fast' },
  \ 'openrouter': { 'model': 'openrouter/gpt-5', 'editor': 'openrouter/gpt-5-mini', 'weak': 'openrouter/gpt-5-mini' },
  \ 'testing': {}
  \ }

let s:common_options = '--no-detect-urls --no-auto-accept-architect --notifications'
      \ . ' --no-auto-commits --no-show-model-warnings'
      \ . ' --chat-language ja --no-stream'
      \ . ' --cache-prompts --cache-keepalive-pings 6'
      \ . ' --suggest-shell-commands --map-refresh auto'
      \ . ' --chat-mode ask'

function! s:build_aider_command(model_name) abort
  if !has_key(s:models, a:model_name)
    return ''
  endif
  let config = s:models[a:model_name]
  let cmd = s:aider_base_command . s:common_options
  for [key, flag] in [['model', '--model'], ['editor', '--editor-model'], ['weak', '--weak-model']]
    if has_key(config, key)
      let cmd .= ' ' . flag . ' ' . config[key]
    endif
  endfor
  return cmd
endfunction

let g:aider_command = s:build_aider_command(s:default_model)

function! s:switch_aider(model_name) abort
  let model = empty(a:model_name) ? s:default_model : a:model_name
  if !has_key(s:models, model)
    echo 'Error: Unknown model "' . model . '". Available: ' . join(keys(s:models), ', ')
    return
  endif
  let g:aider_command = s:build_aider_command(model)
  execute 'AiderRun'
  echo 'Switched to ' . model
endfunction

command! -nargs=? -complete=customlist,<SID>model_complete AiderSwitch call s:switch_aider(<q-args>)

function! s:model_complete(ArgLead, CmdLine, CursorPos) abort
  return filter(keys(s:models), 'v:val =~ "^" . a:ArgLead')
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
