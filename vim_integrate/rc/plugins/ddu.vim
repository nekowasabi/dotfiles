call ddu#custom#patch_global(#{
      \   ui: 'ff',
      \ })

if g:IsMacGvim()
  let s:Height = 35
  let s:Width  = 65
  let s:WinRow = 2
  let s:WinCol = 2
  let s:previewWidth = 85
  let s:previewHeight = 35
  let s:previewRow = 2
  let s:previewCol = 70
	let s:previewSplit = 'vertical'
  let s:previewFloatingBorder = 'none'
  let s:cursorLine = 'CursorLine'
endif

if g:IsMacNeovim()
  let s:Height = 15 
  let s:Width  = 160
  let s:WinRow = 2
  let s:WinCol = 2
  let s:previewWidth= 160
  let s:previewHeight= 20
  let s:previewRow= 34 
  let s:previewCol= 2
	let s:previewSplit = 'vertical'
  let s:previewFloatingBorder = 'double'
  let s:cursorLine = 'String'
endif

if g:IsWindowsGvim()
  let s:Height = 22
  let s:Width  = 130
  let s:WinRow = 1
  let s:WinCol = 1
  let s:previewWidth= 130
  let s:previewHeight= 21
  let s:previewRow= 25
  let s:previewCol= 1
	let s:previewSplit = 'horizontal'
  let s:previewFloatingBorder = 'none'
  let s:cursorLine = 'CursorLine'
endif

if g:IsLinux()
  let s:Height = 22
  let s:Width  = 120
  let s:WinRow = 2
  let s:WinCol = 2
  let s:previewWidth= 120
  let s:previewHeight= 30
  let s:previewRow= 32 
  let s:previewCol= 2
	let s:previewSplit = 'vertical'
  let s:previewFloatingBorder = 'double'
  let s:cursorLine = 'String'
endif

" cui {{{1
" call ddu#custom#patch_global(#{
"    \   uiParams: #{
"    \     ff: #{
"    \         startFilter: v:true,
"    \         prompt: '> ' ,
"    \         highlights: #{filterText: 'Statement', floating: "Normal", floatingBorder: "Special", selected: "Special", floatingCursorLine: "Special", CursorLine: "Statement"},
"    \         autoAction: #{name: "preview", sync: v:true},
"    \         startAutoAction: v:true,
"    \         split: 'no',
"    \     }
"    \   },
"    \ })
" }}}1

" floating
call ddu#custom#patch_global(#{
    \     uiParams: #{
		\       uiOptions: #{
		\ 	    filer: #{
		\ 	    	toggle: v:true
		\ 	    }
		\     },
    \     ff: #{
    \         startFilter: v:true,
    \         prompt: '> ' ,
    \         highlights: #{floatingCursorLine: s:cursorLine, filterText: 'Statement', floating: "Normal", floatingBorder: "Special", selected: 'Special'},
    \         autoAction: #{name: "preview", sync: v:true},
    \         startAutoAction: v:true,
    \         floatingBorder: 'double',
    \         split: 'floating',
    \         floatingTitle: '',
    \         previewSplit: s:previewSplit,
    \         filterFloatingPosition: 'top',
    \         previewFloatingBorder: s:previewFloatingBorder,
    \         previewWidth: s:previewWidth,
    \         previewHeight: s:previewHeight,
    \         previewRow: s:previewRow,
    \         previewCol: s:previewCol,
    \         previewFloating: v:true,
    \         winRow: s:WinRow,
    \         winCol: s:WinCol,
    \         winHeight: s:Height,
    \         winWidth: s:Width,
    \     }
    \   },
    \ })

call ddu#custom#patch_global(#{
    \   kindOptions: #{
    \     file: #{
    \       defaultAction: 'open',
    \     },
    \     help: #{
    \       defaultAction: 'open',
    \     },
    \     rg: #{
    \       defaultAction: 'open',
    \     },
    \     line: #{
    \       defaultAction: 'open',
    \     },
    \     mr: #{
    \       defaultAction: 'open',
    \     },
    \     jumplist: #{
    \       defaultAction: 'open',
    \     },
    \     command_history: #{
    \       defaultAction: 'execute',
    \     },
    \     git_stash: #{
    \       defaultAction: 'apply',
    \     },
    \     action: #{
    \       defaultAction: 'do',
    \     },
    \   }
    \ })

call ddu#custom#alias('column', 'icon_filename_for_ff', 'icon_filename')
call ddu#custom#patch_global(#{
  \   sourceOptions: #{
  \     file: #{
  \       columns: ['icon_filename']
  \     },
  \     file_rec: #{
  \       columns: ['icon_filename_for_ff']
  \     },
  \   },
  \   columnParams: #{
  \     icon_filename: #{
  \       defaultIcon: #{ icon: '' },
  \     },
  \     icon_filename_for_ff: #{
  \       defaultIcon: #{ icon: '' },
  \       padding: 0,
  \       pathDisplayOption: 'relative'
  \     }
  \   }
  \ })

call ddu#custom#patch_global(#{
    \   sourceOptions: #{
    \     _: #{
    \       matchers: ['matcher_matchfuzzy', 'matcher_ignores'],
    \     },
    \     help: #{
    \       matchers: ['matcher_substring'],
    \     },
    \     file_external: #{
    \       matchers: ['matcher_matchfuzzy'],
    \     },
    \     jumplist: #{
    \       matchers: ['matcher_matchfuzzy'],
    \     },
    \     rg: #{
    \       matchers: ['matcher_kensaku'],
    \     },
    \   }
    \ })

	" Use this converter for the file_rec source
	" with your unique hl-group
	call ddu#custom#patch_global(#{
		\   sourceOptions: #{
		\     mr: #{
    \       matchers: ['matcher_matchfuzzy'],
		\       converters: [ #{ name: "converter_hl_dir" } ]
		\     },
		\     line: #{
    \       matchers: ['matcher_kensaku'],
		\       converters: [ #{ name: "converter_hl_dir" } ]
		\     }
		\   },
		\   filterParams: #{
		\     converter_hl_dir: #{
		\       hlGroup: "myOriginalHlGroup",
		\     }
		\   }
		\ })

	" Set highlight for your hl-group
	autocmd ColorScheme * highlight myOriginalHlGroup guifg=#8fbc8b guibg=#000000

call ddu#custom#patch_global('filterParams', #{
     \  matcher_kensaku: #{
     \    highlightMatched: 'Search',
     \  },
     \})


call ddu#custom#patch_global(#{
    \   filterParams: #{
    \     matcher_substring: #{highlightMatched: "Search"},
    \     matcher_matchfuzzy: #{highlightMatched: "Search", limit: 100, matchseq: v:true},
    \   }
    \ })

call ddu#custom#patch_global({
    \   'sourceParams' : {
    \     'rg' : {
    \       'args': ['--json'],
    \       'inputType': 'migemo',
    \     },
    \   },
    \ })

if g:IsMacGvim() || g:IsMacNeovim()
  let g:dropbox_dir = '/Users/takets/Library/CloudStorage/Dropbox/files/changelog'
endif
if g:IsWindowsGvim()
  let g:dropbox_dir = 'g:/dropbox/files/changelog'
endif

" or git ls-files
call ddu#custom#patch_global('sourceParams', {
	 \   'file_external': {
	 \     'cmd': ['git', 'ls-files']
	 \   },
	 \ })

nmap <silent> <Leader>p <Cmd>call ddu#start({
    \   'sourceParams' : #{
    \     rg : #{
    \       args: ['--json'],
    \       inputType: 'migemo',
    \     },
    \   },
    \   'sources':[
    \     {'name': 'rg', 'options': {'path': g:dropbox_dir}, 'params': {'input': 'worklog'}},
    \   ],
    \ })<CR>

nnoremap <Space>pm  :<C-u>call DduGrepChangelogHeader()<CR>
function DduGrepChangelogHeader() abort
  if g:IsMacGvim() || g:IsMacNeovim() || g:IsMacNeovimInMfs()
    cd ~/repos/changelog
  endif
  if g:IsWindowsGvim()
    cd c:/takeda/repos/changelog
  endif

	call ddu#start({
				\   'sourceParams' : #{
				\     rg : #{
				\       args: ['--json'],
				\     },
				\   },
				\   'sources':[
				\     {'name': 'rg', 'params': {'inputType': 'regex', 'input': "^\\* .*20.*\\[.*"}},
				\   ],
				\ })
endfunction

nnoremap <Space>pa  :<C-u>call DduGrepProject()<CR>
function DduGrepProject() abort
  if g:IsMacGvim()
    cd /Users/takets/Library/CloudStorage/Dropbox/files/changelog
  endif
  if g:IsWindowsGvim()
    cd c:/takeda/repos/changelog
  endif
  if g:IsLinux()
    cd /home/kf/app
  endif
  if g:IsMacNeovimInMfs()
    cd $INVASE_BACKEND_LARAVEL_DIR
  endif

  let s:input = input('project grep > ')

	call ddu#start({
				\   'sourceParams' : #{
				\     rg : #{
				\       args: ['--json'],
				\     },
				\   },
				\   'sources':[
				\     {'name': 'rg', 'params': {'inputType': 'migemo', 'input': s:input}},
				\   ],
				\ })
endfunction

nnoremap <Space>pw  :<C-u>call DduGrepProjectWord()<CR>
function DduGrepProjectWord() abort
  if g:IsMacGvim()
    cd /Users/takets/Library/CloudStorage/Dropbox/files/changelog
  endif
  if g:IsWindowsGvim()
    cd c:/takeda/repos/changelog
  endif
  if g:IsLinux()
    cd /home/kf/app
  endif
  if g:IsMacNeovimInMfs()
    cd $INVASE_BACKEND_LARAVEL_DIR
  endif

  let search_word = expand("<cword>")
	call ddu#start({
				\   'sourceParams' : #{
				\     rg : #{
				\       args: ['--json'],
				\     },
				\   },
				\   'sources':[
				\     {'name': 'rg', 'params': {'inputType': 'migemo', 'input': search_word}},
				\   ],
				\ })
endfunction

nnoremap <Space>pe  :<C-u>call DduLineEstimate()<CR>
function DduLineEstimate() abort
  if g:IsMacGvim() || g:IsMacNeovim()
    execute ":e ~/Library/CloudStorage/Dropbox/files/estimate/log/estimate.csv"
  endif
  if g:IsWindowsGvim()
    execute ":e g:/dropbox/files/estimate/log/estimate.csv"
  endif

	call ddu#start({
				\   'sourceParams' : #{
				\     line : #{
				\       args: ['--json'],
				\     },
				\   },
				\   'sources':[
        \     {'name': 'line', 'params': {'inputType': 'regex'}},
				\   ],
				\ })
endfunction

" vim-lsp
let g:ddu_source_lsp_clientName = 'vim-lsp'
call ddu#custom#patch_global(#{
      \ kindOptions: #{
      \   lsp: #{
      \     defaultAction: 'open',
      \   },
      \   lsp_codeAction: #{
      \     defaultAction: 'apply',
      \   },
      \ },
      \})

nnoremap <silent> <Leader>cd
    \ <Cmd>call ddu#start(#{
	    \ sync: v:true,
	    \ sources: [#{
	    \   name: 'lsp_definition',
	    \ }],
	    \ uiParams: #{
	    \   ff: #{
	    \     immediateAction: 'open',
	    \   },
	    \ }
	    \})<CR>

nnoremap <silent> <Leader>cD
    \ <Cmd>call ddu#start(#{
	    \ sources: [#{
	    \   name: 'lsp_diagnostic',
	    \   params: #{
	    \     buffer: 0,
	    \   }
	    \ }],
	    \})<CR>

nnoremap <silent> <Leader>co
    \ <Cmd>call ddu#start(#{
	    \ sources: [#{
	    \   name: 'lsp_documentSymbol',
	    \ }],
	    \ sourceOptions: #{
	    \   lsp: #{
	    \     volatile: v:true,
	    \   },
	    \ },
	    \ uiParams: #{
	    \   ff: #{
	    \     ignoreEmpty: v:false
	    \   },
	    \ }
	    \})<CR>

nnoremap <silent> <Leader>cw
    \ <Cmd>call ddu#start(#{
	    \ sources: [#{
	    \   name: 'lsp_workspaceSymbol',
	    \ }],
	    \ sourceOptions: #{
	    \   lsp: #{
	    \     volatile: v:true,
	    \   },
	    \ },
	    \ uiParams: #{
	    \   ff: #{
	    \     ignoreEmpty: v:false
	    \   },
	    \ }
	    \})<CR>

nmap <silent> <Leader>cr
    \ <Cmd>call ddu#start(#{
    \ sync: v:true,
    \ sources: [#{
    \   name: 'lsp_references',
    \ }],
    \ uiParams: #{
    \   ff: #{
    \     immediateAction: 'open',
    \   },
    \ }
    \})<CR>

call ddu#custom#patch_global({
    \   'sourceOptions' : {
    \     'markdown' : {
    \       'sorters': [],
    \     },
    \   },
    \   'sourceParams' : {
    \     'markdown' : {
    \       'style': 'none',
    \       'chunkSize': 5,
    \       'limit': 1000,
    \     },
    \   },
    \ })

call ddu#custom#patch_global({
  \ 'kindOptions': {
  \   'ai-review-request': {
  \     'defaultAction': 'open',
  \   },
  \   'ai-review-log': {
  \     'defaultAction': 'resume',
  \   },
	\   'word': {
  \     'defaultAction': 'append',
  \   },
  \ }
  \ })

call ai_review#config({ 'chat_gpt': { 'model': 'gpt-4-1106-preview' } })

if g:IsWindowsGvim() || g:IsMacGvim() || g:IsLinux() || g:IsMacNeovim()
  nnoremap <silent> <Leader><Leader>
        \ <Cmd>call ddu#start({'sources': [{'name': 'mr'}]})<CR>
  nnoremap <silent> <Leader>lw
        \ <Cmd>call ddu#start({
        \ 'input' : '[worklog]',
        \ 'sources': [{'name': 'line'}]
        \ })<CR>
  nnoremap <silent> <Leader>ll
        \ <Cmd>call ddu#start({'sources': [{'name': 'line'}]})<CR>
  nnoremap <silent> <Leader>F
        \ <Cmd>call ddu#start({'sources': [{'name': 'file'}]})<CR>
  nnoremap <silent> <Leader>h
        \ <Cmd>call ddu#start({'sources': [{'name': 'command_history'}]})<CR>
  nnoremap <silent> <Leader>j
        \ <Cmd>call ddu#start({'sources': [{'name': 'jumplist'}]})<CR>
  nnoremap <silent> <Leader>H
        \ <Cmd>call ddu#start({'sources': [{'name': 'help'}]})<CR>
  nnoremap <silent> <Leader>gf
        \ <Cmd>call ddu#start({'sources': [{'name': 'file_external'}]})<CR>
  nnoremap <silent> <Leader>gs
        \ <Cmd>call ddu#start({'sources': [{'name': 'git_stash'}]})<CR>
endif

autocmd FileType ddu-ff call s:ddu_uu_my_settings()
function! s:ddu_uu_my_settings() abort
  nnoremap <buffer><silent> <CR>
        \ <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
  nnoremap <buffer><silent> o
        \ <Cmd>call ddu#ui#ff#do_action('itemAction', {'params': {'command': 'split'}})<CR>
  nnoremap <buffer><silent> v
        \ <Cmd>call ddu#ui#ff#do_action('itemAction', {'params': {'command': 'vsplit'}})<CR>
  nnoremap <buffer><silent> <C-j>
        \ <Cmd>call ddu#ui#ff#do_action('kensaku')<CR>
  nnoremap <buffer><silent> <C-a>
        \ <Cmd>call ddu#ui#ff#do_action('chooseAction')<CR>
  nnoremap <buffer><silent> s
        \ <Cmd>call ddu#ui#ff#do_action('toggleSelectItem')<CR>
  nnoremap <buffer><silent> i
        \ <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>
  nnoremap <buffer><silent> c
        \ <Cmd>call ddu#ui#ff#do_action('closeFilterWindow')<CR>
  nnoremap <buffer><silent> p
        \ <Cmd>call ddu#ui#ff#do_action('preview')<CR>
  nnoremap <buffer><silent> e
        \ <Cmd>call ddu#ui#ff#do_action('expandItem', {'mode': 'toggle'})<CR>
  nnoremap <buffer><silent> q
        \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>
endfunction

autocmd FileType ddu-ff-filter call s:ddu_filter_my_settings()
function! s:ddu_filter_my_settings() abort
	inoremap <buffer> <CR>
				\ <Esc><Cmd>call ddu#ui#do_action('itemAction')<CR>
	nnoremap <buffer><silent> <CR>
				\ <Cmd>close<CR>
	nnoremap <buffer><silent> q
				\ <Cmd>close<CR>
  nnoremap <buffer><silent> <C-a>
            \ <Cmd>call ddu#ui#ff#do_action('chooseAction')<CR>
  nnoremap <buffer><silent> c
        \ <Cmd>call ddu#ui#ff#do_action('closeFilterWindow')<CR>
  inoremap <buffer><silent> <C-a>
            \ <Cmd>call ddu#ui#ff#do_action('chooseAction')<CR>
	inoremap <C-j>
				\ <Cmd>call ddu#ui#do_action('cursorNext')<CR>
	inoremap <C-k>
				\ <Cmd>call ddu#ui#do_action('cursorPrevious')<CR>
  nnoremap <buffer><silent> <Space>
   \ <Cmd>call ddu#ui#ff#do_action('toggleSelectItem')<CR>
  nnoremap <buffer><silent> i
   \ <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>
  nnoremap <buffer><silent> q
   \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>
endfunction

call ddu#custom#patch_local('filer', {
\   'ui': 'filer',
\   'sources': [
\     {
\       'name': 'file',
\       'params': {},
\     },
\   ],
\   'sourceOptions': {
\     '_': {
\       'columns': ['filename', 'icon_filename'],
\     },
\   },
\   'kindOptions': {
\     'file': {
\       'defaultAction': 'open',
\     },
\   },
\   'uiParams': {
\     'filer': {
\       'winWidth': 40,
\       'split': 'vertical',
\       'splitDirection': 'topleft',
\     }
\   },
\ })

autocmd TabEnter,CursorHold,FocusGained <buffer>
	\ call ddu#ui#filer#do_action('checkItems')

autocmd FileType ddu-filer call s:ddu_filer_my_settings()
function! s:ddu_filer_my_settings() abort
  nnoremap <buffer><expr> <CR>
        \ ddu#ui#get_item()->get('isTree', v:false) ?
        \ "<Cmd>call ddu#ui#do_action('itemAction', {'name': 'narrow'})<CR>" :
        \ "<Cmd>call ddu#ui#do_action('itemAction')<CR>"
  nnoremap <buffer><expr> l
        \ ddu#ui#get_item()->get('isTree', v:false) ?
        \ "<Cmd>call ddu#ui#do_action('itemAction', {'name': 'narrow'})<CR>" :
        \ "<Cmd>call ddu#ui#do_action('itemAction')<CR>"
	nnoremap <silent><buffer> h
				\ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'narrow', 'params': {'path': '..'}})<CR>
	nnoremap <buffer><silent> e
				\ <Cmd>call ddu#ui#do_action('expandItem', {'mode': 'toggle'})<CR>
	nnoremap <buffer><silent> p
				\ <Cmd>call ddu#ui#do_action('togglePreview')<CR>
	nnoremap <buffer><silent> s
				\ <Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>
	nnoremap <buffer><silent> o
				\ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'open', 'params': {'command': 'split'}})<CR>
	nnoremap <buffer><silent> v
				\ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'open', 'params': {'command': 'vsplit'}})<CR>
	nnoremap <buffer><silent> t
				\ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'open', 'params': {'command': 'tabnew'}})<CR>
	nnoremap <buffer><silent> a
				\ <Cmd>call ddu#ui#do_action('chooseAction')<CR>
	nnoremap <buffer><silent> F
				\ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'newFile'})<CR>
	nnoremap <buffer><silent> K
				\ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'newDirectory'})<CR>
	nnoremap <buffer><silent> r
				\ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'rename'})<CR>
  nnoremap <buffer><silent> c
    \ <Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'copy'})<CR>
  nnoremap <buffer><silent> p
    \ <Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'paste'})<CR>
  nnoremap <buffer><silent> d
    \ <Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'delete'})<CR>
	nnoremap <buffer><silent> q
				\ <Cmd>call ddu#ui#do_action('quit')<CR>
endfunction

" filer 表示
function! DduFiler() abort
  execute 'cd' expand('%:p:h')
  call ddu#start({
        \ 'ui': 'filer',
        \ 'name': 'ui_filer_preview_layout',
        \ 'resume': v:true,
        \ 'sources': [{'name': 'file'}],
        \ 'sourceOptions': {'_': {'columns': ['icon_filename']}},
        \ 'uiParams': {
        \	'filer': {
        \		'split': 'horizontal',
        \		'splitDirectoin': 'topleft',
        \		'previewFloating': v:true,
        \	}
        \ },
        \ })
endfunction
nnoremap <silent> <Leader>e :<C-u>call DduFiler()<CR>

function s:file_rec(args)
	let items = a:args->get('items')
	let action = items[0]->get('action')
	call ddu#start(#{
				\ sources: [#{ name: 'file_rec', options: #{ path: action->get('path') } }]
				\ })
	return 0
endfunction

call ddu#custom#action('source', 'file', 'file_rec', function('s:file_rec'))

" Change base path.
call ddu#custom#patch_global('sourceOptions', {
      \ 'file_fd': {'path': expand("~")},
      \ })

