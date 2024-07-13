" -----------------------------------------------------------
" easy-align
vmap A <Plug>(EasyAlign)

let g:easy_align_delimiters = {
      \ ' ': { 'pattern': ' ', 'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0 },
      \ '+': { 'pattern': '+', 'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
      \ '-': { 'pattern': '-', 'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
      \ '=': { 'pattern': '===\|<=>\|\(&&\|||\|<<\|>>\)=\|=\~[#?]\?\|=>\|[:+/*!%^=><&|.-]\?=[#?]\?',
      \ 'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
      \ ':': { 'pattern': ':', 'left_margin': 0, 'right_margin': 1, 'stick_to_left': 1 },
      \ ',': { 'pattern': ',', 'left_margin': 0, 'right_margin': 1, 'stick_to_left': 1 },
      \ '|': { 'pattern': '|', 'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
      \ '.': { 'pattern': '\.', 'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0 },
      \ '&': { 'pattern': '\\\@<!&\|\\\\', 'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
      \ '{': { 'pattern': '(\@<!{', 'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
      \ '}': { 'pattern': '}', 'left_margin': 1, 'right_margin': 0, 'stick_to_left': 0 },
      \ '\': { 'pattern': '\\', 'left_margin': 1, 'right_margin': 0, 'stick_to_left': 0 },
      \ '<': { 'pattern': '<', 'left_margin': 1, 'right_margin': 0, 'stick_to_left': 0 },
      \ 'd': { 'pattern': ' \(\S\+\s*[;=]\)\@=', 'left_margin': 0, 'right_margin': 0},
      \ '#': { 'pattern': '#', 'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
      \ '[': { 'pattern': '(\@<![', 'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
      \ ']': { 'pattern': ']', 'left_margin': 1, 'right_margin': 0, 'stick_to_left': 0 },
      \ }
" }}}


