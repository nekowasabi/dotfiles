call ddu#custom#patch_global(#{
      \   ui: 'ff',
      \ })

" ddu window settings {{{1
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
  let s:FilerHeight = 60
  let s:Width = round(&columns)
  let s:Height = round(&lines * 0.3)
  let s:WinRow = 2
  let s:WinCol = 2
  let s:previewWidth = round(&columns) 
  let s:previewHeight = round(&lines * 0.50)
  let s:previewRow =  round(&lines * 0.3)+3
  let s:previewCol = 2
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

call ddu#custom#patch_global(#{
    \     uiParams: #{
		\       uiOptions: #{
		\ 	    filer: #{
		\ 	    	toggle: v:true
		\ 	    }
		\     },
    \     ff: #{
    \         prompt: '>> ' ,
    \         highlights: #{floatingCursorLine: s:cursorLine, filterText: 'Statement', floating: "Normal", floatingBorder: "Special", selected: 'Special'},
    \         floatingBorder: 'double',
    \         floatingTitle: 'ddu',
    \         floatingTitlePos: 'left',
    \         split: 'floating',
    \         autoAction: #{name: "preview", sync: v:true},
    \         startAutoAction: v:true,
    \         previewSplit: s:previewSplit,
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

" }}}1

" kind options {{{1
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
    \     bookmark: #{
    \       defaultAction: 'open',
    \     },
    \     rule_switch: #{
    \       defaultAction: 'open',
    \     },
    \     aider: #{
    \       defaultAction: 'add',
    \     },
    \     prompt: #{
    \       defaultAction: 'execute',
    \     },
    \   }
    \ })

" }}}1

" source options {{{1
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

call ddu#custom#patch_global({
    \   'sourceParams' : {
    \     'rg' : {
    \       'args': ['--json'],
    \       'inputType': 'migemo',
    \     },
    \   },
    \ })

if g:IsMacNeovim()
  let g:dropbox_dir = '/Users/takets/Library/CloudStorage/Dropbox/files/changelog'
  let g:config_dir =  '~/.config/'
endif
if g:IsWsl()
  let g:config_dir =  '/home/takets/.config/'
endif
if g:IsWindowsGvim()
  let g:dropbox_dir = 'g:/dropbox/files/changelog'
  let g:config_dir =  'c:/tools/vim'
endif

call ddu#custom#patch_global('sourceParams', {
	 \   'file_external': {
   \     'cmd': ['git', 'ls-files']
	 \   },
	 \ })

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
" }}}1

" matcher options {{{1
call ddu#custom#patch_global(#{
    \   sourceOptions: #{
    \     _: #{
    \       matchers: ['matcher_matchfuzzy'],
    \       ignoreCase: v:true,
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
    \       matchers: ['matcher_kensaku', 'matcher_matchfuzzy'],
    \     },
    \     line: #{
    \       matchers: ['matcher_kensaku'],
    \     },
    \     vim-bookmark: #{
    \       matchers: ['matcher_kensaku'],
    \     },
    \     prompt: #{
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
		\     },
		\     rg: #{
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


" }}}1

if g:IsWsl()
  let g:prompt_toml = '/home/takets/.config/nvim/prompt.toml'
endif
if g:IsMacNeovimInWezterm()
  let g:prompt_toml = '/Users/takets/.config/nvim/prompt.toml'
endif
if g:IsMacNeovimInWork()
  let g:prompt_toml = '/Users/ttakeda/.config/nvim/prompt.toml'
endif

" commands {{{1
nnoremap <space>pc :<C-u>call DduGrepCurrentDirectory()<CR>
function DduGrepCurrentDirectory() abort
  let s:input = input('current dir grep > ')
 	call ddu#start({
				\   'sourceParams' : #{
				\     rg : #{
				\       args: ['--json'],
				\       matchers: ['matcher_matchfuzzy'],
				\       ignoreCase: v:true,
				\     },
				\   },
				\   'sources':[
				\     {'name': 'rg', 'params': {'inputType': 'migemo', 'input': s:input}},
				\   ],
				\ })
endfunction

nnoremap <Space>pm  :<C-u>call DduGrepChangelogHeader()<CR>
function DduGrepChangelogHeader() abort
  if g:IsMacGvim() || g:IsMacNeovim() || g:IsMacNeovimInWork()
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
  let git_root = system('git rev-parse --show-toplevel')
  let git_root = substitute(git_root, '\n', '', 'g') " 改行を削除
  execute 'cd' git_root

  let s:input = input('project grep > ')

	call ddu#start({
				\   'sourceParams' : #{
				\     rg : #{
				\       args: ['--json'],
				\       matchers: ['matcher_matchfuzzy'],
				\       ignoreCase: v:true,
				\     },
				\   },
				\   'sources':[
				\     {'name': 'rg', 'params': {'inputType': 'migemo', 'input': s:input}},
				\   ],
				\ })
endfunction

nnoremap <Space>pw  :<C-u>call DduGrepProjectWord()<CR>
function DduGrepProjectWord() abort
  let git_root = system('git rev-parse --show-toplevel')
  let git_root = substitute(git_root, '\n', '', 'g') " 改行を削除
  execute 'cd' git_root

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

nnoremap <space>pi :<C-u>call DduGrepForConstructorInjection()<CR>
function DduGrepForConstructorInjection() abort
  let git_root = system('git rev-parse --show-toplevel')
  let git_root = substitute(git_root, '\n', '', 'g') " 改行を削除
  execute 'cd' git_root

  let search_word = expand("<cword>")
	call ddu#start({
				\   'sourceParams' : #{
				\     rg : #{
				\       args: ['--json'],
				\     },
				\   },
				\   'sources':[
				\     {'name': 'rg', 'params': {'inputType': 'regex', 'input': ".*implements ".search_word}},
				\   ],
				\ })
endfunction

nnoremap <Space>pv  :<C-u>call DduGrepConfig()<CR>
function DduGrepConfig() abort
  if g:IsWindowsGvim()
    cd c:/takeda/repos/changelog
  endif
  if g:IsWsl() || g:IsMacNeovim()
    cd ~/.config/nvim
  endif
  let s:input = input('config grep > ')

	call ddu#start({
				\   'sourceParams' : #{
				\     rg : #{
				\       args: ['--json', '-g', '!plugged', '-g', '!dict'],
				\     },
				\   },
				\   'sources':[
				\     {'name': 'rg', 'params': {'inputType': 'migemo', 'input': s:input}},
				\   ],
				\ })
endfunction
" }}}1

" commands {{{1
nnoremap <silent> <Leader>ad
      \ <Cmd>call ddu#start({'sources': [{'name': 'aider'}]})<CR>
nnoremap <silent> <M-a>
      \ <Cmd>call ddu#start({'sources': [{'name': 'aider'}]})<CR>
nnoremap <silent> <D-a>
      \ <Cmd>call ddu#start({'sources': [{'name': 'aider'}]})<CR>

nnoremap <silent> <CR>b
      \ <Cmd>call ddu#start({'sources': [{'name': 'vim-bookmark'}]})<CR>
nnoremap <silent> <M-b>
      \ <Cmd>call ddu#start({'sources': [{'name': 'vim-bookmark'}]})<CR>
nnoremap <silent> <D-b>
      \ <Cmd>call ddu#start({'sources': [{'name': 'vim-bookmark'}]})<CR>

nnoremap <silent> <CR><CR>
      \ <Cmd>call ddu#start({'sources': [{'name': 'mr', 'params': {'kind': 'mrw'}}]})<CR>

nnoremap <silent> <BS>
      \ <Cmd>call ddu#start({'sources': [{'name': 'buffer'}]})<CR>

vnoremap <silent> <C-c>a
      \ y<Cmd>call ddu#start({'sources': [{'name': 'prompt', 'params': {'command': 'AiderAsk', 'selected': @@}}]})<CR>
vnoremap <silent> <C-c>c
      \ y<Cmd>call ddu#start({'sources': [{'name': 'prompt', 'params': {'command': 'CopilotChat', 'selected': @@}}]})<CR>
vnoremap <silent> <C-c>g
      \ y<Cmd>call ddu#start({'sources': [{'name': 'prompt', 'params': {'command': 'GpAppend', 'selected': @@}}]})<CR>
vnoremap <silent> <C-c>G
      \ y<Cmd>call ddu#start({'sources': [{'name': 'prompt', 'params': {'command': 'GpRewrite', 'selected': @@}}]})<CR>

nnoremap <silent> <Leader>ll
      \ <Cmd>call ddu#start({'sources': [{'name': 'line', 'params': {'matchers': 'matcher_matchfuzzy'}}]})<CR>
nnoremap <silent> <Leader>h
      \ <Cmd>call ddu#start({'sources': [{'name': 'command_history'}]})<CR>
nnoremap <silent> <Leader>H
      \ <Cmd>call ddu#start({'sources': [{'name': 'help'}]})<CR>
nnoremap <silent> <Leader>gf
      \ <Cmd>call ddu#start({'sources': [{'name': 'file_external'}]})<CR>
nnoremap <silent> <Leader>gs
      \ <Cmd>call ddu#start({'sources': [{'name': 'git_stash'}]})<CR>

" }}}1

" candidates settings {{{1
autocmd FileType ddu-ff call s:ddu_uu_my_settings()
function! s:ddu_uu_my_settings() abort
  inoremap <buffer><silent> <CR>
        \ <Cmd>call ddu#ui#do_action('itemAction')<CR>
  nnoremap <buffer><silent> <CR>
        \ <Cmd>call ddu#ui#do_action('itemAction')<CR>
  nnoremap <buffer><silent> o
        \ <Cmd>call ddu#ui#do_action('itemAction')<CR>

  call ddu#ui#ff#save_cmaps(['<C-j>', '<C-k>'])

  cnoremap <C-j>
        \ <Cmd>call ddu#ui#do_action('cursorNext')<CR>
  cnoremap <C-k>
        \ <Cmd>call ddu#ui#do_action('cursorPrevious')<CR>
  nnoremap <buffer><silent> h
        \ <Cmd>call ddu#ui#do_action('itemAction', {'params': {'command': 'split'}})<CR>
  nnoremap <buffer><silent> v
        \ <Cmd>call ddu#ui#do_action('itemAction', {'params': {'command': 'vsplit'}})<CR>
  nnoremap <buffer><silent> a
        \ <Cmd>call ddu#ui#do_action('chooseAction')<CR>
  nnoremap <buffer> *
        \ <Cmd>call ddu#ui#do_action('toggleAllItems')<CR>
  nnoremap <buffer><silent> s
        \ <Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>
  nnoremap <buffer><silent> i
        \ <Cmd>call ddu#ui#do_action('openFilterWindow')<CR>
  nnoremap <buffer><silent> c
        \ <Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>
  nnoremap <buffer> r
        \ <Cmd>call ddu#ui#do_action('itemAction', #{ name: 'quickfix' })<CR>
  nnoremap <buffer><silent> p
        \ <Cmd>call ddu#ui#do_action('preview')<CR>
  nnoremap <buffer><silent> e
        \ <Cmd>call ddu#ui#do_action('expandItem', {'mode': 'toggle'})<CR>
  nnoremap <buffer><silent> q
        \ <Cmd>call ddu#ui#do_action('quit')<CR>
  nnoremap <buffer> ms
        \ <Cmd>call ddu#ui#multi_actions([
        \   [
        \      'updateOptions', g:source_options_substring
        \   ],
        \   [
        \      'redraw', #{ method: 'refreshItems' },
        \   ],
        \ ])<CR>
  nnoremap <buffer> mf
        \ <Cmd>call ddu#ui#multi_actions([
        \   [
        \      'updateOptions', g:source_options_fuzzy
        \   ],
        \   [
        \      'redraw', #{ method: 'refreshItems' },
        \   ],
        \ ])<CR>

	" for aider.vim
  nnoremap <buffer><silent> <C-a>
        \ <Cmd>call ddu#ui#do_action('itemAction', {'params': {'command': 'add'}})<CR>
  nnoremap <buffer><silent> <C-r>
        \ <Cmd>call ddu#ui#do_action('itemAction', {'params': {'command': 'readOnly'}})<CR>

endfunction

let g:source_options_substring = #{
      \ sourceOptions: #{
      \   mr: #{
      \     matchers: ['matcher_substring'],
      \   },
      \   rg: #{
      \     matchers: ['matcher_substring'],
      \   },
      \   line: #{
      \     matchers: ['matcher_substring'],
      \   },
      \ },
      \ }

let g:source_options_fuzzy = #{
      \ sourceOptions: #{
      \   mr: #{
      \     matchers: ['matcher_matchfuzzy', 'matcher_kensaku'],
      \     ignoreCase: v:true,
      \   },
      \   rg: #{
      \     matchers: ['matcher_matchfuzzy', 'matcher_kensaku'],
      \     ignoreCase: v:true,
      \   },
      \   line: #{
      \     matchers: ['matcher_matchfuzzy', 'matcher_kensaku'],
      \     ignoreCase: v:true,
      \   },
      \ },
      \ }

" }}}1

" filter settings {{{1
autocmd User Ddu:ui:ff:openFilterWindow
      \ call s:ddu_ff_filter_my_settings()
function s:ddu_ff_filter_my_settings() abort
  let s:save_cr = '<CR>'->maparg('c', v:false, v:true)

  cnoremap <C-c>
        \ <ESC><Cmd>call ddu#ui#do_action('itemAction')<CR>
endfunction
autocmd User Ddu:ui:ff:closeFilterWindow
      \ call s:ddu_ff_filter_cleanup()
function s:ddu_ff_filter_cleanup() abort
  if s:save_cr->empty()
    cunmap <CR>
  else
    call mapset('c', 0, s:save_cr)
  endif
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
" }}}1

" filer settings {{{1
autocmd TabEnter,CursorHold,FocusGained <buffer>
      \ call ddu#ui#do_action('checkItems')

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
        \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'copy'})<CR>
  nnoremap <buffer><silent> p
        \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'paste'})<CR>
  nnoremap <buffer><silent> d
        \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'delete'})<CR>
  nnoremap <buffer><silent> q
        \ <Cmd>call ddu#ui#do_action('quit')<CR>
  nnoremap <buffer> >
        \ <Cmd>call ddu#ui#filer#do_action('updateOptions', #{
        \   sourceOptions: #{
        \     file: #{
        \       matchers: ToggleHidden('file'),
        \     },
        \   },
        \ })<CR>
  nnoremap <buffer> gr
        \ <Cmd>call ddu#ui#do_action('itemAction', #{ name: 'rg' })<CR>
endfunction

" filer 表示
function! DduFiler() abort
  call ddu#start({
        \ 'ui': 'filer',
        \ 'name': 'ui_filer_preview_layout',
        \ 'resume': v:true,
        \ 'sources': [{'name': 'file', 'options': {'path': expand('%:p:h')}}],
        \ 'sourceOptions': {'_': {'columns': ['icon_filename']}},
        \ 'uiParams': {
        \	'filer': {
        \		'split': 'floating',
        \		'floatingBorder': 'double',
        \		'previewFloating': v:true,
        \		'winWidth': &columns - 4,
        \		'winHeight': &lines - 4,
        \		'winCol': s:WinCol,
        \		'winRow': s:WinRow,
        \		'sort': 'extension',
        \	}
        \ },
        \ })
endfunction
nnoremap <silent> <Leader>F :<C-u>call DduFiler()<CR>

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

" }}}1

" vim-lsp {{{1
" if g:IsWindowsGvim()
"   let g:ddu_source_lsp_clientName = 'vim-lsp'
" else
"   let g:ddu_source_lsp_clientName = 'nvim-lsp'
" endif
" call ddu#custom#patch_global(#{
"       \ kindOptions: #{
"       \   lsp: #{
"       \     defaultAction: 'open',
"       \   },
"       \   lsp_codeAction: #{
"       \     defaultAction: 'apply',
"       \   },
"       \ },
"       \})
"
" nnoremap <silent> <Leader>cd
"     \ <Cmd>call ddu#start(#{
" 	    \ sync: v:true,
" 	    \ sources: [#{
" 	    \   name: 'lsp_definition',
" 	    \ }],
" 	    \ uiParams: #{
" 	    \   ff: #{
" 	    \     immediateAction: 'open',
" 	    \   },
" 	    \ }
" 	    \})<CR>
"
" nnoremap <silent> <Leader>cD
"     \ <Cmd>call ddu#start(#{
" 	    \ sources: [#{
" 	    \   name: 'lsp_diagnostic',
" 	    \   params: #{
" 	    \     buffer: 0,
" 	    \   }
" 	    \ }],
" 	    \})<CR>
"
" nnoremap <silent> <Leader>co
"     \ <Cmd>call ddu#start(#{
" 	    \ sources: [#{
" 	    \   name: 'lsp_documentSymbol',
" 	    \ }],
" 	    \ sourceOptions: #{
" 	    \   lsp: #{
" 	    \     volatile: v:true,
" 	    \   },
" 	    \ },
" 	    \ uiParams: #{
" 	    \   ff: #{
" 	    \     ignoreEmpty: v:false
" 	    \   },
" 	    \ }
" 	    \})<CR>
"
" nnoremap <silent> <Leader>cw
"     \ <Cmd>call ddu#start(#{
" 	    \ sources: [#{
" 	    \   name: 'lsp_workspaceSymbol',
" 	    \ }],
" 	    \ sourceOptions: #{
" 	    \   lsp: #{
" 	    \     volatile: v:true,
" 	    \   },
" 	    \ },
" 	    \ uiParams: #{
" 	    \   ff: #{
" 	    \     ignoreEmpty: v:false
" 	    \   },
" 	    \ }
" 	    \})<CR>
"
" nmap <silent> <Leader>cr
"     \ <Cmd>call ddu#start(#{
"     \ sync: v:true,
"     \ sources: [#{
"     \   name: 'lsp_references',
"     \ }],
"     \ uiParams: #{
"     \   ff: #{
"     \     immediateAction: 'open',
"     \   },
"     \ }
"     \})<CR>
" }}}1
