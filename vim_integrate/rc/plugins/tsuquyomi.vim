" tsuquyomi
let g:tsuquyomi_completion_detail = 1
autocmd FileType typescript setlocal completeopt+=menu
autocmd FileType typescript setlocal completeopt+=preview
" autocmd FileType typescript setlocal completeopt+=menu,preview
let g:tsuquyomi_disable_quickfix = 1
let g:tsuquyomi_completion_case_sensitive = 1
" let g:tsuquyomi_shortest_import_path = 1

autocmd FileType typescript set omnifunc=tsuquyomi#complete

" set ballooneval
autocmd FileType typescript setlocal balloonexpr=tsuquyomi#balloonexpr()


