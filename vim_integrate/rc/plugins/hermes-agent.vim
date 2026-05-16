" 基本設定 {{{1

" Why: cwd が ~/words/transporter 配下のときだけ transporter 用プロファイルを起動する。
"      stridx だけだと ~/words/transporter-foo まで誤マッチするので、完全一致 or '/' 付き前方一致で判定。
let s:hermes_transporter_root = expand('~/words/transporter')
let s:hermes_cwd = getcwd()
" Why: `chat` サブコマンドを省くと argparse が `-p` の値を subcommand 名として解釈し
"      "invalid choice: 'transporter'" で即終了する（tmux split が一瞬で閉じる症状の原因）。
if s:hermes_cwd ==# s:hermes_transporter_root
      \ || stridx(s:hermes_cwd, s:hermes_transporter_root . '/') == 0
  let g:hermes_command          = 'hermes chat -p transporter -s storyteller-foundations -s street-storyteller --source transporter'
else
  let g:hermes_command          = 'hermes chat'
endif
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

" augroup HermesOpenGroup
"   autocmd!
"   autocmd User HermesOpen call s:HermesOpenHandler()
" augroup END
"
" function! s:HermesOpenHandler() abort
"   tnoremap <C-x><C-x> <C-\><C-n><C-\><C-n><ESC>:HermesHide<CR>
"   tnoremap <C-x><C-c> <Esc> <C-\><C-n><C-w>w
"   nnoremap <C-x><C-x> :HermesHide<CR>
" endfunction
" }}}1

