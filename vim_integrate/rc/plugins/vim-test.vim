" =============================================================================
" プロジェクトルート検索（macファイルが存在するディレクトリを検索）
" =============================================================================
function! s:FindProjectRoot() abort
  let l:dir = expand("%:p:h")
  while l:dir != "/"
    if filereadable(l:dir . "/mac")
      return l:dir
    endif
    let l:dir = fnamemodify(l:dir, ":h")
  endwhile
  return ""
endfunction

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

  " Python テスト（test_*.py）- 高速版（マイグレーションなし）
  if l:filename =~ "^test_.*\.py$"
    let l:project_root = s:FindProjectRoot()
    if l:project_root != ""
      execute "cd " . l:project_root
      " apps/ から始まる相対パスに変換
      let l:relative_cmd = substitute(a:cmd, '.*\(apps/.*\)', '\1', '')
      " FAST_TEST=1 --reuse-db --no-migrations で高速実行
      return "docker compose exec -e FAST_TEST=1 web pytest --reuse-db --no-migrations " . l:relative_cmd
    endif
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

  " Python テスト（test_*.py）- 高速版（マイグレーションなし）
  if l:filename =~ "^test_.*\.py$"
    let l:project_root = s:FindProjectRoot()
    if l:project_root != ""
      execute "cd " . l:project_root
      " apps/ から始まるパスを抽出
      let l:apps_path = matchstr(l:fullpath, 'apps/.*\.py$')
      " FAST_TEST=1 --reuse-db --no-migrations で高速実行
      return "docker compose exec -e FAST_TEST=1 web pytest --reuse-db --no-migrations " . l:apps_path . " -v"
    endif
  endif

  return "docker exec -i $BACKEND_APP ./vendor/bin/phpunit --testdox --color ./tests"
endfunction

" =============================================================================
" 通常版（DB毎回作成）: ,uU / ,uF
" =============================================================================
nnoremap <silent> ,uU :call RunTestNearestFull()<CR>
function! RunTestNearestFull()
  let g:test#custom_transformations = {'docker': function('DockerTransformNearestFull')}
  let g:test#transformation = 'docker'
  execute "TestNearest"
endfunction
function! DockerTransformNearestFull(cmd) abort
  let l:filename = fnamemodify(expand("%:p"), ":t")
  let l:fullpath = expand("%:p")

  " Python テスト（test_*.py）- DB毎回作成版
  if l:filename =~ "^test_.*\.py$"
    let l:project_root = s:FindProjectRoot()
    if l:project_root != ""
      execute "cd " . l:project_root
      let l:relative_cmd = substitute(a:cmd, '.*\(apps/.*\)', '\1', '')
      return "./mac test " . l:relative_cmd
    endif
  endif

  return a:cmd
endfunction

nnoremap <silent> ,uF :call RunTestFileFull()<CR>
function! RunTestFileFull()
  let g:test#custom_transformations = {'docker': function('DockerTransformFileFull')}
  let g:test#transformation = 'docker'
  execute "TestFile"
endfunction
function! DockerTransformFileFull(cmd) abort
  let l:filename = fnamemodify(expand("%:p"), ":t")
  let l:fullpath = expand("%:p")

  " Python テスト（test_*.py）- DB毎回作成版
  if l:filename =~ "^test_.*\.py$"
    let l:project_root = s:FindProjectRoot()
    if l:project_root != ""
      execute "cd " . l:project_root
      let l:apps_path = matchstr(l:fullpath, 'apps/.*\.py$')
      return "./mac test " . l:apps_path . " -v"
    endif
  endif

  return a:cmd
endfunction

nnoremap <silent> ,ul :TestLast<CR>
nnoremap <silent> ,us :TestSuite<CR>
nnoremap <silent> ,uv :TestVisit<CR>

" let test#javascript#denotest#options = ' --allow-env --amember_idsllow-run --allow-net '

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
