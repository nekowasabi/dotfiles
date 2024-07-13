" vim-dadbod
let g:dbs = {
\  'dev': $DADBOD
\ }

let g:db_ui_table_helpers = {
\   'postgresql': {
\     'Count': 'select count(*) from "{table}"',
\     'List': 'select * from "{table}" order by uuid asc'
\   }
\ }

let g:db_async = 1     
let g:db_ui_save_location = '~/dbui'
let g:db_ui_auto_execute_table_helpers = 1

autocmd FileType dbui nmap <buffer> o <Plug>(DBUI_SelectLine)
autocmd FileType sql nmap <buffer> W <Plug>(DBUI_SaveQuery)
