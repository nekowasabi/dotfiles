" aider.vim
let g:aider_command = 'aider --no-auto-commits'
let g:aider_split_direction = 'split'
let g:aider_floatwin_width = 100
let g:aider_floatwin_height = 20
let g:convension_path = "~/.config/nvim/plugged/aider.vim/CONVENTION.md"
nnoremap <silent> <leader>ar :AiderRun<CR>
nnoremap <silent> <leader>aa :AiderAddCurrentFile<CR>
nnoremap <silent> <leader>aw :AiderAddWeb<CR>
nnoremap <silent> <leader>ap :AiderSendPromptWithInput<CR>
nnoremap <silent> <leader>ax :AiderExit<CR>
vmap <leader>av :AiderVisualTextWithPrompt<CR>

" keymap
tnoremap ii <C-\><C-n>

