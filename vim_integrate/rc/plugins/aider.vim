" 基本設定 {{{1
let s:aider_base_command = 'aider '
let g:aider_floatwin_width = 100
let g:aider_floatwin_height = 50
let g:aider_buffer_open_type = 'floating'
if g:IsMacNeovimInWezterm()
  let g:convension_path = "~/.config/nvim/plugged/aider.vim/CONVENTION.md"
  let g:init_load_command = "~/.config/nvim/plugged/aider.vim/init.md"
endif
if g:IsWsl()
  let g:convension_path = "~/.config/nvim/plugged/aider.vim/CONVENTION.md"
  let g:init_load_command = "~/.config/nvim/plugged/aider.vim/init.md"
endif
if g:IsMacNeovimInWork()
  let g:convension_path = $BACKEND_LARAVEL_DIR . "/laravel/CONVENTION.md"
  let g:init_load_command = $BACKEND_LARAVEL_DIR . "/laravel/init.md"
endif

" vimのキーバインドに説明コメントを追加 AI!
nnoremap <silent> <leader>as :AiderSwitch<CR>
nnoremap <silent> <leader>aS :AiderSwitch watch<CR>
nnoremap <silent> <leader>aA :AiderSilentAddCurrentFile<CR>
nnoremap <silent> <leader>aa :AiderAddIgnoreCurrentFile<CR>:AiderSilentAddCurrentFile<CR>
nnoremap <silent> <leader>al :AiderAddIgnoreCurrentFile<CR>:AiderSilentAddCurrentFileReadOnly<CR>
nnoremap <silent> <leader>aL :AiderAddIgnoreCurrentFile<CR>:AiderAddCurrentFileReadOnly<CR>
nnoremap <silent> <leader>aw :AiderAddWeb<CR>
nnoremap <silent> <leader>ax :AiderExit<CR>
nnoremap <silent> <leader>ai :AiderAddIgnoreCurrentFile<CR>
nnoremap <silent> <leader>aI :AiderOpenIgnore<CR>
nnoremap <silent> <leader>ah :AiderHide<CR>
vnoremap <silent> <leader>as :AiderAddFileVisualSelected<CR>
vmap <leader>av :AiderVisualTextWithPrompt<CR>
nnoremap <leader>av :AiderVisualTextWithPrompt<CR>

let g:aider_additional_prompt = [
      \ "- THINKINGの内容は必ず必ず必ず日本語に翻訳してください。",
      \ "- THINKINGの内容を1つ1つ説明してください。",
      \ "- quoteで囲まれたところに対象コードがある場合は、それを出力コードに置き換えます。",
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

let s:aider_common_options = ' --no-auto-accept-architect --notifications --no-auto-commits --no-show-model-warnings --chat-language ja --no-stream --cache-prompts --cache-keepalive-pings 6 --suggest-shell-commands --map-refresh auto --load ' . g:init_load_command

let s:aider_model_claude = ' --no-auto-commits  --model architect/anthropic/claude-3-7-sonnet-20250219 --editor-model editor/anthropic/claude-3-7-sonnet-20250219 '

let s:aider_model_gpt = ' --reasoning-effort medium --weak-model openai/gpt-4o-mini --model  openai/o3-mini --editor-model openai/gpt-4o '

let s:aider_model_gemini = ' --no-auto-commits --model gemini/gemini-2.0-flash-thinking-exp --editor-model gemini/gemini-2.0-flash-exp '

let s:aider_model_deepseek = ' --no-auto-commits --model my-openrouter/deepseek/deepseek-r1 --editor-model my-o3-mini-effort-low '

let s:aider_model_copilot = ' --reasoning-effort high --weak-model openrouter/anthropic/claude-3-5-haiku --model proxy-claude-3-5-sonnet --editor-model proxy-claude-3-5-sonnet '

let s:aider_model_experimental = ' --no-auto-commits  --model my-openrouter/deepseek/deepseek-r1 --editor-model proxy-claude-3-5-sonnet '

let s:aider_model_testing = ' --no-auto-commits  --model my-openai/deepseek-ai/deepseek-r1 --editor-model my-openai/openai/Qwen/Qwen2.5-Coder-14B-Instruct '

" 共通のAider設定プリセット
let s:common_aider_settings = {
      \ 'architect_copilot': s:aider_base_command . s:aider_common_options . ' --architect ' . s:aider_model_copilot,
      \ 'architect_claude': s:aider_base_command . s:aider_common_options . ' --architect ' . s:aider_model_claude,
      \ 'architect_deepseek': s:aider_base_command . s:aider_common_options . ' --architect '  . s:aider_model_deepseek,
      \ 'architect_gemini': s:aider_base_command . s:aider_common_options . ' --architect '  . s:aider_model_gemini,
      \ 'architect_testing': s:aider_base_command . s:aider_common_options . ' --architect '  . s:aider_model_testing,
      \ 'default': s:aider_base_command . s:aider_common_options . ' --architect '  . s:aider_model_claude,
      \ 'architect_gpt': s:aider_base_command . s:aider_common_options . s:aider_model_gpt,
      \ 'vhs': s:aider_base_command . s:aider_model_claude . s:aider_common_options . ' --chat-mode code ',
      \ 'watch_deepseek': s:aider_base_command . s:aider_common_options . s:aider_model_deepseek . ' --watch-files'
      \ }
let s:common_aider_settings['watch'] = s:aider_base_command . s:aider_common_options . s:aider_model_deepseek . ' --watch-files'
let s:common_aider_settings['watch_claude'] = s:aider_base_command . s:aider_common_options . s:aider_model_claude . ' --watch-files'

if g:IsMacNeovimInWork()
  let s:aider_settings = copy(s:common_aider_settings)
  let s:aider_settings['watch'] = s:aider_base_command . s:aider_model_claude . ' --watch-files'
  " koko
  let g:aider_command = s:aider_settings['architect_claude']
else
  let s:aider_settings = extend(copy(s:common_aider_settings), {
        \ 'architect_experimental': s:aider_base_command . s:aider_common_options . ' --architect ' . s:aider_model_experimental,
        \ 'gpt': s:aider_base_command . s:aider_common_options . s:aider_model_gpt . ' --architect '
        \ })
  let g:aider_command = s:aider_settings['architect_deepseek']
endif

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
    let g:aider_buffer_open_type = 'floating'
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
    let l:lines = map(l:lines, 'substitute(v:val, "^[ ]*", "", "g")')

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
  if a:0 < 1 || a:0 > 2
    echo "Error: 引数は1つ（プロジェクト名）または2つ（プロジェクト名とモード）を指定してください"
    return
  endif

  let l:project = a:1
  echo l:project
  let l:mode = a:0 == 2 ? a:2 : 'read-only'

  let json_content = readfile(expand(g:switch_rule))
  let json_data = json_decode(join(json_content, "\n"))
  echo json_data.projects

  let project = filter(json_data.projects, 'v:val.name ==# l:project')
  echo project
  if len(project) > 0
      let paths = map(copy(project[0].rules), 'v:val.path')
      let paths = flatten(paths)
      let paths = map(paths, 'expand(v:val)')
      
      let command = l:mode ==# 'add' ? '/add' : '/read-only'
      
      for path in paths
        execute "AiderSendPromptByCommandline " . command . " " . path
      endfor
  else
      echo "指定されたプロジェクト「" . l:project . "」が見つかりません。"
  endif
endfunction
command! -nargs=* AiderProjectFiles call s:aider_toggle_context_for_vim_rule_switcher(<f-args>)
" }}}1
