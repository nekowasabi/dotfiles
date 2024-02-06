" coc.nvim

" codeium
" let g:codeium_disable_bindings = 1
" imap <script><silent><nowait><expr> <C-l> codeium#Accept()

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#_select_confirm()
   \: "\<C-g>u" . lexima#expand('<LT>CR>', 'i')

inoremap <silent><expr> <C-n> coc#pum#visible() ? coc#pum#next(1) : "\<C-n>"
inoremap <silent><expr> <C-p> coc#pum#visible() ? coc#pum#prev(1) : "\<C-p>"
inoremap <silent><expr> <down> coc#pum#visible() ? coc#pum#next(0) : "\<down>"
inoremap <silent><expr> <up> coc#pum#visible() ? coc#pum#prev(0) : "\<up>"

let g:coc_global_extensions = [
  \  'coc-json'
  \, 'coc-lists'
  \, 'coc-sql'
  \, 'coc-eslint'
  \, 'coc-tsserver'
  \, 'coc-diagnostic'
  \, 'coc-vimlsp'
  \, 'coc-git'
  \, 'coc-github-users'
  \, '@yaegassy/coc-intelephense'
  \, '@yaegassy/coc-laravel'
  \, '@yaegassy/coc-phpstan'
  \, '@yaegassy/coc-typescript-vue-plugin'
  \, 'coc-swagger'
  \, '@yaegassy/coc-volar-tools'
  \, '@yaegassy/coc-volar'
  \, 'coc-php-cs-fixer'
  \, 'coc-fzf-preview'
  \, 'coc-sh'
  \, 'coc-db'
  \, 'coc-yaml'
  \ ]

let g:markdown_fenced_languages = [
     \ 'vim',
     \ 'help'
     \]

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

imap <silent><expr> <TAB>
     \ coc#pum#visible() ? coc#pum#next(1):
     \ <SID>check_back_space() ? "\<Tab>" :
     \ coc#refresh()
imap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

let g:coc_snippet_next = '<tab>'

" Remap keys for gotos
nmap <silent> <Leader>cd <Plug>(coc-definition)
nmap <silent> <Leader>cy <Plug>(coc-type-definition)
nmap <silent> <Leader>ci <Plug>(coc-implementation)
nmap <silent> <Leader>cr <Plug>(coc-references)
nmap <silent> <Leader>cn <Plug>(coc-rename)
nmap <silent> <Leader>cf <Plug>(coc-format)
vmap <silent> <Leader>cf <Plug>(coc-format)
nmap <silent> <Leader>R  <Plug>(coc-refactor)

nnoremap <silent> <space>cla  :<C-u>CocFzfList diagnostics<CR>
nnoremap <silent> <space>clb  :<C-u>CocFzfList diagnostics --current-buf<CR>
nnoremap <silent> <space>clc  :<C-u>CocFzfList commands<CR>
nnoremap <silent> <space>cle  :<C-u>CocFzfList extensions<CR>
nnoremap <silent> <space>cls  :<C-u>CocFzfList symbols<CR>
nnoremap <silent> <space>clS  :<C-u>CocFzfList services<CR>
nnoremap <silent> <space>clp  :<C-u>CocFzfListResume<CR>

nnoremap <silent> <space>o  :<C-u>CocFzfList outline<CR>

nmap <silent> <Leader>gA <Plug>(coc-codeaction)
nmap <silent> <Leader>ga <Plug>(coc-codeaction-line)
xmap <silent> <Leader>ga <Plug>(coc-codeaction-selected)
nmap <silent> <leader>ca <Plug>(coc-codeaction-cursor)
let g:coc_fzf_opts = ['--layout=reverse']
let g:fzf_layout = { 'up': '~40%' }
let g:fzf_layout = { 'window': { 'width': 0.7, 'height': 0.6,} }

" Use K to show documentation in preview window
nnoremap <silent> <Leader>ck :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

augroup command_window
    function! ReInitCoc()
        execute("CocDisable")
        execute("CocEnable")
    endfunction
    autocmd CmdwinEnter * startinsert
    autocmd CmdwinEnter * call ReInitCoc()
augroup END
