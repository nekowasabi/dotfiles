func! Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc
iabbr <silent> koko ----- kokomade<C-R>=Eatchar('\s')<CR>
iabbr <silent> tc taskchute<C-R>=Eatchar('\s')<CR>
iabbr <expr> forr 'for(int i=0; i<len; i++) '."\<esc>".repeat('h',10)
iabbr <silent> lnk /Users/takets/Dropbox/files/changelog/changelogmemo  :  <C-R>=Eatchar('\s')<CR>

cabbr <silent> oie Octo issue edit 

augroup my_vimrc
  autocmd FileType sql iabbrev <buffer> select SELECT
  autocmd FileType sql iabbrev <buffer> from FROM
  autocmd FileType sql iabbrev <buffer> where WHERE
  autocmd FileType sql iabbrev <buffer> order ORDER
  autocmd FileType sql iabbrev <buffer> by BY
  autocmd FileType sql iabbrev <buffer> and AND
  autocmd FileType sql iabbrev <buffer> or OR
  autocmd FileType sql iabbrev <buffer> inner INNER
  autocmd FileType sql iabbrev <buffer> join JOIN
  autocmd FileType sql iabbrev <buffer> on ON
  autocmd FileType sql iabbrev <buffer> in IN
  autocmd FileType sql iabbrev <buffer> when WHEN
  autocmd FileType sql iabbrev <buffer> case CASE
  autocmd FileType sql iabbrev <buffer> else ELSE
  autocmd FileType sql iabbrev <buffer> create CREATE
  autocmd FileType sql iabbrev <buffer> table TABLE
  autocmd FileType sql iabbrev <buffer> update UPDATE
  autocmd FileType sql iabbrev <buffer> insert INSERT
  autocmd FileType sql iabbrev <buffer> delete DELETE

  autocmd FileType changelog iabbrev <buffer> cl: CL: <C-R>=Eatchar('\s')<CR>
  autocmd FileType changelog iabbrev <buffer> clo: CLO: <C-R>=Eatchar('\s')<CR>

  autocmd FileType vue,javascript iabbrev <buffer> dg debugger;<C-R>=Eatchar('\s')<CR>
  autocmd FileType vue,javascript iabbrev <buffer> cn console.log('Canary');<C-R>=Eatchar('\s')<CR>
augroup END
