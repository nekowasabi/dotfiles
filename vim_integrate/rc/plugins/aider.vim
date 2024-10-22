if g:IsMacNeovim() || g:IsWsl()
  let g:aider_command = 'aider --no-auto-commits --stream --architect --model openai/gpt-4o --editor-model anthropic/claude-3-5-sonnet-20241022 --cache-prompts --cache-keepalive-pings 6 --suggest-shell-commands'
  " vhs用
  " let g:aider_command = 'aider --no-auto-commits --stream --chat-mode code --model openai/gpt-4o --editor-model anthropic/claude-3-5-sonnet-20241022 --cache-prompts --cache-keepalive-pings 6 --suggest-shell-commands'
  " let g:aider_command = 'aider --no-auto-commits --no-stream --architect --model  openai/o1-mini --editor-model anthropic/claude-3-5-sonnet-20241022 --cache-prompts --cache-keepalive-pings 6 --suggest-shell-commands'
else
  let g:aider_command = 'aider --no-auto-commits --no-stream --architect --model openai/o1-mini --editor-model anthropic/claude-3-5-sonnet-20241022 --cache-prompts --cache-keepalive-pings 6 --suggest-shell-commands'
endif
let g:aider_floatwin_width = 100
let g:aider_floatwin_height = 50
let g:aider_buffer_open_type = 'floating'
" let g:aider_buffer_open_type = 'split'
if g:IsMacNeovimInWezterm()
 let g:convension_path = "~/.config/nvim/plugged/aider.vim/CONVENTION.md"
endif
if g:IsWsl()
 let g:convension_path = "~/.config/nvim/plugged/aider.vim/CONVENTION.md"
endif
if g:IsMacNeovimInWork()
 let g:convension_path = $BACKEND_LARAVEL_MAC_DIR . "/laravel/CONVENTION.md"
endif
nnoremap <silent> <leader>ae :AiderRun<CR>
nnoremap <silent> <leader>aR :AiderSilentRun<CR>
nnoremap <silent> <leader>aa :AiderSilentAddCurrentFile<CR>
nnoremap <silent> <leader>aA :AiderAddCurrentFile<CR>
nnoremap <silent> <leader>al :AiderSilentAddCurrentFileReadOnly<CR>
nnoremap <silent> <leader>aL :AiderAddCurrentFileReadOnly<CR>
nnoremap <silent> <leader>aw :AiderAddWeb<CR>
nnoremap <silent> <leader>ap :AiderSendPromptWithInput<CR>
nnoremap <silent> <leader>ax :AiderExit<CR>
nnoremap <silent> <leader>ai :AiderAddIgnoreCurrentFile<CR>
nnoremap <silent> <leader>aI :AiderOpenIgnore<CR>
nnoremap <silent> <leader>ah :AiderHide<CR>
vmap <leader>av :AiderVisualTextWithPrompt<CR>
nnoremap <leader>av :AiderVisualTextWithPrompt<CR>

let g:aider_additional_prompt = [
      \ "- quoteで囲まれたところに対象コードがある場合は、それを出力コードに置き換えます。",
      \ "- 選択された範囲のコードのみが変更対象であり、その他のコードを変更することは禁止されています。",
      \ "- 編集の説明を日本語で1つ1つステップごとに説明します。",
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


