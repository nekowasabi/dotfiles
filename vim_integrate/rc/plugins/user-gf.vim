" changelogへのリンクジャンプ
function! GfFile()
  " changelog {{{1
  if &filetype == 'changelog'
    let path = trim(matchstr(getline("."), 'CL.*:*[0-9]*'))
    if path != v:null
      let parts = split(path, ":")

      if parts[0] =~ "^.*CL.*"
        let cl_tag = parts[0]
        let line = parts[1]
      endif

      if g:IsMacGvim() && cl_tag == 'CL'
        let path = '/Users/takets/Dropbox/files/changelog/changelogmemo'
      elseif g:IsMacGvim() && cl_tag == 'CLO'
        let path = '/Users/takets/Dropbox/files/changelog/old_changelogmemo'
      endif

      if g:IsWindowsGvim() && cl_tag != ''
        let path = 'g:/dropbox/files/changelog/changelogmemo'
      elseif g:IsWindowsGvim() && cl_tag == 'CLO'
        let path = 'g:/dropbox/files/changelog/old_changelogmemo'
      endif

      return {
            \   'path': path,
            \   'line': line,
            \   'col': 0,
            \ }
    endif

    let line = 0
    if path =~# ':\d\+:\?$'
      let line = matchstr(path, '\d\+:\?$')
      let path = matchstr(path, '.*\ze:\d\+:\?$')
    endif
    if !filereadable(path)
      return 0
    endif
    return {
          \   'path': path,
          \   'line': line,
          \   'col': 0,
          \ }

  endif
  " }}}1
endfunction
call gf#user#extend('GfFile', 1000)

nmap gf         <Plug>(gf-user-gf)
xmap gf         <Plug>(gf-user-gf)
nmap gF         <Plug>(gf-user-gF)
xmap gF         <Plug>(gf-user-gF)

