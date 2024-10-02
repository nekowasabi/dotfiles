nnoremap <silent> ,uu :TestNearest<CR>
nnoremap <silent> ,uf :TestFile<CR>
nnoremap <silent> ,ul :TestLast<CR>
nnoremap <silent> ,us :TestSuite<CR>
nnoremap <silent> ,uv :TestVisit<CR>

let test#javascript#denotest#options = ' --allow-env --allow-run '

let test#strategy = {
  \ 'nearest': 'neovim',
  \ 'file':    'neovim_sticky',
  \ 'suite':   'basic',
\}

