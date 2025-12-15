" g:coc_filetype_map は plugin.vim で設定済み（プラグインロード前に必要）

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
  \, 'coc-pyright'
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


" バックアップとしてしばらく残しておく
" inoremap <silent><expr> <CR> coc#pum#visible() ? coc#_select_confirm()
"       \: "\<C-g>u" . lexima#expand('<LT>CR>', 'i')

" <CR> mapping: ToggleCocByFileType()関数内でバッファローカルマッピングを設定
" cmp_only_filetypesでは、cmpのfallback()がinsxに委譲するため設定不要


inoremap <silent><expr> <C-n> coc#pum#visible() ? coc#pum#next(1):  "\<C-n>"
inoremap <silent><expr> <C-p> coc#pum#visible() ? coc#pum#prev(1):  "\<C-p>"
inoremap <silent><expr> <down> coc#pum#visible() ? coc#pum#next(0): "\<down>"
inoremap <silent><expr> <up> coc#pum#visible() ? coc#pum#prev(0):   "\<up>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" CoC用キーバインドをバッファローカルで設定する関数
function! s:SetCocKeybindings() abort
  " 基本操作
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

" CoC filetypeでキーバインドを設定
augroup CocKeybindings
  autocmd!
  " g:coc_only_filetypes に含まれるfiletypeでのみCoC用キーバインドを設定
  autocmd FileType vim,typescript,php,json,go,lua,sh,python,javascript,vue,yaml,blade call s:SetCocKeybindings()
augroup END

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
  " CoCがロードされていない、または準備できていない場合はスキップ
  if !exists('g:did_coc_loaded')
    return
  endif

  let l:should_enable = s:ShouldEnableCoc()
  let l:current_state = get(b:, 'is_coc_enabled', v:false)

  " 状態が変わる時のみ実行（パフォーマンス改善）
  if l:should_enable != l:current_state
    if l:should_enable
      " CoCサービスが初期化されていない場合はスキップ
      if !exists('g:coc_service_initialized') || !g:coc_service_initialized
        let b:is_coc_enabled = v:false
        return
      endif
      try
        silent! CocEnable
        let b:is_coc_enabled = v:true
        let b:your_cmp_disable_enable_toggle = v:false

        " CoCが有効になった直後にバッファローカル<CR>マッピングを設定
        inoremap <buffer><silent><expr> <CR> coc#pum#visible() ? coc#_select_confirm() : "\<CR>"
      catch
        " CocEnableが失敗した場合でも状態を更新
        let b:is_coc_enabled = v:false
      endtry
    else
      silent! CocDisable
      let b:is_coc_enabled = v:false
      let b:your_cmp_disable_enable_toggle = v:true

      " CoCが無効になった時にバッファローカル<CR>マッピングを削除
      silent! iunmap <buffer> <CR>
    endif
  endif
endfunction


" Restore previous Coc state
function! RestoreCocByFileType() abort
  " CoCがロードされていない、または準備できていない場合はスキップ
  if !exists('g:did_coc_loaded') || !exists('g:coc_service_initialized') || !g:coc_service_initialized
    return
  endif

  if exists('b:is_coc_enabled')
    if b:is_coc_enabled
      silent! CocEnable
    else
      let b:your_cmp_disable_enable_toggle = v:true
      silent! CocDisable
    endif
  endif
endfunction

" Autocommands for Coc toggle
augroup CocToggleForFileTypes
  autocmd!
  " FileTypeイベントでCoC切り替え（BufEnterより効率的）
  autocmd FileType * call ToggleCocByFileType()
  " BufEnterでもCoC状態を切り替え（バッファ移動時の対応）
  autocmd BufEnter * call ToggleCocByFileType()
  autocmd CmdlineLeave * call RestoreCocByFileType()
  autocmd CmdlineEnter * silent call OpenCommandLineByCmp()
  " markdown等のCMPのみfiletypeでは、バッファレベルでもCoCを無効化
  autocmd FileType markdown,noice,changelog,text,gitcommit,copilot-chat,AvanteInput let b:coc_enabled = 0
  autocmd BufEnter *.md let b:coc_enabled = 0 | silent! CocDisable
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
