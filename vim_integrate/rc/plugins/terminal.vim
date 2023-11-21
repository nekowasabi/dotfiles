" ターミナルウインドウで入力中でもノーマルモードでも同様にタブ移動するためのマッピング (サンプル)。
" <C-w><C-n> はデフォルトで新規ウインドウ作成に割り当てられているが、
" これをタブ移動に割り当てる (<C-w><C-n> で右のタブ、<C-w><C-p> で左のタブ)
if exists(':tmap') ==# 2
  " Terminal-Job モード用
  tnoremap <C-w><C-n> <C-w>:tabnext<CR>
  tnoremap <C-w><C-p> <C-w>:tabprevious<CR>
  " Terminal-Normal, Normal モード用
  nnoremap <C-w><C-n> :<C-u>tabnext<CR>
  nnoremap <C-w><C-p> :<C-u>tabprevious<CR>
endif


