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
      \   'left': [ ['gitbranch', 'gitstatus'],  ['nearestmethodorfunction']],
      \   'right': [ ['file_size'], ['char_num'], ['lineinfo'] ],
      \   'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \   'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
      \ },
      \ 'component_function': {
      \   'gitstatus': 'gina#component#status#preset',
      \   'gitbranch': 'gina#component#repo#branch',
      \   'gitroot': 'gina#component#repo#name',
      \   'file_size': 'File_size',
      \   'mode': 'MyMode',
      \   'char_num': 'CountCharInBuffer',
      \   'filetype': 'MyFiletype',
      \   'fileformat': 'MyFileformat',
      \   'fileencoding': 'MyFileEncoding',
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
      \     ['mode', 'paste'], ['filename'],
      \   ],
      \   'right': [
      \     ['fileformat'],
      \     ['fileencoding'],
      \     ['filetype'],
      \     ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok'],
      \   ]
      \ }

let g:lightline.component = {
    \ 'lineinfo': 'L:%2l/%L'
    \ }

let g:lightline#bufferline#enable_devicons = 1

let g:lightline#ale#indicator_checking = "🔧"

let g:lightline#ale#indicator_infos = "ℹ️ :"

let g:lightline#ale#indicator_warnings = "⚠️ :"

let g:lightline#ale#indicator_errors = "❌ :"

let g:lightline#ale#indicator_ok = "✅ "

let s:p = g:lightline#colorscheme#wombat#palette

let s:p.normal.left = [
    \ ['#99FF99', '#1f8176', 247, 32, 'bold'],
    \ ['#b3b0a1', '#586e75', 247, 235],
    \ ['#93a1a1', '#073642', 244, 234]
\]

let s:p.normal.right = [
    \ ['#b3b0a1', '#1f8176', 247, 32, 'bold'],
    \ ['#FF8000', '#586e75', 247, 235],
    \ ['#00FFFF', '#073642', 244, 234],
    \ ['#80FF00', '#202020', 244, 234]
\]

let s:p.tabline.left = [
    \ ['#b3b0a1', '#1f8176', 247, 32, 'bold'],
    \ ['#b3b0a1', '#586e75', 247, 235],
    \ ['#93a1a1', '#073642', 244, 234]
\]

let s:p.tabline.right = [
    \ ['#b3b0a1', '#1f8176', 247, 32, 'bold'],
    \ ['#b3b0a1', '#586e75', 247, 235],
    \ ['#93a1a1', '#073642', 244, 234]
\]

function! NearestMethodOrFunction()
  if g:IsWindowsGvim()
    return ''
  endif

  if &filetype == 'vim' || &filetype == 'php' || &filetype == 'typescript' || &filetype == 'javascript'
    let l:raw_location = strpart(execute("lua print(require('lspsaga.symbol.winbar').get_bar())"), 1)
    " %#...# と %*% パターン、および単独の * を削除
    let l:cleaned_location = substitute(l:raw_location, '%#[^#]*#', '', 'g')
    let l:cleaned_location = substitute(l:cleaned_location, '%*%', '', 'g')
    let l:cleaned_location = substitute(l:cleaned_location, '\*', '', 'g')
    " 残った区切り文字やアイコン周りのスペースを整形
    let l:cleaned_location = substitute(l:cleaned_location, '\s*>\s*', ' > ', 'g') " 区切り文字 > の前後にスペースを1つ確保
    let l:cleaned_location = substitute(l:cleaned_location, '^\s*\|\s*$', '', 'g') " 先頭と末尾のスペースを削除
    let l:cleaned_location = substitute(l:cleaned_location, '\s\+', ' ', 'g') " 連続するスペースを1つに
    return l:cleaned_location
  endif
  return ' :No Function'
endfunction

function! MyMode()
  if mode() == 'n'
    return ''
  elseif mode() == 'v'
    return ''
  elseif mode() == 'i'
    return ''
  elseif mode() == 'R'
    return '󰑇'
  elseif mode() == 'c'
    return '󰘳'
  endif
endfunction

function! MyFiletype()
  if &filetype == 'octo'
    return ''
  endif
  return winwidth(0) > 1 ? (strlen(&filetype) ? WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyFileEncoding()
    return winwidth(0) > 1 ? (&encoding ==# 'utf-8' ? '󰬂' : '󱎤') : ''
endfunction

function! MyFileformat()
  return winwidth(0) > 1 ? (WebDevIconsGetFileFormatSymbol()) : ''
endfunction

" By default vista.vim never run if you don't call it explicitly.
"
" If you want to show the nearest function in your statusline automatically,
" you can add the following line to your vimrc
autocmd CursorHold * call lightline#update()
autocmd InsertEnter,InsertLeave,CursorMoved,CursorHold * call lightline#enable()
autocmd InsertEnter,InsertLeave,CursorMoved,CursorHold * call lightline#update()
autocmd InsertEnter,InsertLeave,CursorMoved,CursorHold * redraw
" autocmd User CocStatusChange redraws

" ファイルサイズを計算して返す関数
" @return {string} ファイルサイズを表す文字列
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

" バッファ内の文字数をカウントする関数
" 特定のファイルタイプの場合は空文字列を返す
" @return {string} 文字数を表す文字列
function CountCharInBuffer() abort
  let l:file_name = expand('%:t')
  if &filetype == 'changelog' || l:file_name == 'tenTask.txt' || &filetype == 'ddu-ff-filter' || &filetype == 'ddu-filer' || &filetype == 'vim-plug' || &filetype == ''
    return ''
  endif

  let l:num_newline = s:count_newline()
  if wordcount().chars == -1
    return 0
  endif
  if wordcount().chars == 2
    return 1
  endif

  return  'WC:'.(wordcount().chars - 1 - l:num_newline)
endfunction
command! -range CountChar call s:count_char() 

function s:count_newline()
  if line('$') == 1
    return 0
  endif

  return line('$') - 1
endfunction

augroup my-glyph-palette
  autocmd!
  " autocmd FileType php,vim,typescript call glyph_palette#apply()
  autocmd VimEnter,WinEnter,BufEnter * call glyph_palette#apply()
augroup END
