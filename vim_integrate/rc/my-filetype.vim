augroup fileTypeIndent
  autocmd!
  autocmd BufWinEnter,BufNewFile,BufRead *.php,*.inc setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd BufWinEnter,BufNewFile,BufRead *Test.php setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype changelog,text,shd setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab autoindent formatoptions=q tw=0
  autocmd BufNewFile,BufRead changelog,text,shd set tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab autoindent nospell
  autocmd BufWinEnter,BufNewFile *.js.tpl setlocal filetype=javascript tabstop=4 softtabstop=4 shiftwidth=4
  autocmd BufWinEnter,BufNewFile *.ts setlocal filetype=typescript tabstop=2 softtabstop=2 shiftwidth=2
  autocmd FileType twitvim resize 100
  autocmd InsertCharPre fzf redraw
  autocmd BufNewFile,BufRead json set tabstop=2 softtabstop=2 shiftwidth=2 expandtab autoindent
  autocmd BufNewFile,BufRead,BufWinEnter,BufNewFile *.js setlocal filetype=javascript tabstop=4 softtabstop=4 shiftwidth=4 expandtab
  autocmd BufWinEnter,BufNewFile,BufRead *.dbout setlocal foldmethod=marker
  autocmd BufRead,BufNewFile changelogmemo setfiletype changelog|setlocal commentstring=%s
  autocmd FileType gitcommit resize 100 set fileencoding=utf-8
  autocmd BufRead,BufNewFile old_changelogmemo setfiletype changelog|setlocal commentstring=%s
  autocmd BufRead,BufNewFile * redraw
  autocmd BufRead,BufNewFile *.{shd} setfiletype shd|setlocal commentstring=%s noexpandtab autoindent
  autocmd BufRead,BufNewFile *.{nodoka} setfiletype nodoka|setlocal commentstring=%s
  autocmd BufRead,BufNewFile .textlintrc setfiletype json|setlocal commentstring=%s
  autocmd FileType text set noexpandtab
  autocmd FileType markdown set tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab autoindent nospell conceallevel=0
  autocmd FileType vue syntax sync fromstart
	autocmd FileType php,blade let b:coc_root_patterns = ['.git', '.env', 'composer.json', 'artisan']
  au BufNewFile,BufRead *.blade.php set ft=blade tabstop=2 softtabstop=2 shiftwidth=2 expandtab autoindent

  let g:changelog_username = "takets <nolifeking00@gmail.com>"
augroup END



