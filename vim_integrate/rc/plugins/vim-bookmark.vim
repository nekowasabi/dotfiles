let g:bookmark_no_default_key_mappings = 1

nmap mt <Plug>BookmarkToggle
nmap ma <Plug>BookmarkAnnotate
nmap ms <Plug>BookmarkShowAll
nmap mj <Plug>BookmarkNext
nmap mk <Plug>BookmarkPrev
nmap mc <Plug>BookmarkClear
nmap mx <Plug>BookmarkClearAll
nmap mg <Plug>BookmarkMoveToLine

let g:bookmark_save_per_working_dir = 0
let g:bookmark_auto_save = 1

let g:bookmark_sign = '>>'
let g:bookmark_annotation_sign = '##'
