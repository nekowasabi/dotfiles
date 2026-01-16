" global
autocmd FileType * hi! def link markdownItalic Normal
autocmd FileType * hi! def link htmlItalic Normal
autocmd FileType * hi! def link markdownBoldItalic Normal

if g:IsMacNeovim()
  " global
  autocmd ColorScheme * highlight Identifier ctermfg=2 guifg=#00CC99 guibg=#2f4f4f
  autocmd ColorScheme * highlight Comment ctermfg=70 guifg=#8fbc8b guibg=#000000
  autocmd ColorScheme * highlight String  ctermfg=154 guifg=#eee8aa guibg=#000000
  autocmd ColorScheme * highlight Special ctermfg=227 ctermbg=235 guifg=#ffebcd guibg=#2f4f4f
  autocmd ColorScheme * highlight Constant ctermfg=2 guifg=#eee8aa guibg=#2f4f4f
  autocmd ColorScheme * highlight Statement ctermfg=226 guifg=#eee8aa guibg=#2f4f4f
  autocmd ColorScheme * highlight Type ctermfg=2 guifg=#deb887 guibg=#2f4f4f
  autocmd ColorScheme * highlight Pmenu guibg=black
  autocmd ColorScheme * highlight PmenuSel guibg=black guifg=#ffebcd 
  autocmd ColorScheme * highlight CursorLine ctermfg=227 ctermbg=235 guibg=#2f4f4f gui=none

  " for plugin
  autocmd ColorScheme * hi Folded gui=bold term=standout ctermbg=grey ctermfg=black guibg=#2f4f4f guifg=#FFFFAF
  autocmd ColorScheme * hi FoldColumn gui=bold term=standout ctermbg=LightGrey ctermfg=DarkBlue guibg=Red guifg=yellow
  autocmd ColorScheme * highlight UtlUrl ctermfg=red guifg=red guibg=#2f4f4f gui=underline
  autocmd ColorScheme * highlight Directory ctermfg=85 guifg=red guibg=#2f4f4f gui=underline
  autocmd ColorScheme * highlight ErrorMsg ctermfg=22 guifg=red guibg=#2f4f4f gui=underline
  autocmd ColorScheme * highlight MatchWord ctermfg=blue guifg=blue cterm=underline gui=underline
  autocmd ColorScheme * highlight AnnotationString ctermfg=white ctermbg=red
  autocmd ColorScheme * highlight NormalFloat ctermfg=grey ctermbg=black guifg=#c0c0c0 guibg=#1a1a1a
  autocmd ColorScheme * highlight FloatBorder ctermfg=cyan ctermbg=black guifg=#5f87af guibg=#1a1a1a
  autocmd ColorScheme * highlight CmpBorder guifg=#5f87af guibg=#1a1a1a
  autocmd ColorScheme * highlight CmpPmenu guifg=#c0c0c0 guibg=#1a1a1a
  autocmd ColorScheme * highlight MatchWord ctermfg=226 guifg=#b0c4de guibg=#000000
  autocmd ColorScheme * highlight SearchxMarker ctermfg=red ctermbg=white guifg=red guibg=#FFFFFF
  autocmd ColorScheme * highlight SearchxMarkerCurrent ctermfg=red ctermbg=white

endif

if g:IsMacGvim()
  " global
  autocmd ColorScheme * highlight Identifier ctermfg=2 guifg=#00CC99 guibg=#2f4f4f
  autocmd ColorScheme * highlight Comment ctermfg=70 guifg=#8fbc8b guibg=#000000
  autocmd ColorScheme * highlight String  ctermfg=154 guifg=#eee8aa guibg=#000000
  autocmd ColorScheme * highlight Special ctermfg=227 ctermbg=235 guifg=#ffebcd guibg=#2f4f4f
  autocmd ColorScheme * highlight Constant ctermfg=2 guifg=#eee8aa guibg=#2f4f4f
  autocmd ColorScheme * highlight Statement ctermfg=226 guifg=#eee8aa guibg=#2f4f4f
  autocmd ColorScheme * highlight Type ctermfg=2 guifg=#deb887 guibg=#2f4f4f
  autocmd ColorScheme * highlight Pmenu guibg=black
  autocmd ColorScheme * highlight PmenuSel guibg=black guifg=#ffebcd
  autocmd ColorScheme * highlight CursorLine ctermfg=227 ctermbg=235 guibg=#2f4f4f gui=none

  " for plugin
  autocmd ColorScheme * hi Folded gui=bold term=standout ctermbg=grey ctermfg=black guibg=#2f4f4f guifg=#FFFFAF
  autocmd ColorScheme * hi FoldColumn gui=bold term=standout ctermbg=LightGrey ctermfg=DarkBlue guibg=Red guifg=yellow
  autocmd ColorScheme * highlight UtlUrl ctermfg=red guifg=red guibg=#2f4f4f gui=underline
  autocmd ColorScheme * highlight Directory ctermfg=85 guifg=red guibg=#2f4f4f gui=underline
  autocmd ColorScheme * highlight ErrorMsg ctermfg=22 guifg=red guibg=#2f4f4f gui=underline
  autocmd ColorScheme * highlight MatchWord ctermfg=blue guifg=blue cterm=underline gui=underline
  autocmd ColorScheme * highlight AnnotationString ctermfg=white ctermbg=red
  autocmd ColorScheme * highlight NormalFloat ctermfg=grey ctermbg=black guifg=#c0c0c0 guibg=#1a1a1a
  autocmd ColorScheme * highlight FloatBorder ctermfg=cyan ctermbg=black guifg=#5f87af guibg=#1a1a1a
  autocmd ColorScheme * highlight CmpBorder guifg=#5f87af guibg=#1a1a1a
  autocmd ColorScheme * highlight CmpPmenu guifg=#c0c0c0 guibg=#1a1a1a
  autocmd ColorScheme * highlight MatchWord ctermfg=226 guifg=#b0c4de guibg=#000000
  autocmd ColorScheme * highlight SearchxMarker ctermfg=red ctermbg=white guifg=red guibg=#FFFFFF
  autocmd ColorScheme * highlight SearchxMarkerCurrent ctermfg=red ctermbg=white
endif


if g:IsWindowsGvim()
  " カラースキームの一部を変更
  autocmd ColorScheme * highlight Identifier ctermfg=22 guifg=GreenYellow guibg=#000000
  autocmd ColorScheme * highlight Comment ctermfg=22 guifg=lightgreen guibg=#000000
  autocmd ColorScheme * highlight String  ctermfg=22 guifg=LightGreen guibg=#000000
  autocmd ColorScheme * highlight Special ctermfg=22 guifg=yellow guibg=#000000
  autocmd ColorScheme * highlight Constant ctermfg=22 guifg=yellow guibg=#000000
  autocmd ColorScheme * highlight Statement ctermfg=22 guifg=yellow guibg=#000000
  autocmd ColorScheme * highlight FoldType ctermfg=22 guifg=pink guibg=#000000
  autocmd ColorScheme * hi Folded gui=bold term=standout ctermbg=LightGrey ctermfg=DarkBlue guibg=black guifg=GreenYellow
  autocmd ColorScheme * hi FoldColumn gui=bold term=standout ctermbg=LightGrey ctermfg=DarkBlue guibg=Red guifg=yellow
  autocmd ColorScheme * highlight UtlUrl ctermfg=22 guifg=red guibg=#000000 gui=underline
  autocmd ColorScheme * highlight Directory ctermfg=22 guifg=red guibg=#000000 gui=underline
  autocmd ColorScheme * highlight ErrorMsg ctermfg=22 guifg=red guibg=#000000 gui=underline
  autocmd ColorScheme * highlight Conceal guifg=#add8e6 guibg=black
  autocmd ColorScheme * highlight SearchxMarker ctermfg=red ctermbg=white guifg=red guibg=white
  autocmd ColorScheme * highlight SearchxMarkerCurrent ctermfg=red ctermbg=white guifg=red guibg=white
  autocmd ColorScheme * highlight CursorLine ctermfg=227 ctermbg=235 guibg=#2f4f4f gui=none

endif

if g:IsWsl()
  " global
  autocmd ColorScheme * highlight Identifier ctermfg=2 guifg=#00CC99 guibg=#2f4f4f
  autocmd ColorScheme * highlight Comment ctermfg=70 guifg=#8fbc8b guibg=#000000 gui=none
  autocmd ColorScheme * highlight String  ctermfg=154 guifg=#eee8aa guibg=#000000
  autocmd ColorScheme * highlight String  ctermfg=154 guifg=#b0c4de guibg=#000000
  autocmd ColorScheme * highlight Special ctermfg=227 ctermbg=235 guifg=#ffebcd guibg=#2f4f4f
  autocmd ColorScheme * highlight Constant ctermfg=2 guifg=#eee8aa guibg=#2f4f4f
  autocmd ColorScheme * highlight Statement ctermfg=226 guifg=#eee8aa guibg=#2f4f4f
  autocmd ColorScheme * highlight Type ctermfg=2 guifg=#deb887 guibg=#2f4f4f

  " for plugin
  autocmd ColorScheme * hi Folded gui=bold term=standout ctermbg=grey ctermfg=black guibg=#2f4f4f guifg=#FFFFAF
  autocmd ColorScheme * hi FoldColumn gui=bold term=standout ctermbg=LightGrey ctermfg=DarkBlue guibg=Red guifg=yellow
  autocmd ColorScheme * highlight UtlUrl ctermfg=red guifg=red guibg=#2f4f4f gui=underline
  autocmd ColorScheme * highlight Directory ctermfg=85 guifg=red guibg=#2f4f4f gui=underline
  autocmd ColorScheme * highlight ErrorMsg ctermfg=22 guifg=red guibg=#2f4f4f gui=underline
  autocmd ColorScheme * highlight MatchWord ctermfg=blue guifg=blue cterm=underline gui=underline
  autocmd ColorScheme * highlight AnnotationString ctermfg=white ctermbg=red
  autocmd ColorScheme * highlight NormalFloat ctermfg=grey ctermbg=black guifg=#c0c0c0 guibg=#1a1a1a
  autocmd ColorScheme * highlight FloatBorder ctermfg=cyan ctermbg=black guifg=#5f87af guibg=#1a1a1a
  autocmd ColorScheme * highlight CmpBorder guifg=#5f87af guibg=#1a1a1a
  autocmd ColorScheme * highlight CmpPmenu guifg=#c0c0c0 guibg=#1a1a1a
  autocmd ColorScheme * highlight MatchWord ctermfg=226 guifg=#b0c4de guibg=#000000
  autocmd ColorScheme * highlight SearchxMarker ctermfg=red ctermbg=white guifg=red guibg=#FFFFFF
  autocmd ColorScheme * highlight SearchxMarkerCurrent ctermfg=red ctermbg=white
endif

if g:IsLinux()
  " global
  autocmd ColorScheme * highlight Identifier ctermfg=2 guifg=#00CC99 guibg=#2f4f4f
  autocmd ColorScheme * highlight Comment ctermfg=70 guifg=#8fbc8b guibg=#000000 gui=none
  autocmd ColorScheme * highlight String  ctermfg=154 guifg=#eee8aa guibg=#000000
  autocmd ColorScheme * highlight String  ctermfg=154 guifg=#b0c4de guibg=#000000
  autocmd ColorScheme * highlight Special ctermfg=227 ctermbg=235 guifg=#ffebcd guibg=#2f4f4f
  autocmd ColorScheme * highlight Constant ctermfg=2 guifg=#eee8aa guibg=#2f4f4f
  autocmd ColorScheme * highlight Statement ctermfg=226 guifg=#eee8aa guibg=#2f4f4f
  autocmd ColorScheme * highlight Type ctermfg=2 guifg=#deb887 guibg=#2f4f4f

  " for plugin
  autocmd ColorScheme * hi Folded gui=bold term=standout ctermbg=grey ctermfg=black guibg=#2f4f4f guifg=#FFFFAF
  autocmd ColorScheme * hi FoldColumn gui=bold term=standout ctermbg=LightGrey ctermfg=DarkBlue guibg=Red guifg=yellow
  autocmd ColorScheme * highlight UtlUrl ctermfg=red guifg=red guibg=#2f4f4f gui=underline
  autocmd ColorScheme * highlight Directory ctermfg=85 guifg=red guibg=#2f4f4f gui=underline
  autocmd ColorScheme * highlight ErrorMsg ctermfg=22 guifg=red guibg=#2f4f4f gui=underline
  autocmd ColorScheme * highlight MatchWord ctermfg=blue guifg=blue cterm=underline gui=underline
  autocmd ColorScheme * highlight AnnotationString ctermfg=white ctermbg=red
  autocmd ColorScheme * highlight NormalFloat ctermfg=grey ctermbg=black guifg=#c0c0c0 guibg=#1a1a1a
  autocmd ColorScheme * highlight FloatBorder ctermfg=cyan ctermbg=black guifg=#5f87af guibg=#1a1a1a
  autocmd ColorScheme * highlight CmpBorder guifg=#5f87af guibg=#1a1a1a
  autocmd ColorScheme * highlight CmpPmenu guifg=#c0c0c0 guibg=#1a1a1a
  autocmd ColorScheme * highlight MatchWord ctermfg=226 guifg=#b0c4de guibg=#000000
  autocmd ColorScheme * highlight SearchxMarker ctermfg=red ctermbg=white guifg=red guibg=#FFFFFF
  autocmd ColorScheme * highlight SearchxMarkerCurrent ctermfg=red ctermbg=white
endif



" コメント中の特定の単語を強調表示する
augroup HilightsForce
  autocmd!
  autocmd WinEnter,BufRead,BufNew,Syntax * :silent! call matchadd('Todo', '\(\MEMO\|TODO\|NOTE\|INFO\|XXX\|TEMP\):')
augroup END

" vim-json
let g:vim_json_syntax_conceal = 0

" coc
autocmd Colorscheme * highlight CocErrorFloat ctermfg=black ctermbg=red guifg=#00CC99 guibg=#2f4f4f
autocmd Colorscheme * highlight CocMenuSel ctermfg=yellow ctermbg=green guifg=#00CC99 guibg=#2f4f4f

" Popup menu related~
" 							*CocPum*
" *CocPumSearch* for matched input characters, linked to |CocSearch| by default.
" *CocPumDetail* for highlight label details that follows label (including
" possible detail and description).
" *CocPumMenu* for menu of complete item.
" *CocPumShortcut* for shortcut text of source.
" *CocPumDeprecated* for deprecated label.
" *CocPumVirtualText* for virtual text which enabled by
" |coc-config-suggest-virtualText|
