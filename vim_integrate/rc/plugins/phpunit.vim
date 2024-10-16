function! s:PHPUnitCurrentMethod()
  let l:filename = fnamemodify(expand("%:p"), ":t")
  let l:fullpath = expand("%:p")
  let l:pattern = 'tests.*'
  let l:filepath = matchstr(l:fullpath, l:pattern)

  if l:filename =~ ".*Test\.php"
    if g:IsMacNeovimInWork() || g:IsWsl()
			cd $BACKEND_LARAVEL_MAC_DIR
      execute "!./mac test --color --testdox --filter ".cfi#format("%s", ""). " ".l:filepath
      " execute "!docker exec -i $BACKEND_APP ./vendor/bin/phpunit --testdox --color --filter ".cfi#format("%s", ""). " ".l:filepath
    endif
    return
  endif
endfunction

command! PHPUnitCurrentMethod call s:PHPUnitCurrentMethod() 
nnoremap <silent> <Leader>u :PHPUnitCurrentMethod<CR>

function! s:PHPUnitCurrentMethodWithInitialize()
  let l:filename = fnamemodify(expand("%:p"), ":t")
  let l:fullpath = expand("%:p")
  let l:pattern = 'tests.*'
  let l:filepath = matchstr(l:fullpath, l:pattern)

  if l:filename =~ ".*Test\.php"
    if g:IsMacNeovimInWork()
			cd $BACKEND_LARAVEL_MAC_DIR
      execute "!./mac test --color --testdox --filter ".cfi#format("%s", ""). " ".l:filepath
    endif
    return
  endif
endfunction

command! PHPUnitCurrentMethodWithInitialize call s:PHPUnitCurrentMethodWithInitialize()() 

function! s:PHPUnitCurrentFile()
  let l:filename = fnamemodify(expand("%:p"), ":t")
  let l:fullpath = expand("%:p")
  let l:pattern = 'tests.*'
  let l:filepath = matchstr(l:fullpath, l:pattern)

  if l:filename =~ ".*Test\.php"
    if g:IsMacNeovimInWork()
			cd $BACKEND_LARAVEL_MAC_DIR
      execute "!./mac test --testdox --color " .l:filepath
      " execute "!docker exec -i $BACKEND_APP ./vendor/bin/phpunit --testdox --color " .l:filepath
    endif
    return
  endif

endfunction

command! PHPUnitCurrentFile call s:PHPUnitCurrentFile() 
nnoremap <silent> <Leader>U :PHPUnitCurrentFile<CR>

function! s:PHPUnitCurrentFileWithInitialize()
  let l:filename = fnamemodify(expand("%:p"), ":t")
  let l:fullpath = expand("%:p")
  let l:pattern = 'tests.*'
  let l:filepath = matchstr(l:fullpath, l:pattern)

  if l:filename =~ ".*Test\.php"
    if g:IsMacNeovimInWork()
			cd $BACKEND_LARAVEL_MAC_DIR
      execute "!./mac test --testdox --color " .l:filepath
    endif
    return
  endif

endfunction
command! PHPUnitCurrentFileWithInitialize call s:PHPUnitCurrentFileWithInitialize()() 

