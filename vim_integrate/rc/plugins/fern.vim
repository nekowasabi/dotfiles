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

nnoremap <silent> <C-F> :Fern %:h -drawer -reveal=%<CR>

autocmd FileType fern call s:fern_my_settings()

function! s:fern_my_settings() abort
  echo 'ok'
  nmap <silent> <buffer> h <Plug>(fern-action-collapse)
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
    nmap <silent> <buffer> R <Plug>(fern-action-reload:all)
    nnoremap <silent> <buffer> <C-F> <C-W>p
endfunction
augroup my-fern-mapping-reload-all
    autocmd! *
    autocmd FileType fern call s:init_fern_mapping_reload_all()
    autocmd FileType fern set nonu
augroup END

autocmd FileType fern call glyph_palette#apply()
