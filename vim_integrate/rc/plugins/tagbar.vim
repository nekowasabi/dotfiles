" -----------------------------------------------------------
" TagBar
let g:tagbar_width = 35
let g:tagbar_autoshowtag = 1
let g:tagbar_autofocus = 0
let g:tagbar_left = 1
highlight TagbarScope ctermfg=5
highlight TagbarType cterm=bold ctermfg=55
highlight TagbarHighlight cterm=bold,underline ctermfg=1
highlight TagbarSignature ctermfg=70
nnoremap <silent> tb :<C-U>TagbarToggle<CR>

let g:tagbar_type_typescript = {
      \ 'ctagsbin' : 'tstags',
      \ 'ctagsargs' : '-f-', 
      \ 'kinds': [
      \ 'e:enums:0:1',
      \ 'f:function:0:1',
      \ 't:typealias:0:1',
      \ 'M:Module:0:1',
      \ 'I:import:0:1',
      \ 'i:interface:0:1',
      \ 'C:class:0:1',
      \ 'm:method:0:1',
      \ 'p:property:0:1',
      \ 'v:variable:0:1',
      \ 'c:const:0:1',
      \ ],
      \ 'sort' : 0
      \ }


