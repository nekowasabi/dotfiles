nnoremap <silent> ,gs :Gina status<CR>
nnoremap <silent> ,gl :Gina log<CR>
nnoremap <silent> ,gc :Gina commit<CR>
nnoremap <silent> ,gp :Gina push<CR>
nnoremap <silent> ,gb :Gina branch<CR>
call gina#custom#mapping#nmap(
      \ 'branch', 'n',
      \ '<Plug>(gina-branch-new)',
      \ {'silent': 1},
      \)

