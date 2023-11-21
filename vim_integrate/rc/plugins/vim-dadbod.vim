let g:dbs = {
\  'dev': 'postgres://kf:kf123@postgres:5432/t-takeda'
\ }
let g:db_async = 1     
let g:db_ui_save_location = '~/dbui'

autocmd FileType dbui nmap <buffer> o <Plug>(DBUI_SelectLine)
autocmd FileType sql nmap <buffer> W <Plug>(DBUI_SaveQuery)
