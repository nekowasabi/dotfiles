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
  \, 'coc-vimlsp'
  \ ]

  " \, 'coc-swagger'
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
" 統一設定を使用（plugin.vimで定義済み）
" パフォーマンス最適化: 遅延を0msに設定してモード遷移時の待機時間を削除
let g:coc_toggle_delay = 0

" Check if current filetype should enable Coc
function! s:ShouldEnableCoc() abort
  " 必須グローバル変数の存在チェック
  if !exists('g:enable_coc')
    return v:false
  endif

  if &buftype != '' || !exists('g:did_coc_loaded')
    return v:false
  endif

  " 無効化filetypeの場合は無効
  if exists('g:completion_disabled_filetypes') && index(g:completion_disabled_filetypes, &filetype) >= 0
    return v:false
  endif

  " CMPのみfiletypeの場合は無効
  if exists('g:cmp_only_filetypes') && index(g:cmp_only_filetypes, &filetype) >= 0
    return v:false
  endif

  " CoCのみfiletypeまたはその他のfiletypeは、g:enable_cocの値に従う
  return g:enable_coc
endfunction

" Toggle Coc based on filetype
function! ToggleCocByFileType() abort
  let l:should_enable = s:ShouldEnableCoc()
  let l:current_state = get(b:, 'is_coc_enabled', v:false)

  " 状態が変わる時のみ実行（パフォーマンス改善）
  if l:should_enable != l:current_state
    if l:should_enable
      try
        execute "silent! CocEnable"
        let b:is_coc_enabled = v:true
        let b:your_cmp_disable_enable_toggle = v:false
      catch
        " CocEnableが失敗した場合でも状態を更新
        let b:is_coc_enabled = v:false
      endtry
    else
      execute "silent! CocDisable"
      let b:is_coc_enabled = v:false
      let b:your_cmp_disable_enable_toggle = v:true
    endif
  endif
endfunction


" Restore previous Coc state
function! RestoreCocByFileType() abort
  if exists('b:is_coc_enabled')
		if b:is_coc_enabled
			execute "silent! CocEnable"
		else
			let b:your_cmp_disable_enable_toggle = v:true
			execute "silent! CocDisable"
		endif
  endif
endfunction

" Autocommands for Coc toggle
augroup CocToggleForFileTypes
  autocmd!
  " FileTypeイベントでCoC切り替え（BufEnterより効率的）
  autocmd FileType * call ToggleCocByFileType()
  autocmd CmdlineLeave * call RestoreCocByFileType()
  autocmd CmdlineEnter * silent call OpenCommandLineByCmp()
augroup END
" }}}1

" Insert mode復帰時の自動補完トリガー {{{1
" <Esc>でnormal modeに遷移してからinsert modeに戻った時に補完を表示
augroup CocAutoTrigger
  autocmd!
  autocmd InsertEnter * call timer_start(50, {-> s:TriggerCompletionIfNeeded()})
augroup END

function! s:TriggerCompletionIfNeeded() abort
  " CoCが有効かつ、カーソル位置に単語文字がある場合のみトリガー
  if exists('b:is_coc_enabled') && b:is_coc_enabled
        \ && getline('.')[col('.')-1] =~# '\w'
        \ && exists('*coc#refresh')
    call coc#refresh()
  endif
endfunction

" 手動補完トリガー（Ctrl+Space）
inoremap <silent><expr> <C-Space> coc#refresh()
" }}}1

" Disable Coc for command line
function! OpenCommandLineByCmp() abort
  execute "silent! CocDisable"
  let b:your_cmp_disable_enable_toggle = v:true
endfunction

nnoremap <Leader>: :
