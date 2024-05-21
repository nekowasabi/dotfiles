" aider.vim
let g:aider_command = 'aider --no-auto-commits'
let g:aider_buffer_open_type = 'floating'
let g:aider_floatwin_width = 100
let g:aider_floatwin_height = 50
if g:IsMacNeovimInWezterm()
 let g:convension_path = "~/.config/nvim/plugged/aider.vim/CONVENTION.md"
endif
if g:IsWsl()
 let g:convension_path = "~/.config/nvim/plugged/aider.vim/CONVENTION.md"
endif
if g:IsMacNeovimInMfs()
 let g:convension_path = $BACKEND_LARAVEL_MAC_DIR . "/laravel/CONVENTION.md"
endif
nnoremap <silent> <leader>ar :AiderRun<CR>
nnoremap <silent> <leader>aa :AiderAddCurrentFile<CR>
nnoremap <silent> <leader>aw :AiderAddWeb<CR>
nnoremap <silent> <leader>ap :AiderSendPromptWithInput<CR>
nnoremap <silent> <leader>ax :AiderExit<CR>
vmap <leader>av :AiderVisualTextWithPrompt<CR>

" keymap
tnoremap ii <C-\><C-n>

