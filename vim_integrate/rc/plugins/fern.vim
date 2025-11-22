function! s:fern_reveal(dict) abort
  execute 'FernReveal' a:dict.relative_path
endfunction

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
let s:manual_root = ''

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

" fern ウィンドウ番号を取得（なければ 0）
function! s:fern_winnr() abort
  for l:nr in range(1, winnr('$'))
    if getbufvar(winbufnr(l:nr), '&filetype') ==# 'fern'
      return l:nr
    endif
  endfor
  return 0
endfunction

function! s:fern_reopen(dict) abort
  if empty(a:dict)
    return
  endif
  " 既存 fern バッファを全て閉じてから開き直す（root を確実に反映）
  for l:bn in range(1, bufnr('$'))
    if getbufvar(l:bn, '&filetype') ==# 'fern'
      silent! execute 'bwipeout' l:bn
    endif
  endfor
  call s:fern_open(a:dict, 1)
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
  let s:skip_sync_once = 1
  let s:manual_root = l:parent
  call s:fern_reopen(l:info)
endfunction


" 現在バッファから root/reveal を算出
function! s:fern_root_reveal() abort
  let l:path = expand('%:p')
  if empty(l:path) || (!filereadable(l:path) && !isdirectory(l:path))
    return {}
  endif

  let l:dir = fnamemodify(l:path, ':h')
  " 手動 root が指定されていれば最優先
  if !empty(s:manual_root) && isdirectory(s:manual_root)
    let l:root = s:manual_root
    if stridx(l:path, l:root . '/') == 0
      let l:reveal = l:path[len(l:root)+1:]
    else
      " 手動ルート外のバッファの場合は root を変えずに root へフォーカス
      let l:reveal = ''
    endif
  else
    let l:git_root = ''
    try
      let l:out = systemlist(['git', '-C', l:dir, 'rev-parse', '--show-toplevel'])
      if v:shell_error == 0
        let l:candidate = get(l:out, 0, '')
        if !empty(l:candidate) && isdirectory(l:candidate)
          let l:git_root = l:candidate
        endif
      endif
    catch
    endtry

    if empty(l:git_root)
      let l:root = fnamemodify(l:dir, ':h')
      let l:reveal = fnamemodify(l:dir, ':t')
    else
      let l:root = l:git_root
      if stridx(l:path, l:root . '/') == 0
        let l:reveal = l:path[len(l:root)+1:]
      else
        let l:reveal = fnamemodify(l:path, ':t')
      endif
    endif
  endif

  return {'root': l:root, 'reveal': l:reveal}
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
    let s:manual_root = ''
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
  if &filetype ==# 'fern' || &buftype !=# ''
    return
  endif

  let l:winnr = s:fern_winnr()
  if !l:winnr
    return
  endif

  let l:info = s:fern_root_reveal()
  if empty(l:info)
    return
  endif

  try
    let l:fern_dict = getbufvar(winbufnr(l:winnr), 'fern', {})
    let l:root_node = get(l:fern_dict, 'root', {})
    let l:current_root = get(l:root_node, '_path', '')
    let l:current_root = type(l:current_root) is# v:t_string ? l:current_root : ''

    " ルートが同じなら FernReveal だけで再描画
    if string(l:current_root) ==# string(l:info.root)
      call win_execute(l:winnr, 'silent! FernReveal ' . fnameescape(l:info.reveal))
    else
      let l:info_copy = copy(l:info)
      call timer_start(0, { -> s:fern_reopen(l:info_copy) })
    endif
  catch
    " 何かあれば黙って抜ける（他プラグインをブロックしない）
  endtry
endfunction

command! FernSmartToggle call <SID>fern_toggle()
nnoremap <silent> <leader>e :FernSmartToggle<CR>

augroup my-fern-smart-sync
  autocmd!
  autocmd BufEnter * call s:fern_sync_on_bufenter()
augroup END
