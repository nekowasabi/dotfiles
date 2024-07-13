scriptencoding utf-8

set fu

"---------------------------------------------------------------------------
" font
set guifont=RuikaMonoNerdFontComplete-07:h17
set guifontwide=RuikaMonoNerdFontComplete-07:h18
set ambiwidth=double
set showtabline=2

"---------------------------------------------------------------------------
" ウインドウに関する設定:
"
" ウインドウの幅
set columns=205
" ウインドウの高さ
set lines=80
" コマンドラインの高さ(GUI使用時)
set cmdheight=1
set showtabline=2

"---------------------------------------------------------------------------
" mouse
" どのモードでもマウスを使えるようにする
set mouse=a
" マウスの移動でフォーカスを自動的に切替えない (mousefocus:切替る)
set nomousefocus
" 入力時にマウスポインタを隠す (nomousehide:隠さない)
set mousehide
" ビジュアル選択(D&D他)を自動的にクリップボードへ (:help guioptions_a)
set guioptions+=a

syntax enable
" colorscheme {{{1
set background=dark
colorscheme solarized8_low
" }}}1

highlight Cursor guifg=NONE guibg=red
highlight CursorIM guifg=NONE guibg=Green

source $VIMRUNTIME/delmenu.vim
set langmenu=ja_jp.utf-8
source $VIMRUNTIME/menu.vim

set guicursor=a:blinkon0

"メニューを削除
set guioptions-=T
set guioptions-=m
set guioptions-=l
set guioptions-=L
set guioptions-=b
set guioptions-=k
set guioptions-=e
" set guioptions=-l
" set guioptions=-r
set guioptions=

" Bell
set vb t_vb=
