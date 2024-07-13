call ddc#custom#patch_global('ui','pum')
call pum#set_option('border', 'double')


if g:IsWindowsGvim()
	call ddc#custom#patch_global('sources', ['around'])
	call ddc#custom#patch_filetype(['aichat'], 'sources', [])
	call ddc#custom#patch_filetype(['changelog'], 'sources', ['around', 'file', 'rg'])
	call ddc#custom#patch_filetype(['markdown'], 'sources', ['around', 'file'])
	call ddc#custom#patch_filetype(['text'], 'sources', ['around'])
	call ddc#custom#patch_filetype(['vim'], 'sources', ['vim-lsp', 'around', 'buffer', 'neosnippet', 'rg'])
	call ddc#custom#patch_filetype(['javascript'], 'sources', ['vim-lsp', 'around', 'buffer', 'rg'])
	call ddc#custom#patch_filetype(['php'], 'sources', ['vim-lsp', 'around', 'buffer', 'rg'])

  call ddc#custom#patch_global('sourceOptions', #{
        \   vim-lsp: #{
        \     matchers: ['matcher_head'],
        \     mark: 'lsp',
        \   },
        \ })
else
  call ddc#custom#patch_global('sources', [])
  " call ddc#custom#patch_filetype(['aichat'], 'sources', [])
  call ddc#custom#patch_filetype(['changelog'], 'sources', ['around', 'file', 'rg'])
  call ddc#custom#patch_filetype(['markdown'], 'sources', ['around', 'file'])
  call ddc#custom#patch_filetype(['text'], 'sources', ['around'])
  call ddc#custom#patch_filetype(['ddc-ff'], 'sources', ['around'])
  " call ddc#custom#patch_filetype(['vim'], 'sources', ['lsp', 'around', 'buffer', 'neosnippet', 'rg'])
  " call ddc#custom#patch_filetype(['javascript'], 'sources', ['lsp', 'around', 'buffer', 'rg'])
  " call ddc#custom#patch_filetype(['typescipt'], 'sources', ['lsp', 'around', 'buffer', 'rg'])
  " call ddc#custom#patch_filetype(['deno'], 'sources', ['lsp', 'around', 'buffer', 'rg'])
  " call ddc#custom#patch_filetype(['php'], 'sources', ['lsp', 'around', 'buffer', 'rg'])

" Make sure `substring` is part of this list. Other items are optional for this completion source
let g:completion_matching_strategy_list = ['exact', 'substring']
" Useful if there's a lot of camel case items
let g:completion_matching_ignore_case = 1

  call ddc#custom#patch_global('sourceOptions', #{
        \   lsp: #{
        \     mark: '[LS]',
        \     forceCompletionPattern: '\.\w*|:\w*|->\w*',
        \   },
        \ })
endif

call popup_preview#enable()

" rg
call ddc#custom#patch_global('sourceOptions', #{
        \   rg: #{
        \     mark: 'rg',
        \     minAutoCompleteLength: 4,
        \   },
        \ })

" emulate default mappings (see `:help ins-completion`)
function! s:ddc_complete(...) abort
  return ddc#map#manual_complete(#{ sources: a:000 })
endfunction
inoremap <expr> <C-x><C-l> <SID>ddc_complete('codeium')

call ddc#custom#patch_global('sourceOptions', #{
    \  mocword: #{
    \    mark: 'mocword',
    \    minAutoCompleteLength: 3,
    \    isVolatile: v:true,
    \ }})

call ddc#custom#patch_global('sourceOptions', {
    \ 'file': {
    \   'mark': 'F',
    \   'isVolatile': v:true,
    \   'forceCompletionPattern': '\S/\S*',
    \ }})
call ddc#custom#patch_filetype(
    \ ['ps1', 'dosbatch', 'autohotkey', 'registry'], {
    \ 'sourceOptions': {
    \   'file': {
    \     'forceCompletionPattern': '\S\\\S*',
    \   },
    \ },
    \ 'sourceParams': {
    \   'file': {
    \     'mode': 'win32',
    \   },
    \ }})

" Change source options
call ddc#custom#patch_global('sourceOptions', #{
      \   around: #{ mark: 'A' },
      \ })
call ddc#custom#patch_global('sourceParams', #{
      \   around: #{ maxSize: 500 },
      \ })

call ddc#custom#patch_global('sourceOptions', #{
  \   _: #{
  \     matchers: ['matcher_fuzzy'],
  \     sorters: ['sorter_fuzzy'],
  \     converters: ['converter_fuzzy'],
	\     ignoreCase: v:true
  \   },
  \ })

call ddc#custom#patch_global('sourceOptions', {
  \   'around': {
  \     'matchers': ['matcher_fuzzy'],
  \   },
  \ })
call ddc#custom#patch_global('sourceOptions', {
  \   'buffer': {
  \     'matchers': ['matcher_fuzzy'],
  \   },
  \ })

call ddc#custom#patch_global('sourceOptions', {
    \ 'neosnippet': {
    \   'mark': 'ns',
    \   'dup': v:true,
    \ }})

" Set highlight for your hl-group
autocmd ColorScheme * highlight myOriginalHlGroup guifg=#8fbc8b guibg=#000000
call ddc#custom#patch_global('filterParams', {
    \ 'matcher_fuzzy': {'camelcase': v:true},
		\   'converter_fuzzy': {
		\     'hlGroup': 'myOriginalHlGroup'
		\   }
    \ })

call ddc#custom#patch_global('sourceParams', {
      \ 'buffer': {
      \   'requireSameFiletype': v:false,
      \   'limitBytes': 500000,
      \   'fromAltBuf': v:true,
      \   'forceCollect': v:true,
      \ },
      \ })
call ddc#custom#patch_global('sourceOptions', #{
      \   cmdline-history: #{ mark: '[cmdhis]' },
      \ })

inoremap <silent><expr> <TAB>
     \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
     \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
     \ '<TAB>' : ddc#map#manual_complete()

" TODO:
inoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-n>   <Cmd>call pum#map#select_relative(+1)<CR>
inoremap <C-p>   <Cmd>call pum#map#select_relative(-1)<CR>
inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
inoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
inoremap <expr><CR> pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : lexima#expand('<CR>', 'i')

set completeopt=noinsert

if g:IsWindowsGvim()
  let g:signature_help_config = #{
        \ contentsStyle: "full",
        \ viewStyle: "floating"
        \ }
else
  let g:signature_help_config = #{
        \ contentsStyle: "remainingLabels",
        \ viewStyle: "virtual"
        \ }
endif

call signature_help#enable()

" Use ddc.
call ddc#enable()

" call ddc#custom#patch_global(#{
"      \   ui: 'pum',
"      \   autoCompleteEvents: [
"      \     'InsertEnter', 'TextChangedI', 'TextChangedP', 'CmdlineChanged',
"      \   ],
"      \   cmdlineSources: {
"      \     ':': ['cmdline'],
"      \   },
"      \ })
" nnoremap <Space>:       <Cmd>call CommandlinePre()<CR>:
" nnoremap /       :SearchxForward<CR>
" nnoremap ?       :SearchxBackrward<CR>
" nnoremap /       :SearchxForward<CR><Cmd>call CommandlinePre()<CR>
" nnoremap ?       :SearchxBackrward<CR><Cmd>call CommandlinePre()<CR>
      "\     '/': ['around'],
      "\     '?': ['around'],

" function CommandlinePre() abort
"   " cnoremap <expr> <Tab>
"   "     \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
"        "\ ddc#manual_complete()
" 
"   cnoremap <expr> <Tab>
"        \ wildmenumode() ? &wildcharm->nr2char() :
"        \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
"        \ ddc#map#manual_complete()
"   cnoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
"   cnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
"   cnoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
"   cnoremap <expr><CR> pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<CR>'
"   cnoremap <PageDown> <Cmd>call pum#map#insert_relative(-1)<CR>
"   cnoremap <PageUp> <Cmd>call pum#map#insert_relative(+1)<CR>
" 
"   xnoremap <expr> <Tab>
"       \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
"       \ ddc#manual_complete()
"   xnoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
"   xnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
"   xnoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
"   xnoremap <expr><CR> pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<CR>'
" 
"   autocmd User DDCCmdlineLeave ++once call CommandlinePost()
" 
"   " Enable command line completion for the buffer
"   call ddc#enable_cmdline_completion()
" endfunction
" function CommandlinePost() abort
"   silent! cunmap <Tab>
"   silent! cunmap <S-Tab>
"   silent! cunmap <C-n>
"   silent! cunmap <C-p>
"   silent! cunmap <C-y>
"   silent! cunmap <C-e>
"   silent! xunmap <Tab>
"   silent! xunmap <S-Tab>
"   silent! xunmap <C-n>
"   silent! xunmap <C-p>
"   silent! xunmap <C-y>
"   silent! xunmap <C-e>
" endfunction

" END
