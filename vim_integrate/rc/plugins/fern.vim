function! s:fern_reveal(dict) abort
  execute 'FernReveal' a:dict.relative_path
endfunction

let g:fern_debug_sync = 1

let g:fern#disable_default_mappings             = 1
let g:fern#drawer_width                         = 30
let g:fern#renderer                             = 'nerdfont'
let g:fern#renderer#nerdfont#padding            = '  '
let g:fern#hide_cursor                          = 0
let g:fern#mapping#fzf#disable_default_mappings = 1
let g:Fern_mapping_fzf_file_sink                = function('s:fern_reveal')
let g:Fern_mapping_fzf_dir_sink                 = function('s:fern_reveal')
let g:fern_disable_startup_warnings = 1

function! s:fern_preview_width() abort
  let width = float2nr(&columns * 0.8)
  let width = min([width, 200])
  return width
endfunction

let g:fern_preview_window_calculator = {
     \ 'width': function('s:fern_preview_width')
     \ }

let s:skip_sync_once = 0
" s:manual_root は autoload/myfern/sync.vim に移動

autocmd FileType fern call s:fern_my_settings()

function! s:fern_my_settings() abort
  if exists('b:fern_my_settings_initialized')
    return
  endif
  let b:fern_my_settings_initialized = 1

  " h: root なら親ディレクトリへ遷移、その他は collapse
  nnoremap <silent> <buffer> h :<C-u>call <SID>fern_collapse_or_parent()<CR>

  " l: 従来どおり open / expand
  nmap <silent> <buffer> l <Plug>(fern-action-open-or-expand)

  nmap <silent> <buffer> dd <Plug>(fern-action-clipboard-move)
  nmap <silent> <buffer> yy <Plug>(fern-action-clipboard-copy)
  nmap <silent> <buffer> p <Plug>(fern-action-clipboard-paste)
  nmap <silent> <buffer> ? <Plug>(fern-action-help)

  nmap <silent> <buffer> p     <Plug>(fern-action-preview:toggle)
  nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:auto:toggle)
  nmap <silent> <buffer> <C-d> <Plug>(fern-action-preview:scroll:down:half)
  nmap <silent> <buffer> <C-u> <Plug>(fern-action-preview:scroll:up:half)
  nmap <silent> <buffer> <expr> <Plug>(fern-quit-or-close-preview) fern_preview#smart_preview("\<Plug>(fern-action-preview:close)", ":q\<CR>")
  nmap <silent> <buffer> q <Plug>(fern-quit-or-close-preview)
endfunction

function s:init_fern_mapping_reload_all()
    if exists('b:fern_reload_all_initialized')
        return
    endif
    let b:fern_reload_all_initialized = 1

    nmap <silent> <buffer> R <Plug>(fern-action-reload:all)
    nnoremap <silent> <buffer> <C-F> <C-W>p
endfunction
augroup my-fern-mapping-reload-all
    autocmd! *
    autocmd FileType fern call s:init_fern_mapping_reload_all()
    autocmd FileType fern set nonu
augroup END

augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
augroup END

" =============================
" Smart open/toggle helpers
" =============================

" fern ウィンドウ ID を取得（なければ 0）
" autoload 関数を使用
function! s:fern_winid() abort
  return myfern#sync#get_fern_winid()
endfunction

" 互換性のため winnr も残す
function! s:fern_winnr() abort
  let l:winid = s:fern_winid()
  return l:winid ? win_id2win(l:winid) : 0
endfunction

function! s:fern_reopen(dict, ...) abort
  if empty(a:dict)
    return
  endif
  let l:stay = get(a:000, 0, 1)
  " 既存 fern バッファを全て閉じてから開き直す（root を確実に反映）
  for l:bn in range(1, bufnr('$'))
    if getbufvar(l:bn, '&filetype') ==# 'fern'
      silent! execute 'bwipeout' l:bn
    endif
  endfor
  " stay フラグに応じてフォーカスを戻す/残す
  call s:fern_open(a:dict, l:stay)
endfunction

" root なら親へ、そうでなければ collapse
function! s:fern_collapse_or_parent() abort
  try
    let l:helper = fern#helper#new()
    let l:node = l:helper.sync.get_cursor_node()
    let l:is_root = type(l:node) is# v:t_dict && (
          \ get(l:node, '__owner', v:null) is# v:null
          \ || get(l:node, '__key', []) ==# []
          \ || l:node is# l:helper.sync.get_root_node())
    if l:is_root
      call s:fern_open_parent()
    else
      execute 'normal! \<Plug>(fern-action-collapse)'
    endif
  catch
  endtry
endfunction

" root の一つ上を新しい root にして再描画
function! s:fern_open_parent() abort
  let l:fern_dict = get(b:, 'fern', {})
  let l:root_node = get(l:fern_dict, 'root', {})
  let l:current_root = get(l:root_node, '_path', '')
  if type(l:current_root) isnot# v:t_string || empty(l:current_root)
    return
  endif

  let l:parent = fnamemodify(l:current_root, ':h')
  if l:parent ==# l:current_root
    return
  endif

  let l:info = {'root': l:parent, 'reveal': fnamemodify(l:current_root, ':t')}
  call myfern#sync#set_manual_root(l:parent)
  " 親へ上がるときは fern ウィンドウにフォーカスを残す（stay しない）
  call s:fern_reopen(l:info, 0)
endfunction


" 現在バッファから root/reveal を算出（autoload 関数を使用）
function! s:fern_root_reveal() abort
  return myfern#sync#get_root_reveal()
endfunction

" Fern を開く（stay でフォーカスを元に戻す）
function! s:fern_open(dict, stay) abort
  if empty(a:dict) | return | endif
  let l:cmd = ['Fern', fnameescape(a:dict.root), '-reveal=' . fnameescape(a:dict.reveal), '-drawer']
  if a:stay
    call add(l:cmd, '-stay')
  endif
  execute join(l:cmd, ' ')
endfunction

function! s:fern_toggle() abort
  let l:winnr = s:fern_winnr()
  if l:winnr
    execute l:winnr . 'wincmd c'
    call myfern#sync#clear_manual_root()
    return
  endif

  let l:info = s:fern_root_reveal()
  if empty(l:info)
    return
  endif
  " 初回オープン時は -stay で元のウィンドウにフォーカスを戻す
  call s:fern_open(l:info, 1)
endfunction

" BufEnter で fern を再計算・再描画
function! s:fern_sync_on_bufenter() abort
  if s:skip_sync_once
    let s:skip_sync_once = 0
    return
  endif

  " バッファ判定の強化: filetype, buftype, バッファ名でスキップ判定
  if myfern#sync#should_skip()
    return
  endif

  " ウィンドウ ID を使用（タイマー実行時にも安定）
  let l:winid = s:fern_winid()
  if !l:winid
    return
  endif

  let l:info = s:fern_root_reveal()
  if empty(l:info)
    return
  endif

  try
    " autoload 関数で現在の Fern ルートを取得
    let l:current_root = myfern#sync#get_current_fern_root(l:winid)

    " ルートが同じなら FernReveal だけで再描画
    if l:current_root ==# l:info.root
      let l:reveal = fnameescape(l:info.reveal)
      " ウィンドウ ID を使用（タイマー実行時にも安定）
      call timer_start(0, { -> win_execute(l:winid, 'silent! FernReveal ' . l:reveal) })
    else
      let l:info_copy = copy(l:info)
      call timer_start(0, { -> s:fern_reopen(l:info_copy) })
    endif
  catch
    " 何かあれば黙って抜ける（他プラグインをブロックしない）
  endtry
endfunction

command! FernSmartToggle call <SID>fern_toggle()
nnoremap <silent> <C-f> :FernSmartToggle<CR>

augroup my-fern-smart-sync
  autocmd!
  " BufEnter のみで十分（重複イベント削減）
  autocmd BufEnter * call s:fern_sync_on_bufenter()
augroup END
