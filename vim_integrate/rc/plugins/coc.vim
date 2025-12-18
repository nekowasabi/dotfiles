" coc.vim - CoC settings and completion engine switching

" ============================================================================
" CoC Startup Configuration
" ============================================================================

" Track CoC ready state
let g:coc_is_ready = 0

" Start CoC after VimEnter and listen for ready event
augroup CocStartup
  autocmd!
  autocmd User CocNvimInit call s:OnCocReady()
augroup END

" Called when CoC is fully initialized
function! s:OnCocReady() abort
  let g:coc_is_ready = 1
  lua vim.notify('coc.nvim ready!', vim.log.levels.INFO)
  " Re-apply completion engine for current buffer
  call s:ApplyCompletionEngineInternal()
endfunction

" ============================================================================
" Completion Engine Switching Logic
" ============================================================================

" Filetype configuration is defined in plugin.vim:
" g:coc_only_filetypes, g:cmp_only_filetypes, g:completion_disabled_filetypes

" Get completion engine for a given filetype
" Returns: 'coc', 'cmp', or 'none'
function! s:GetEngine(filetype) abort
  if index(g:completion_disabled_filetypes, a:filetype) >= 0
    return 'none'
  endif
  if index(g:coc_only_filetypes, a:filetype) >= 0
    return 'coc'
  endif
  " Default to cmp (including g:cmp_only_filetypes and unknown filetypes)
  return 'cmp'
endfunction

" Apply completion engine for current buffer (global wrapper)
function! ApplyCompletionEngine() abort
  call s:ApplyCompletionEngineInternal()
endfunction

" Apply completion engine for current buffer
function! s:ApplyCompletionEngineInternal() abort
  " Skip special buffers
  if &buftype != ''
    return
  endif

  let l:engine = s:GetEngine(&filetype)

  if l:engine ==# 'coc'
    call s:EnableCoc()
  elseif l:engine ==# 'cmp'
    call s:EnableCmp()
  else
    call s:DisableAll()
  endif
endfunction

" Enable CoC for current buffer
function! s:EnableCoc() abort
  " Skip if CoC is not loaded or not ready
  if !exists('g:did_coc_loaded') || !g:coc_is_ready
    return
  endif

  " Enable CoC
  CocEnable

  " Attach CoC to current buffer explicitly
  if exists('*CocAction')
    call CocAction('ensureDocument')
  endif

  " Disable cmp for this buffer
  lua vim.b.cmp_enabled = false

  " Set CoC's <CR> mapping for this buffer
  inoremap <buffer><silent><expr> <CR> coc#pum#visible() ? coc#_select_confirm() : "\<CR>"
endfunction

" Enable cmp for current buffer
function! s:EnableCmp() abort
  " Disable CoC for this buffer
  if exists('g:did_coc_loaded')
    try
      silent! CocDisable
    catch
      " coc.nvim内部エラーを無視
    endtry
  endif

  " Enable cmp for this buffer
  lua vim.b.cmp_enabled = true

  " Remove CoC's <CR> mapping if exists
  silent! iunmap <buffer> <CR>
endfunction

" Disable all completion for current buffer
function! s:DisableAll() abort
  " Disable CoC
  if exists('g:did_coc_loaded')
    try
      silent! CocDisable
    catch
      " coc.nvim内部エラーを無視
    endtry
  endif

  " Disable cmp
  lua vim.b.cmp_enabled = false

  " Remove <CR> mapping
  silent! iunmap <buffer> <CR>
endfunction

" Autocmds for completion switching
augroup CompletionSwitch
  autocmd!
  autocmd FileType * call s:ApplyCompletionEngineInternal()
augroup END

" ============================================================================
" CoC Specific Settings
" ============================================================================

" Global extensions
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
  \, '@hexuhua/coc-copilot'
  \, 'coc-stylua'
  \, 'coc-vimlsp'
  \, 'coc-pyright'
  \ ]

  " \, 'coc-deno'
" Markdown fenced languages
let g:markdown_fenced_languages = [
     \ 'vim',
     \ 'php=php',
     \ 'javascript',
     \ 'typescript',
     \ 'help'
     \]

" FZF settings
let g:coc_fzf_opts = ['--layout=reverse']
let g:fzf_layout = { 'window': { 'width': 0.7, 'height': 0.6,} }
let g:coc_disable_startup_warning = 1

" Popup navigation mappings
inoremap <silent><expr> <C-n> coc#pum#visible() ? coc#pum#next(1):  "\<C-n>"
inoremap <silent><expr> <C-p> coc#pum#visible() ? coc#pum#prev(1):  "\<C-p>"
inoremap <silent><expr> <down> coc#pum#visible() ? coc#pum#next(0): "\<down>"
inoremap <silent><expr> <up> coc#pum#visible() ? coc#pum#prev(0):   "\<up>"

" Snippet navigation
let g:coc_snippet_next = '<tab>'

" Manual completion trigger
inoremap <silent><expr> <C-Space> coc#refresh()

" CoC keybindings for CoC filetypes
function! s:SetCocKeybindings() abort
  " Basic operations
  nmap <buffer><silent> ,cd <Plug>(coc-definition)
  nmap <buffer><silent> ,cy <Plug>(coc-type-definition)
  nmap <buffer><silent> ,ci <Plug>(coc-implementation)
  nmap <buffer><silent> ,cr <Plug>(coc-references)
  nmap <buffer><silent> ,cn <Plug>(coc-rename)
  nmap <buffer><silent> ,cf <Plug>(coc-format)
  vmap <buffer><silent> ,cf <Plug>(coc-format)
  nmap <buffer><silent> ,cR <Plug>(coc-refactor)

  " CocFzfList
  nnoremap <buffer><silent> ,cla :<C-u>CocFzfList diagnostics<CR>
  nnoremap <buffer><silent> ,clb :<C-u>CocFzfList diagnostics --current-buf<CR>
  nnoremap <buffer><silent> ,clc :<C-u>CocFzfList commands<CR>
  nnoremap <buffer><silent> ,cle :<C-u>CocFzfList extensions<CR>
  nnoremap <buffer><silent> ,cls :<C-u>CocFzfList symbols<CR>
  nnoremap <buffer><silent> ,clS :<C-u>CocFzfList services<CR>
  nnoremap <buffer><silent> ,clp :<C-u>CocFzfListResume<CR>

  " Code Action
  nmap <buffer><silent> ,caA <Plug>(coc-codeaction)
  nmap <buffer><silent> ,cal <Plug>(coc-codeaction-line)
  xmap <buffer><silent> ,cas <Plug>(coc-codeaction-selected)
  nmap <buffer><silent> ,caa <Plug>(coc-codeaction-cursor)
  nmap <buffer><silent> ,ca <Plug>(coc-codeaction-cursor)

  " Outline
  nnoremap <buffer><silent> ,co :<C-u>CocFzfList outline<CR>

  " Hover documentation
  nnoremap <buffer><silent> ,ck :call <SID>show_documentation()<CR>
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Setup keybindings for CoC filetypes (using g:coc_only_filetypes from plugin.vim)
augroup CocKeybindings
  autocmd!
  execute 'autocmd FileType ' . join(g:coc_only_filetypes, ',') . ' call s:SetCocKeybindings()'
augroup END
