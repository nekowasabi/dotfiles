let g:coc_global_extensions = [
  \  'coc-json'
  \, 'coc-lists'
	\, 'coc-eslint'
  \, 'coc-tsserver'
  \, 'coc-diagnostic'
  \, 'coc-git'
  \, 'coc-github-users'
  \, '@yaegassy/coc-intelephense'
  \, '@yaegassy/coc-laravel'
  \, '@yaegassy/coc-typescript-vue-plugin'
  \, '@yaegassy/coc-volar-tools'
  \, '@yaegassy/coc-volar'
  \, 'coc-sh'
  \, 'coc-yaml'
  \, 'coc-blade'
  \, 'coc-lua'
  \, 'coc-deno'
  \, '@hexuhua/coc-copilot'
  \, 'coc-stylua'
  \ ]

  " \, 'coc-swagger'
  " \, 'coc-vimlsp'
  " \, 'coc-biome'
  " \, 'coc-fzf-preview'
  " \, 'coc-php-cs-fixer'
  " \, '@yaegassy/coc-phpstan'

let g:markdown_fenced_languages = [
     \ 'vim',
     \ 'php=php',
     \ 'javascript',
     \ 'typescript',
     \ 'help'
     \]

let g:coc_fzf_opts = ['--layout=reverse']
let g:fzf_layout = { 'up': '~40%' }
let g:fzf_layout = { 'window': { 'width': 0.7, 'height': 0.6,} }
let g:coc_disable_startup_warning = 1

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#_select_confirm()
      \: "\<C-g>u" . lexima#expand('<LT>CR>', 'i')

inoremap <silent><expr> <C-n> coc#pum#visible() ? coc#pum#next(1):  "\<C-n>"
inoremap <silent><expr> <C-p> coc#pum#visible() ? coc#pum#prev(1):  "\<C-p>"
inoremap <silent><expr> <down> coc#pum#visible() ? coc#pum#next(0): "\<down>"
inoremap <silent><expr> <up> coc#pum#visible() ? coc#pum#prev(0):   "\<up>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

let g:coc_snippet_next = '<tab>'

nmap <silent> ,cd <Plug>(coc-definition)
nmap <silent> ,cy <Plug>(coc-type-definition)
nmap <silent> ,ci <Plug>(coc-implementation)
nmap <silent> ,cr <Plug>(coc-references)
nmap <silent> ,cn <Plug>(coc-rename)
nmap <silent> ,cf <Plug>(coc-format)
vmap <silent> ,cf <Plug>(coc-format)
nmap <silent> ,cR  <Plug>(coc-refactor)

nnoremap <silent> ,cla  :<C-u>CocFzfList diagnostics<CR>
nnoremap <silent> ,clb  :<C-u>CocFzfList diagnostics --current-buf<CR>
nnoremap <silent> ,clc  :<C-u>CocFzfList commands<CR>
nnoremap <silent> ,cle  :<C-u>CocFzfList extensions<CR>
nnoremap <silent> ,cls  :<C-u>CocFzfList symbols<CR>
nnoremap <silent> ,clS  :<C-u>CocFzfList services<CR>
nnoremap <silent> ,clp  :<C-u>CocFzfListResume<CR>
nmap <silent> ,caA <Plug>(coc-codeaction)
nmap <silent> ,cal <Plug>(coc-codeaction-line)
xmap <silent> ,cas <Plug>(coc-codeaction-selected)
nmap <silent> ,caa <Plug>(coc-codeaction-cursor)

autocmd FileType php,typescript,python,markdown,javascript,vim nnoremap <silent> ,co  :<C-u>CocFzfList outline<CR>

" Use K to show documentation in preview window
nnoremap <silent> ,ck :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Completion settings. {{{1
let g:coc_supported_filetypes = [
      \ 'vim',
      \ 'typescript',
      \ 'php',
      \ 'json',
      \ 'sh'
      \ ]
let g:coc_disabled_filetypes = ['noice', 'markdown', 'changelog', 'text']
let g:coc_toggle_delay = 1000
let g:is_coc_enabled = v:true

" Check if current filetype should enable Coc
function! s:ShouldEnableCoc() abort
  if &buftype != '' || !exists('g:did_coc_loaded')
    return v:false
  endif

  let l:is_target = index(g:coc_supported_filetypes, &filetype) >= 0
  let l:is_disabled = index(g:coc_disabled_filetypes, &filetype) >= 0

  return l:is_target && !l:is_disabled
endfunction

" Execute Coc commands with delay
function! s:ExecuteCocCommands(commands) abort
  call timer_start(g:coc_toggle_delay, {-> execute(join(a:commands, '|'))})
endfunction

" Toggle Coc based on filetype
function! ToggleCocByFileType() abort
  if s:ShouldEnableCoc()
    let l:commands = [
          \ 'execute "silent! CocEnable"',
          \ 'let g:your_cmp_disable_enable_toggle = v:false'
          \ ]
    let g:is_coc_enabled = v:true
  else
    if &filetype == 'vim'
      return
    endif
    let l:commands = [
          \ 'execute "silent! CocDisable"',
          \ 'let g:your_cmp_disable_enable_toggle = v:true'
          \ ]
    let g:is_coc_enabled = v:false
  endif

  call s:ExecuteCocCommands(l:commands)
endfunction


" Restore previous Coc state
function! RestoreCocByFileType() abort
  if exists('g:is_coc_enabled')
		if g:is_coc_enabled
			execute "silent! CocEnable"
		else
			let g:your_cmp_disable_enable_toggle = v:true
			execute "silent! CocDisable"
		endif
  endif
endfunction

" Autocommands for Coc toggle
augroup CocToggleForFileTypes
  autocmd!
  autocmd BufEnter * call ToggleCocByFileType()
  autocmd CmdLineLeave * call RestoreCocByFileType()
  autocmd CmdlineEnter * silent call OpenCommandLineByCmp()
augroup END
" }}}1

" Disable Coc for command line
function! OpenCommandLineByCmp() abort
  execute "silent! CocDisable"
  let g:your_cmp_disable_enable_toggle = v:true
endfunction

nnoremap <Leader>: :
