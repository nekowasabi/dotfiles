let g:gin_proxy_apply_without_confirm = 1

" nnoremap <silent> ,gs :GinStatus<CR>
" nnoremap <silent> ,gl :GinLog<CR>
" nnoremap <silent> ,gc :Gin commit<CR>
" nnoremap <silent> ,gp :Gin push<CR>
" nnoremap <silent> ,gb :GinBranch<CR>
nnoremap <silent> ,gd :GinDiff ++processor=delta\ --no-gitconfig\ --color-only<CR>

autocmd FileType gin-diff,gin-log,gin-status call s:SetGinKeymaps()
function! s:SetGinKeymaps()
  nnoremap <buffer> c :Gin commit<CR>
  nnoremap <buffer> s :GinStatus<CR>
  nnoremap <buffer> L :GinLog --graph --oneline<CR>
  nnoremap <buffer> d :GinDiff --cached<CR>
  " ウインドウを閉じないように設定
  nnoremap <buffer> q :Sayonara<CR>
  nnoremap <buffer> p :lua vim.notify("Gin push")<CR>:Gin push<CR>
  nnoremap <buffer> P :lua vim.notify("Gin pull")<CR>:Gin pull<CR>
endfunction

autocmd FileType gin-status call s:SetGinStatusKeymaps()
function! s:SetGinStatusKeymaps()
  nnoremap <buffer> h <Plug>(gin-action-stage)
  nnoremap <buffer> l <Plug>(gin-action-unstage)
endfunction
