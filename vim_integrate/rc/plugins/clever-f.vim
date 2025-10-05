 " -----------------------------------------------------------
 " clever-f
" Note: f and F normal mode mappings are handled by hellshake-yano.vim via keyCommands
" nmap f <Plug>(clever-f-f)
xmap f <Plug>(clever-f-f)
omap f <Plug>(clever-f-f)
" nmap F <Plug>(clever-f-F)
xmap F <Plug>(clever-f-F)
omap F <Plug>(clever-f-F)

let g:clever_f_not_overwrites_standard_mappings = 1
let g:clever_f_ignore_case                      = 1
let g:clever_f_smart_case                       = 1
let g:clever_f_across_no_line                   = 1
let g:clever_f_use_migemo                       = 1
let g:clever_f_mark_char_color                  = 'Clever_f_mark_char'

highlight default Clever_f_mark_char ctermfg=Green ctermbg=NONE cterm=underline guifg=Red   guibg=Black  gui=NONE
