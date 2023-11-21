function! s:PHPUnitCurrentMethod()
  let l:filename = fnamemodify(expand("%:p"), ":t")

  if l:filename =~ ".*Test\.php"
    if g:IsWsl()
      execute ":!docker exec -w /var/www/sp2-php -i sp2-php-app-1 /var/www/sp2-php/vendor/phpunit/phpunit/phpunit --color --filter=".cfi#format("%s", ""). " /var/www/sp2-php/%"
    else
      execute ":!/home/kf/app/vendor/bin/phpunit -c /home/kf/app/phpunit.xml --color --filter=".cfi#format("%s", ""). " %"
    endif
    return
  endif
endfunction

command! PHPUnitCurrentMethod call s:PHPUnitCurrentMethod() 
nnoremap <silent> <Leader>u :PHPUnitCurrentMethod<CR>

function! s:PHPUnitCurrentFile()
  let l:filename = fnamemodify(expand("%:p"), ":t")

  if l:filename =~ ".*Test\.php"
    if g:IsWsl()
      execute ":!docker exec -w /var/www/sp2-php -i sp2-php-app-1 /var/www/sp2-php/vendor/phpunit/phpunit/phpunit /var/www/sp2-php/%"
    else
      execute ":!/home/kf/app/vendor/bin/phpunit -c /home/kf/app/phpunit.xml --color --filter=".cfi#format("%s", ""). " %"
    endif
    return
  endif
endfunction

command! PHPUnitCurrentFile call s:PHPUnitCurrentFile() 
nnoremap <silent> <Leader>U :PHPUnitCurrentFile<CR>
