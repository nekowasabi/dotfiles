nnoremap <silent> ,uu :call RunTestNearest()<CR>
function! RunTestNearest()
  let g:test#custom_transformations = {'docker': function('DockerTransformNearest')}
  let g:test#transformation = 'docker'
  execute "TestNearest"
endfunction
function! DockerTransformNearest(cmd) abort
  let l:filename = fnamemodify(expand("%:p"), ":t")
  let l:fullpath = expand("%:p")
  let l:pattern = 'tests.*'
  let l:filepath = matchstr(l:fullpath, l:pattern)

  if l:filename =~ ".*Test\.php"
    if g:IsMacNeovimInWork() || g:IsWsl()
			cd $BACKEND_LARAVEL_MAC_DIR
      return "docker exec -i $BACKEND_APP ./vendor/bin/phpunit --testdox --color --filter ".cfi#format("%s", ""). " ".l:filepath
    endif
    return
  endif

  return "docker exec -i $BACKEND_APP ./vendor/bin/phpunit --testdox --color ./tests"
endfunction


nnoremap <silent> ,uf :call RunTestFile()<CR>
function! RunTestFile()
  let g:test#custom_transformations = {'docker': function('DockerTransformFile')}
  let g:test#transformation = 'docker'
  execute "TestFile"
endfunction
function! DockerTransformFile(cmd) abort
  let l:filename = fnamemodify(expand("%:p"), ":t")
  let l:fullpath = expand("%:p")
  let l:pattern = 'tests.*'
  let l:filepath = matchstr(l:fullpath, l:pattern)

  if l:filename =~ ".*Test\.php"
    if g:IsMacNeovimInWork() || g:IsWsl()
			cd $BACKEND_LARAVEL_MAC_DIR
      return "docker exec -i $BACKEND_APP ./vendor/bin/phpunit --testdox --color ".l:filepath
    endif
    return
  endif

  return "docker exec -i $BACKEND_APP ./vendor/bin/phpunit --testdox --color ./tests"
endfunction

nnoremap <silent> ,ul :TestLast<CR>
nnoremap <silent> ,us :TestSuite<CR>
nnoremap <silent> ,uv :TestVisit<CR>

" let test#javascript#denotest#options = ' --allow-env --allow-run --allow-net '

let test#strategy = {
  \ 'nearest': 'neovim',
  \ 'file':    'neovim_sticky',
  \ 'suite':   'basic',
\}

" phpunitのコマンドを出力する
function! s:OutputPhpUnitCommand()
  let l:filename = fnamemodify(expand("%:p"), ":t")
  let l:fullpath = expand("%:p")
  let l:pattern = 'tests.*'
  let l:filepath = matchstr(l:fullpath, l:pattern)

  if l:filename =~ ".*Test\.php"
    if g:IsMacNeovimInWork() || g:IsWsl()
			cd $BACKEND_LARAVEL_MAC_DIR
      return "docker exec -i $BACKEND_APP ./vendor/bin/phpunit --testdox --color ".l:filepath
    endif
    return
  endif

  return "docker exec -i $BACKEND_APP ./vendor/bin/phpunit --testdox --color ./tests"
endfunction
