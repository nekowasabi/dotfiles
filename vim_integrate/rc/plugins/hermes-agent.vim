" 基本設定 {{{1

let g:hermes_command            = 'hermes chat --source vim'
let g:hermes_buffer_open_type   = 'vsplit'
let g:hermes_floatwin_width     = 100
let g:hermes_floatwin_height    = 50
let g:hermes_floatwin_border    = 'double'
let g:hermes_floatwin_border_style = 'minimal'
let g:hermes_tmux_pane_id       = 'test'

" キーマッピング設定 {{{2
" ---------------------------------------------------------
" <leader>a プレフィックスを使った一貫したキーバインド
" ---------------------------------------------------------
let s:keymaps = [
  \ ['n', '<leader>as', ':HermesRun<CR>',                  'モード切替'],
  \ ['n', '<leader>ax', ':HermesExit<CR>',                 '終了'],
  \ ['n', '<leader>ah', ':HermesHide<CR>',                 '非表示'],
  \ ['v', '<leader>av', ':HermesVisualTextWithPrompt<CR>', '選択テキストでプロンプト'],
  \ ['n', '<leader>av', ':HermesVisualTextWithPrompt<CR>', 'ビジュアル選択でプロンプト']
  \ ]
nnoremap <leader>aa :HermesSendPromptByCommandline

for [mode, lhs, rhs, desc] in s:keymaps
  execute printf('%snoremap <silent> %s %s " %s', mode, lhs, rhs, desc)
endfor

let g:hermes_additional_prompt = [
      \ "- ► THINKINGの内容を日本語に翻訳してください。",
      \ "- 翻訳したTHINKINGの内容を表示してください。",
      \ "- quoteで囲まれたところに対象コードがある場合は、対象コードを出力コードに置き換えることのみを行ってください。",
      \ "- 選択された範囲のコードのみが変更対象であり、その他のコードを変更することは禁止されています。",
      \ "- 出力結果を、ファイルに反映してください。"
      \]

augroup HermesOpenGroup
  autocmd!
  autocmd User HermesOpen call s:HermesOpenHandler()
augroup END

function! s:HermesOpenHandler() abort
  tnoremap <C-x><C-x> <C-\><C-n><C-\><C-n><ESC>:HermesHide<CR>
  tnoremap <C-x><C-c> <Esc> <C-\><C-n><C-w>w
  nnoremap <C-x><C-x> :HermesHide<CR>
endfunction
" }}}1

" diffを取得してレビューコマンドをhermesに送信する {{{1
function! s:HermesGitDiff(...)
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

  " g:hermes_diff_promptを連結したモノを追加
  let diff_result = join(g:hermes_diff_prompt, "\n") . "\n\n" . diff_result

  execute "HermesSendPromptByCommandline " . shellescape(diff_result)
endfunction
nnoremap <leader>aD :HermesGitDiff
command! -range -nargs=? HermesGitDiff call s:HermesGitDiff(<f-args>)

let g:hermes_diff_prompt = [
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
