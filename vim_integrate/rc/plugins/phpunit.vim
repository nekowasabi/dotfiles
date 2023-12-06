function! s:PHPUnitCurrentMethod()
  let l:filename = fnamemodify(expand("%:p"), ":t")
  let l:fullpath = expand("%:p")
  let l:pattern = 'tests.*'
  let l:filepath = matchstr(l:fullpath, l:pattern)

  if l:filename =~ ".*Test\.php"
    if g:IsMacNeovimInMfs()
			cd $BACKEND_LARAVEL_MAC_DIR
      execute "!./mac test --color --filter ".cfi#format("%s", ""). " ".l:filepath
    endif
    return
  endif
endfunction

command! PHPUnitCurrentMethod call s:PHPUnitCurrentMethod() 
nnoremap <silent> <Leader>u :PHPUnitCurrentMethod<CR>

function! s:PHPUnitCurrentFile()
  let l:filename = fnamemodify(expand("%:p"), ":t")
  let l:fullpath = expand("%:p")
  let l:pattern = 'tests.*'
  let l:filepath = matchstr(l:fullpath, l:pattern)

  if l:filename =~ ".*Test\.php"
    if g:IsMacNeovimInMfs()
			cd $BACKEND_LARAVEL_MAC_DIR
      execute "!./mac test --color " .l:filepath
    endif
    return
  endif

endfunction

command! PHPUnitCurrentFile call s:PHPUnitCurrentFile() 
nnoremap <silent> <Leader>U :PHPUnitCurrentFile<CR>
