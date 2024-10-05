" register compoments:
let g:loaded_lightline_powerful = 1

if !exists('g:lightline')
  let g:lightline = {}
  let g:lightline.component = {}
endif

set showtabline=2
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'component_type': {
      \     'linter_checking': 'right',
      \     'linter_infos': 'right',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'right',
      \ },
      \ 'tabline': {
      \   'left': [ ['gitbranch', 'gitstatus'], ['file_size'], ['char_num'], ['nearestmethodorfunction']],
      \   'right': [ ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok'] ]
      \ },
      \ 'component_function': {
      \   'gitstatus': 'gina#component#status#preset',
      \   'gitbranch': 'gina#component#repo#branch',
      \   'gitroot': 'gina#component#repo#name',
      \   'file_size': 'File_size',
      \   'char_num': 'CountCharInBuffer',
      \   'nearestmethodorfunction': 'NearestMethodOrFunction',
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
      \ }

let g:lightline.component_expand = {
      \  'buffers': 'lightline#bufferline#buffers',
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_infos': 'lightline#ale#infos',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }

let g:lightline.active = {
      \   'left': [
      \     ['mode', 'paste'],
      \     ['filename'],
      \   ],
      \   'right': [
      \     ['percent'],
      \     ['fileformat', 'fileencoding', 'filetype'],
      \     ['readonly'],
      \   ]
      \ }
let g:lightline#bufferline#enable_devicons = 1

let g:lightline#ale#indicator_checking = ""

let g:lightline#ale#indicator_infos = " :"

let g:lightline#ale#indicator_warnings = ": "

let g:lightline#ale#indicator_errors = ": "

let g:lightline#ale#indicator_ok = "OK: "

let s:p = g:lightline#colorscheme#wombat#palette

let s:p.tabline.left = [ ['#444444', '#8ac6f2', 21, 231, 'bold' ], [ '#d0d0d0', '#585858', 231, 21 ], ['#000000',  '#ffffff', 231, 21, 'bold' ] ]

" endif

function! NearestMethodOrFunction()
  if g:IsWindowsGvim()
    return ''
  endif

  if &filetype == 'vim' || &filetype == 'php' || &filetype == 'typescript' || &filetype == 'javascript'
    return ''.get(b:,'coc_current_function','')
  endif
  return ' :No Function'
endfunction

" By default vista.vim never run if you don't call it explicitly.
"
" If you want to show the nearest function in your statusline automatically,
" you can add the following line to your vimrc
autocmd BufWritePost,VimEnter,InsertEnter,ModeChanged,InsertLeave,CmdwinLeave,CursorMoved * call NearestMethodOrFunction()
" autocmd VimEnter,TextChanged,TextChangedI,CursorHold,CursorMoved,InsertEnter * call lightline#update()
autocmd User CocStatusChange redraws

function! File_size()
  let l:size = getfsize(expand(@%))
  if l:size == 0 || l:size == -1 || l:size == -2
    return ''
  endif
  if l:size < 1024
    return l:size.' bytes'
  elseif l:size < 1024*1024
    return printf('%.1f', l:size/1024.0).'k'
  elseif l:size < 1024*1024*1024
    return printf('%.1f', l:size/1024.0/1024.0) . 'm'
  else
    return printf('%.1f', l:size/1024.0/1024.0/1024.0) . 'g'
  endif
endfunction

function CountCharInBuffer() abort
  if &filetype == 'changelog' || &filetype == 'text' || &filetype == 'ddu-ff-filter' || &filetype == 'ddu-filer' || &filetype == 'vim-plug' || &filetype == ''
    return ''
  endif

  let l:num_newline = s:count_newline()
  if wordcount().chars == -1
    return 0
  endif
  if wordcount().chars == 2
    return 1
  endif

  return wordcount().chars - 1 - l:num_newline . '文字'
endfunction
command! -range CountChar call s:count_char() 

function s:count_newline()
  if line('$') == 1
    return 0
  endif

  return line('$') - 1
endfunction
