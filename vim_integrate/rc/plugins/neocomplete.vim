"==========================================
"neocomplete.vim
"==========================================

let g:neocomplete#disable_auto_complete = 0
let g:neocomplete#enable_at_startup = 1

" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" let g:neocomplete#enable_camel_case = 1
" _(アンダースコア)区切りの補完を有効化
let g:neocomplete#enable_underbar_completion = 0

let g:neocomplete#sources#buffer#cache_limit_size = 500000
let g:neocomplete#sources#tags#cache_limit_size   = 30000000

let g:neocomplete#use_vimproc = 1

" Use fuzzy completion.
let g:neocomplete#enable_fuzzy_completion = 0

" let g:neocomplete#ctags_command =
"       \ get(g:, 'neocomplete#ctags_command', '/usr/local/bin/ctags -R --exclude=cache --exclude=.git --exclude=.svn --sort=yes --langmap=PHP:+.inc.tpl --regex-PHP="/^[ \t]*const[ \t]+([a-z0-9_]+)/\1/\d/i" --php-kinds=cfd  --languages=php')

" Set minimum syntax keyword length.
let g:necosyntax#min_keyword_length = 3
let g:neocomplete#min_keyword_length = 3
" Set auto completion length.
let g:neocomplete#auto_completion_start_length = 3
" Set manual completion length.
let g:neocomplete#manual_completion_start_length = 3
" Set minimum keyword length.

let g:neocomplete#enable_auto_select = 1
let g:neocomplete#enable_cursor_hold_i = 0

" preview window を閉じない
let g:neocomplete#enable_auto_close_preview = 0
autocmd InsertLeave * silent! pclose!

" Define keyword pattern.
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns._ = '\h\w*'
let g:neocomplete#keyword_patterns.php =
      \'\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

if !exists('g:necovim#complete_functions')
  let g:necovim#complete_functions = {}
endif
let g:necovim#complete_functions = {
      \ 'Ref' : 'ref#complete',
      \ 'Unite' : 'unite#complete_source',
      \ 'VimShellExecute' :
      \      'vimshell#vimshell_execute_complete',
      \ 'VimShellInteractive' :
      \      'vimshell#vimshell_execute_complete',
      \ 'VimShellTerminal' :
      \      'vimshell#vimshell_execute_complete',
      \ 'VimShell' : 'vimshell#complete',
      \ 'VimFiler' : 'vimfiler#complete',
      \ 'Vinarise' : 'vinarise#complete',
      \}

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
" inoremap <expr><C-e>  neocomplete#cancel_popup()

" " ---------- neoocomplete javascript + tern
" " autocmd FileType js call tern#Enable()
" " autocmd FileType javascript setlocal omnifunc=tern#Complete
" " let g:neocomplete#sources#omni#input_patterns.javascript = '[^. \t]\.\%(\h\w*\)\?'

" " -----------------------------------------------------------
" " neoinclude
" if has("mac")
"   let g:neoinclude#paths = {'php': "/Users/takets/tmp/"}
" else
"   let g:neoinclude#paths = {'php': "/vagrant/trygroup/site"}
"   let g:neoinclude#ctags_arguments = {'php': '-R --exclude=cache --exclude=.git --exclude=.svn --sort=yes --langmap=PHP:+.inc.tpl.ctp --regex-PHP="/^[ \t]*const[ \t]+([a-z0-9_]+)/\1/\d/i" --php-kinds=laimS --languages=php'}
"   let g:neoinclude#ctags_command = '/usr/local/bin/ctags'
" endif
" let g:neocomplete#delimiter_patterns = {'php': ['->', '::', '\']}
" let g:neoinclude#exts          = {'php': ['php', 'inc', 'tpl', 'ctp']}
" let g:neoinclude#max_processes = 5
"
"
" -----------------------------------------------------------
" neco-look {{{1
if !exists('g:neocomplete#text_mode_filetypes')
    let g:neocomplete#text_mode_filetypes = {}
endif
let g:neocomplete#text_mode_filetypes = {
            \ 'rst': 1,
            \ 'markdown': 1,
            \ 'gitrebase': 1,
            \ 'gitcommit': 1,
            \ 'vcs-commit': 1,
            \ 'hybrid': 1,
            \ 'text': 1,
            \ 'shd': 1,
            \ 'help': 1,
            \ 'changelog': 1,
            \ 'vim': 1,
            \ 'tex': 1,
            \ }

let g:neocomplete#sources = {
  \ 'typescript': ['buffer', 'member', 'file', 'file/include', 'neosnippet', 'omni'],
  \ 'javascript': ['buffer', 'member', 'file', 'file/include', 'neosnippet', 'omni'],
  \ 'changelog':  ['vim','buffer', 'file', 'file/include', 'dictionary', 'neosnippet'],
  \ 'text':       ['buffer', 'member', 'file', 'include', 'omni', 'look'],
  \ 'css':        ['buffer', 'member', 'file', 'omni'],
  \ 'tmp':        ['file'],
  \ 'vim':        ['buffer', 'member', 'file', 'file/include', 'neosnippet', 'omni', 'look'],
  \ 'php':        [ 'neosnippet', 'buffer', 'member', 'file', 'file/include'],
  \ 'phpunit.php':        [ 'neosnippet', 'buffer', 'member', 'file', 'file/include'],
  \ }

inoremap <silent><expr><C-l> neocomplete#start_manual_complete('look') 
inoremap <silent><expr><C-x>i neocomplete#start_manual_complete('include')
inoremap <expr><C-d>     neocomplete#complete_common_string()
" imap <silent><expr><C-x>l <Plug>(neocomplete_start_unite_complete)
imap <expr><c-k> "<Plug>(neocomplete_start_unite_complete)"

" typescript
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.typescript = '[^. *\t]\.\w*\|\h\w*::'
au FileType typescript setl omnifunc=tsuquyomi#complete

" " }}}1

" phpcomplete.vim
let g:phpcomplete_relax_static_constraint = 1
let g:phpcomplete_complete_for_unknown_classes = 0

let g:phpcomplete_search_tags_for_variables = 1
let g:phpcomplete_min_num_of_chars_for_namespace_completion = 2
let g:phpcomplete_parse_docblock_comments = 1
let g:phpcomplete_cache_taglists = 1
autocmd  FileType  php setlocal omnifunc=phpcomplete#CompletePHP

" ruby solargraph
let g:neocomplete#sources#omni#input_patterns = {
\   "ruby" : '[^. *\t]\.\w*\|\h\w*::',
\}
let g:monster#completion#backend = 'solargraph'
" let g:neocomplete#force_omni_input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'



