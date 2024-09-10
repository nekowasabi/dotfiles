" aider.vim
let g:aider_command = 'aider --no-auto-commits --sonnet --cache-prompts --cache-keepalive-pings 6 --no-suggest-shell-commands --chat-language ja'
let g:aider_floatwin_width = 100
let g:aider_floatwin_height = 50
let g:aider_buffer_open_type = 'floating'
if g:IsMacNeovimInWezterm()
 let g:convension_path = "~/.config/nvim/plugged/aider.vim/CONVENTION.md"
endif
if g:IsWsl()
 let g:convension_path = "~/.config/nvim/plugged/aider.vim/CONVENTION.md"
endif
if g:IsMacNeovimInWork()
 let g:convension_path = $BACKEND_LARAVEL_MAC_DIR . "/laravel/CONVENTION.md"
endif
nnoremap <silent> <leader>ar :AiderRun<CR>
nnoremap <silent> <leader>aR :AiderSilentRun<CR>
nnoremap <silent> <leader>aa :AiderAddCurrentFile<CR>
nnoremap <silent> <leader>aw :AiderAddWeb<CR>
nnoremap <silent> <leader>ap :AiderSendPromptWithInput<CR>
nnoremap <silent> <leader>ax :AiderExit<CR>
nnoremap <silent> <leader>ai :AiderAddIgnoreCurrentFile<CR>
nnoremap <silent> <leader>aI :AiderOpenIgnore<CR>
nnoremap <silent> <leader>ah :AiderHide<CR>
vmap <leader>av :AiderVisualTextWithPrompt<CR>

augroup AiderOpenGroup
  autocmd!
  autocmd User AiderOpen call s:AiderOpenHandler()
augroup END

function! s:AiderOpenHandler() abort
  tnoremap <C-x><C-x> <C-\><C-n>:AiderHide<CR>
  tnoremap <buffer> <Esc> <C-\><C-n>
  nnoremap <buffer> <Esc> :AiderHide<CR>
endfunction
