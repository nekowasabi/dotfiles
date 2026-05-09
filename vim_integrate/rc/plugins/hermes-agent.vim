" 基本設定 {{{1

let g:hermes_command            = 'hermes chat --source transporter'
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

