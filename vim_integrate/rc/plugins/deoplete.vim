let g:deoplete#enable_at_startup = 1
" let g:deoplete#enable_on_insert_enter = 1
set cmdheight=2

call deoplete#custom#option({
			\ 'min_pattern_length': 1,
			\ 'auto_complete_delay': 0,
			\ 'auto_refresh_delay': 50,
			\ 'max_list': 20,
			\ 'refresh_always': v:false,
			\ 'smart_case': v:true,
			\ 'camel_case': v:true,
			\ 'ignore_case': v:true,
			\ 'enable_buffer_path': v:true,
			\ 'skip_multibyte': v:true,
			\ 'prev_completion_mode': 'length',
			\ 'auto_preview': v:true,
			\ 'on_text_changed_i': v:true,
			\ })

call deoplete#custom#source('tabnine', 'is_volatile', v:false)

call deoplete#custom#option('skip_multibyte', v:true)
call deoplete#custom#source('_', 'sorters', ['sorter_word'])

" call deoplete#custom#option('omni', 'min_pattern_length', 4)

call deoplete#custom#source('_', 'matchers',
\ ['matcher_fuzzy', 'matcher_length'])
call deoplete#custom#option('buffer',     'min_pattern_length', 1)
call deoplete#custom#option('around',     'min_pattern_length', 1)
call deoplete#custom#option('neosnippet', 'min_pattern_length', 2)
call deoplete#custom#option('tabnine',    'min_pattern_length', 1)
call deoplete#custom#option('look',       'min_pattern_length', 6)
call deoplete#custom#option('omni',       'min_pattern_length', 5)

inoremap <expr><C-l> deoplete#manual_complete(['look']) 
inoremap <expr><C-x>d deoplete#manual_complete(['dictionary']) 
inoremap <expr><C-x>n deoplete#manual_complete(['neosnippet'])
inoremap <expr><C-x><C-d> deoplete#complete_common_string()
inoremap <expr><C-e> deoplete#smart_close_popup()
inoremap <expr><C-x>l deoplete#manual_complete(['line']) 

call deoplete#custom#option('candidate_marks',
      \ ['[Z]', '[X]', '[C]', '[V]', '[B]'])
inoremap <expr>Z  pumvisible() ? deoplete#insert_candidate(0) : "Z"
inoremap <expr>X  pumvisible() ? deoplete#insert_candidate(1) : "X"
inoremap <expr>C  pumvisible() ? deoplete#insert_candidate(2) : "C"
inoremap <expr>V  pumvisible() ? deoplete#insert_candidate(3) : "V"
inoremap <expr>B  pumvisible() ? deoplete#insert_candidate(4) : "B"

call deoplete#custom#source('_', 'converters', [
      \ 'converter_remove_paren',
      \ 'converter_remove_overlap',
      \ 'matcher_length',
      \ 'converter_truncate_abbr',
      \ 'converter_truncate_menu',
      \ 'converter_auto_delimiter',
\ ])
call deoplete#custom#source('tabnine', 'converters', [
      \ 'converter_remove_overlap',
      \ 'converter_truncate_info',
\ ])

call deoplete#custom#source('look', 'filetypes', ['vim', 'text', 'shd', 'changelog', 'help', 'gitcommit'])

call deoplete#custom#option('sources', {
      \ 'php':         ['tabnine', 'buffer', 'member', 'file', 'include', 'omni', 'tags', 'around', 'dictionary', 'neosnippet'],
      \ 'phpunit.php': ['tabnine', 'buffer', 'member', 'file', 'include', 'omni', 'tags', 'around', 'dictionary', 'neosnippet'],
      \ 'changelog':   ['buffer','file','dictionary','neosnippet', 'around', 'tabnine', 'nextword'],
      \ 'text':        ['buffer', 'member', 'file', 'include', 'omni', 'look', 'tabnine', 'nextword'],
      \ 'vim':         ['buffer', 'around', 'member', 'file', 'include', 'omni', 'nextword'],
      \ 'javascript':  ['tern', 'tabnine', 'buffer', 'member', 'file', 'include', 'omni', 'tags', 'around', 'dictionary'],
      \})

" call deoplete#custom#option('ignore_sources', {
"       \ 'vim':        ['look'],
"       \})

" set completeopt+=noinsert,menu,preview
set completeopt+=noinsert

call deoplete#custom#source('neosnippet',    'mark', '<snip>')
call deoplete#custom#source('omni',          'mark', '<omni>')
call deoplete#custom#source('tern',          'mark', '<tern>')
call deoplete#custom#source('vim',           'mark', '<vim>')
call deoplete#custom#source('tag',           'mark', '<tag>')
call deoplete#custom#source('tmux-complete', 'mark', '<tmux>')
call deoplete#custom#source('neosnippet',    'mark', '<ns>')
call deoplete#custom#source('syntax',        'mark', '<syntax>')
call deoplete#custom#source('member',        'mark', '<member>')
call deoplete#custom#source('tags',          'mark', '<tags>')

call deoplete#custom#source('look', 'rank', 150)
call deoplete#custom#source('omni', 'rank', 9999)
call deoplete#custom#source('neosnippet', 'rank', 300)
call deoplete#custom#source('tabnine', 'rank', 200)
call deoplete#custom#source('around', 'rank', 3000)
call deoplete#custom#source('buffer', 'rank', 100)
call deoplete#custom#source('file', 'rank', 200)
call deoplete#custom#source('tags', 'rank', 2000)

hi Pmenu ctermbg      = 1
hi PmenuSel ctermbg   = 8
hi PmenuSbar ctermbg  = 2
hi PmenuThumb ctermfg = 3

" " ternjs {{{1
" " Set bin if you have many instalations
" let g:deoplete#sources#ternjs#tern_bin  =  '/usr/local/bin/tern'
" let g:deoplete#sources#ternjs#timeout  =  1
"
" " Whether to include the types of the completions in the result data. Default: 0
" let g:deoplete#sources#ternjs#types  =  1
"
" " Whether to include the distance (in scopes for variables,  in prototypes for 
" " properties) between the completions and the origin position in the result 
" " data. Default: 0
" let g:deoplete#sources#ternjs#depths  =  0
"
" " Whether to include documentation strings (if found) in the result data.
" " Default: 0
" let g:deoplete#sources#ternjs#docs  =  1
"
" " When on,  only completions that match the current word at the given point will
" " be returned. Turn this off to get all results,  so that you can filter on the 
" " client side. Default: 1
" let g:deoplete#sources#ternjs#filter  =  1
"
" " Whether to use a case-insensitive compare between the current word and 
" " potential completions. Default 0
" let g:deoplete#sources#ternjs#case_insensitive  =  1
"
" " When completing a property and no completions are found,  Tern will use some 
" " heuristics to try and return some properties anyway. Set this to 0 to 
" " turn that off. Default: 1
" let g:deoplete#sources#ternjs#guess  =  1
"
" " Determines whether the result set will be sorted. Default: 1
" let g:deoplete#sources#ternjs#sort  =  1
"
" " When disabled,  only the text before the given position is considered part of 
" " the word. When enabled (the default),  the whole variable name that the cursor
" " is on will be included. Default: 1
" let g:deoplete#sources#ternjs#expand_word_forward  =  1
"
" " Whether to ignore the properties of Object.prototype unless they have been 
" " spelled out by at least two characters. Default: 1
" let g:deoplete#sources#ternjs#omit_object_prototype  =  1
"
" " Whether to include JavaScript keywords when completing something that is not 
" " a property. Default: 0
" let g:deoplete#sources#ternjs#include_keywords  =  1
"
" " If completions should be returned when inside a literal. Default: 1
" let g:deoplete#sources#ternjs#in_literal  =  1
"
" " Use tern_for_vim.
" let g:tern#command = ["tern"]
" let g:tern#arguments = ["--persistent"]
" " }}}1
"
" " PHP {{{1
" let g:deoplete#ignore_sources = get(g:, 'deoplete#ignore_sources', {})
"
" autocmd Filetype php set completefunc=phpcomplete#CompletePHP
" autocmd FileType php set omnifunc=phpcomplete#CompletePHP
"
" let g:phpcomplete_relax_static_constraint = 0
" let g:phpcomplete_complete_for_unknown_classes = 1
"
" let g:phpcomplete_search_tags_for_variables = 1
" let g:phpcomplete_min_num_of_chars_for_namespace_completion = 1
" let g:phpcomplete_parse_docblock_comments = 1
" let g:phpcomplete_cache_taglists = 1
"
" let g:phpcomplete_mappings = {
"    \ 'jump_to_def':        '<C-W><C-d>',
"    \ 'jump_to_def_split':  '<C-W><C-s>',
"    \ 'jump_to_def_vsplit': '<C-W><C-v>',
"    \ 'jump_to_def_tabnew': '<C-W><C-t>',
"    \}
"
autocmd FileType php set omnifunc=lsp#complete

" }}}1

call deoplete#custom#var('omni', 'input_patterns', {
		    \ 'ruby': ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::'],
		    \ 'java': '[^. *\t]\.\w*',
		    \ 'php': '\w+|[^. \t]->\w*|\w+::\w*',
\})

call deoplete#custom#option('keyword_patterns', {
			\ '_': '[a-zA-Z_0-9]*',
			\ 'tex': '\\?[a-zA-Z_]\w*',
			\ 'ruby': '[a-zA-Z_]\w*[!?]?',
			\})

call deoplete#custom#var('look', {
      \ 'line_limit': 200,
      \ 'max_num_results': 10,
      \ })

call deoplete#custom#var('tabnine', {
\ 'line_limit': 200,
\ 'max_num_results': 10,
\ })

" END
