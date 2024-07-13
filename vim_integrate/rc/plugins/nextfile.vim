" nextfile.vim  {{{2
let g:nf_ignore_ext = ['meta']
let g:nf_map_next = ''
let g:nf_map_previous = ''
let g:nf_include_dotfiles = 1
let g:nf_loop_files = 1
call submode#enter_with('nextfile', 'n', 'r', '<Leader>n', '<Plug>(nextfile-next)')
call submode#enter_with('nextfile', 'n', 'r', '<Leader>N', '<Plug>(nextfile-previous)')
call submode#map('nextfile', 'n', 'r', 'j', '<Plug>(nextfile-next)')
call submode#map('nextfile', 'n', 'r', 'k', '<Plug>(nextfile-previous)')
" }}}2

