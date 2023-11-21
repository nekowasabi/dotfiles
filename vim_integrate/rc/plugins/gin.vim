let g:gin_proxy_apply_without_confirm = 1

nnoremap <silent> ,gs :GinStatus<CR>
nnoremap <silent> ,gl :GinLog<CR>
nnoremap <silent> ,gc :Gin commit<CR>
nnoremap <silent> ,gp :Gin push<CR>
nnoremap <silent> ,gb :GinBranch<CR>
" call gin#custom#mapping#nmap(
"      \ 'branch', 'n',
"      \ '<Plug>(gin-branch-new)',
"      \ {'silent': 1},
"      \)

