let g:syntastic_enable_signs = 1
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_mode_map  =  {
  \ 'mode': 'active', 
  \ 'active_filetypes': ['php']
  \}
let g:syntastic_auto_loc_list  =  1
" let g:syntastic_php_checkers  =  ['phpcs', 'php']
let g:syntastic_php_checkers  =  ['php']
let g:syntastic_php_phpcs_args = '--standard=psr2'

autocmd ColorScheme * highlight SyntasticErrorSign guifg=yellow guibg=red
autocmd ColorScheme * highlight SyntasticErrorLine guifg=orange guibg=SlateGrey

