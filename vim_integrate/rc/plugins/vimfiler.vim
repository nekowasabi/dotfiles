" -----------------------------------------------------------
" vimfiler
let g:vimfiler_as_default_explorer = 1
"セーフモードを無効にした状態で起動する
let g:vimfiler_safe_mode_by_default = 0
"現在開いているバッファのディレクトリを開く
nnoremap <silent> <Tab> :<C-u>CloseSomeWindow
\	(index(['qf','unite','vimtest'], getwinvar(v:val,'&filetype')) != -1)
\		\|\| (getwinvar(v:val, '&filetype') ==# 'help'
\			&& !getwinvar(v:val, '&modifiable'))<CR>:<C-u>VimFilerBufferDir -quit<CR>
"現在開いているバッファをIDE風に開く
nnoremap <silent> ,F :<C-u>VimFilerBufferDir -split -split-action=left -simple -winwidth=35 -no-quit<CR>
let g:vimfiler_enable_auto_cd = 1
let g:vimfiler_split_rule="botright"
 
nnoremap <silent> <C-b> :<C-u>Unite bookmark<cr>

let g:vimfiler_tree_closed_icon = '[+]'
let g:vimfiler_tree_opened_icon = '[-]'

