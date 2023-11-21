" changelog
runtime ftplugin/changelog.vim
let g:changelog_username = "takets <nolifeking00@gmail.com>"
let g:changelog_new_date_format = "%d  %u\n\n\t* %c\n\n" 
let g:changelog_date_entry_search = '^\s*%d\_s*%u'       
runtime ftplugin/changelog.vim
autocmd FileType vim set formatoptions=q
autocmd FileType changelog set tabstop=2 noexpandtab formatoptions=q

" shd
autocmd FileType shd set tabstop=2
autocmd FileType shd set formatoptions=q

" vimscript
autocmd FileType vim set tabstop=2 shiftwidth=2

" ruby
autocmd FileType ruby set tabstop=2 shiftwidth=2
autocmd FileType ruby.itamae set tabstop=2 shiftwidth=2 expandtab

" typescript
autocmd FileType typescript set tabstop=2 shiftwidth=2

" html
autocmd FileType html set tabstop=2 shiftwidth=2

" twitvim
autocmd FileType twitvim set wrap
