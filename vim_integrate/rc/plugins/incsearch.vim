 " -----------------------------------------------------------
 " incsearch
nmap /  <Plug>(incsearch-forward)
nmap ?  <Plug>(incsearch-backward)

function! s:config_fuzzyall(...) abort
  return extend(copy({
  \   'converters': [
  \     incsearch#config#fuzzy#converter(),
  \     incsearch#config#fuzzyspell#converter()
  \   ],
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> <Leader>/ incsearch#go(<SID>config_fuzzyall())
noremap <silent><expr> <Leader>? incsearch#go(<SID>config_fuzzyall({'command': '?'}))

map g/ <Plug>(incsearch-migemo-/)
map g? <Plug>(incsearch-migemo-?)
