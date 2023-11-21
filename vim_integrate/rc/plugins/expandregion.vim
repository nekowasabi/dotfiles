" " -----------------------------------------------------------
"" vim-expand-region
" キーマッピング
map <S-CR> <Plug>(expand_region_expand)
map <C-CR> <Plug>(expand_region_shrink)

" テキストオブジェクト
let g:expand_region_text_objects = {
      \ 'iw'  :0,
      \ 'iW'  :0,
      \ 'i"'  :0,
      \ 'i''' :0,
      \ 'i]'  :1,
      \ 'ib'  :1,
      \ 'iB'  :1,
      \ 'il'  :0,
      \ 'ip'  :0,
      \ 'ie'  :0,
      \ }

