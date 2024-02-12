" " -----------------------------------------------------------
"" choosewin.vim
nmap  <Leader>W  <Plug>(choosewin)
" オーバーレイ機能を有効にする。
let g:choosewin_overlay_enable = 1

" オーバーレイ時、マルチバイト文字を含むバッファで、ラベル文字が崩れるのを防ぐ
let g:choosewin_overlay_clear_multibyte = 1

" tmux の色に雰囲気を合わせる。
let g:choosewin_color_overlay = {
      \ 'gui': ['DodgerBlue3', 'DodgerBlue3' ],
      \ 'cterm': [ 25, 25 ]
      \ }
let g:choosewin_color_overlay_current = {
      \ 'gui': ['firebrick1', 'firebrick1' ],
      \ 'cterm': [ 124, 124 ]
      \ }

let g:choosewin_blink_on_land      = 0 " 頼むから着地時にカーソル点滅をさせないでくれ！
let g:choosewin_statusline_replace = 0 " どうかステータスラインリプレイスしないで下さい!
let g:choosewin_tabline_replace    = 0 " どうかタブラインもリプレイスしないでいただきたい！

