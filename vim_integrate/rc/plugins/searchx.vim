" dial.vim
if g:IsWindowsGvim()
  nmap  <C-a>  <Plug>(dps-dial-increment)
  nmap  <C-x>  <Plug>(dps-dial-decrement)
  xmap  <C-a>  <Plug>(dps-dial-increment)
  xmap  <C-x>  <Plug>(dps-dial-decrement)
  xmap g<C-a> g<Plug>(dps-dial-increment)
  xmap g<C-x> g<Plug>(dps-dial-decrement)
endif

" searchx
" Overwrite / and ?.
if g:IsWsl()
  " nnoremap <silent> g? :MigemoSearghxBackrward<CR>
  " nnoremap <silent> g/ :MigemoSearchxForward<CR>
  " nnoremap <silent> ? <Cmd>call searchx#start({ 'dir': 0 })<CR>
  " nnoremap <silent> / <Cmd>call searchx#start({ 'dir': 1 })<CR>
  " nnoremap <silent> r/ :RegexSearchxForward<CR>
  " nnoremap <silent> r? :RegexSearchxBackrward<CR>
  "
  " xnoremap <silent> g? <Cmd>call searchx#start({ 'dir': 0 })<CR>
  " xnoremap <silent> g/ <Cmd>call searchx#start({ 'dir': 1 })<CR>
  nnoremap <silent> ? :MigemoSearchxBackrward<CR>
  nnoremap <silent> / :MigemoSearchxForward<CR>
  nnoremap <silent> r/ :RegexSearchxForward<CR>
  nnoremap <silent> r? :RegexSearchxBackrward<CR>
  nnoremap <silent> g? <Cmd>call searchx#start({ 'dir': 0 })<CR>
  nnoremap <silent> g/ <Cmd>call searchx#start({ 'dir': 1 })<CR>

  xnoremap <silent> ? :MigemoSearchxBackrward<CR>
  xnoremap <silent> / :MigemoSearchxForward<CR>
  xnoremap <silent> g? <Cmd>call searchx#start({ 'dir': 0 })<CR>
  xnoremap <silent> g/ <Cmd>call searchx#start({ 'dir': 1 })<CR>

else
  nnoremap <silent> ? :MigemoSearchxBackrward<CR>
  nnoremap <silent> / :MigemoSearchxForward<CR>
  nnoremap <silent> r/ :RegexSearchxForward<CR>
  nnoremap <silent> r? :RegexSearchxBackrward<CR>
  nnoremap <silent> g? <Cmd>call searchx#start({ 'dir': 0 })<CR>
  nnoremap <silent> g/ <Cmd>call searchx#start({ 'dir': 1 })<CR>

  " Note: / and ? mappings are handled by hellshake-yano.vim via key_commands
  " xnoremap <silent> ? :MigemoSearchxBackrward<CR>
  " xnoremap <silent> / :MigemoSearchxForward<CR>
  xnoremap <silent> g? <Cmd>call searchx#start({ 'dir': 0 })<CR>
  xnoremap <silent> g/ <Cmd>call searchx#start({ 'dir': 1 })<CR>
endif
" Move to next/prev match.
nnoremap <silent> N <Cmd>call searchx#prev_dir()<CR>
nnoremap <silent> n <Cmd>call searchx#next_dir()<CR>
xnoremap <silent> N <Cmd>call searchx#prev_dir()<CR>
xnoremap <silent> n <Cmd>call searchx#next_dir()<CR>

let g:searchx = {}

" To enable auto nohlsearch after cursor is moved
let g:searchx.nohlsearch = {}
let g:searchx.nohlsearch.jump = v:true

" Auto jump if the recent input matches to any marker.
let g:searchx.auto_accept = v:true

" Marker characters.
let g:searchx.markers = split('ABCDEFGHIJKLMNOPQRSTUVWXYZ', '.\zs')

" The scrolloff value for moving to next/prev.
let g:searchx.scrolloff = &scrolloff

" To enable scrolling animation.
let g:searchx.scrolltime = 0


" migmeo setting
let g:migemo_length = 4
let g:is_migemo = v:false

" let g:is_migemo = v:false
function! s:MigemoSearchxForward() abort
	let g:is_migemo = v:true
  let g:searchx.convert = g:searchx.migemo
	exe "call searchx#start({ 'dir': 1 })"
endfunction
command! -range MigemoSearchxForward call s:MigemoSearchxForward() 

function! s:MigemoSearchxBackrward() abort
	let g:is_migemo = v:true
  let g:searchx.convert = g:searchx.migemo
	exe "call searchx#start({ 'dir': 1 })"
endfunction
command! -range MigemoSearchxBackrward call s:MigemoSearchxBackrward() 
  
function! s:SearchxForward() abort
	exe "call searchx#start({ 'dir': 1 })"
endfunction
command! -range SearchxForward call s:SearchxForward() 

function! s:SearchxBackrward() abort
	exe "call searchx#start({ 'dir': 0 })"
endfunction
command! -range SearchxBackrward call s:SearchxBackrward() 

function! s:RegexSearchxForward() abort
  let g:searchx.convert = g:searchx.regex
  exe "call searchx#start({ 'dir': 1 })"
endfunction
command! -range RegexSearchxForward call s:RegexSearchxForward()

function! s:RegexSearchxBackrward() abort
  let g:searchx.convert = g:searchx.regex
  exe "call searchx#start({ 'dir': 0 })"
endfunction
command! -range RegexSearchxBackrward call s:RegexSearchxBackrward()

function! g:searchx.regex(input) abort
  return '\m' .. escape(a:input, '/')
endfunction

function! g:searchx.migemo(input) abort
  let l:input = ''
	if len(a:input) >= g:migemo_length
    " if g:IsLinux()
    "   let l:input = system('/usr/bin/cmigemo -v -w "'.a:input.'" -d "'.g:migemodict.'"')
    " else
      let l:input = system('cmigemo -v -w "'.a:input.'" -d "'.g:migemodict.'"')
    " endif
  else
    let l:input = a:input
	endif

  if l:input !~# '\k'
    return '\V' .. l:input
  endif

  return join(split(l:input, ' '), '.\{-}')
endfunction



function! g:searchx.convert(input) abort
  let l:input = ''
	if len(a:input) >= g:migemo_length && g:is_migemo
    " if g:IsLinux()
    "   let l:input = system('/usr/bin/cmigemo -v -w "'.a:input.'" -d "'.g:migemodict.'"')
    " else
      let l:input = system('cmigemo -v -w "'.a:input.'" -d "'.g:migemodict.'"')
    " endif
  else
    let l:input = a:input
	endif

  if l:input !~# '\k'
    return '\V' .. l:input
  endif

  if l:input =~# ';'
    let max_score = 0
    for q in s:fuzzy_query(l:input)
      let targets = denops#request('fuzzy-motion', 'targets', [q])

      if len(targets) > 0 && targets[0].score > max_score
        let max_score = targets[0].score
        let fuzzy_input = join(split(q, ' '), '.\{-}')
      endif
    endfor

    return fuzzy_input ==# '' ? l:input : fuzzy_input
  endif

  return join(split(l:input, ' '), '.\{-}')
endfunction


" misc {{{1
function! s:has(list, value) abort
  return index(a:list, a:value) isnot -1
endfunction

function! s:_get_unary_caller(f) abort
  return type(a:f) is type(function('function'))
  \        ? function('call')
  \        : function('s:_call_string_expr')
endfunction

function! s:_call_string_expr(expr, args) abort
  return map([a:args[0]], a:expr)[0]
endfunction

function! s:sort(list, f) abort
  if type(a:f) is type(function('function'))
    return sort(a:list, a:f)
  else
    let s:sort_expr = a:f
    return sort(a:list, 's:_compare_by_string_expr')
  endif
endfunction

function! s:_compare_by_string_expr(a, b) abort
  return eval(s:sort_expr)
endfunction

function! s:uniq(list) abort
  return s:uniq_by(a:list, 'v:val')
endfunction

function! s:uniq_by(list, f) abort
  let l:Call  = s:_get_unary_caller(a:f)
  let applied = []
  let result  = []
  for x in a:list
    let y = l:Call(a:f, [x])
    if !s:has(applied, y)
      call add(result, x)
      call add(applied, y)
    endif
    unlet x y
  endfor
  return result
endfunction

function! s:product(lists) abort
  let result = [[]]
  for pool in a:lists
    let tmp = []
    for x in result
      let tmp += map(copy(pool), 'x + [v:val]')
    endfor
    let result = tmp
  endfor
  return result
endfunction

function! s:permutations(list, ...) abort
  if a:0 > 1
    throw 'vital: Data.List: too many arguments'
  endif
  let r = a:0 == 1 ? a:1 : len(a:list)
  if r > len(a:list)
    return []
  elseif r < 0
    throw 'vital: Data.List: {r} must be non-negative integer'
  endif
  let n = len(a:list)
  let result = []
  for indices in s:product(map(range(r), 'range(n)'))
    if len(s:uniq(indices)) == r
      call add(result, map(indices, 'a:list[v:val]'))
    endif
  endfor
  return result
endfunction

function! s:combinations(list, r) abort
  if a:r > len(a:list)
    return []
  elseif a:r < 0
    throw 'vital: Data.List: {r} must be non-negative integer'
  endif
  let n = len(a:list)
  let result = []
  for indices in s:permutations(range(n), a:r)
    if s:sort(copy(indices), 'a:a - a:b') == indices
      call add(result, map(indices, 'a:list[v:val]'))
    endif
  endfor
  return result
endfunction

function! s:fuzzy_query(input) abort
  if match(a:input, ';') == -1
    return [a:input]
  endif

  let input = substitute(a:input, ';', '', 'g')
  let trigger_count = len(a:input) - len(input)

  let arr = range(1, len(input) - 1)

  let result = []
  for ps in s:combinations(arr, trigger_count)
    let ps = reverse(ps)
    let str = input
    for p in ps
      let str = str[0 : p - 1] . ' ' . str[p : -1]
    endfor
    let result += [str]
  endfor

  return result
endfunction

if g:IsMacNeovim()
  let g:migemodict = '/usr/local/Cellar/cmigemo/20110227/share/migemo/utf-8/migemo-dict'
endif

if g:IsWindowsGvim()
  let g:migemodict = 'c:\tools\vim\vim90\dict\utf-8\migemo-dict'
endif

if g:IsWsl()
  let g:migemodict = '/home/linuxbrew/.linuxbrew/Cellar/cmigemo/20110227/share/migemo/utf-8/migemo-dict'
endif

" if g:IsLinux()
"   let g:migemodict = '/home/linuxbrew/.linuxbrew/Cellar/cmigemo/20110227/share/migemo/utf-8/migemo-dict'
" endif

if g:IsMacNeovimInWork()
  let g:migemodict = '/opt/homebrew/Cellar/cmigemo/20110227/share/migemo/utf-8/migemo-dict'
endif

" }}}1
