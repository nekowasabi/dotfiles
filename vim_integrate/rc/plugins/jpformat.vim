" -----------------------------------------------------------  
" jsegment
let g:jasegment#model = 'endhira'

" " -----------------------------------------------------------
" " jpFormat
" " 文字数指定を半角/全角単位にする
" " 1:半角
" " 2:全角
" let JpFormatCountMode = 2
" " 原稿(折り返し)全角文字数
" let JpCountChars = 40
"
" " 原稿行数
" let JpCountLines = 17
"
" " 禁則処理の最大ぶら下がり字数
" let JpCountOverChars = 1
"
" " 半角一文字分オーバーしても折り返し処理をする/しない
" let JpFormatHankakuOver = 0
"
" " 折り返し文字数(原稿用紙文字数)は textwidthから設定する
" let JpCountChars_Use_textwidth = 0
"
" " 挿入モードで一文字入力する度に自動整形を行う/行わない
" let JpFormatCursorMovedI = 1
"
" " 整形対象外行の正規表現
" let JpFormatExclude = '^$'
"
" " 原稿用紙換算計算時に削除するルビ等の正規表現
" let JpCountDeleteReg = '\[.\{-}\]\|<.\{-}>\|《.\{-}》\|［.\{-}］\|｜'
"
" " 整形コマンドを使用したら自動整形もON
" let JpAutoFormat = 1
"
" " 連結マーカー
" let JpFormatMarker = "\t"
"
" " 基本的な処理方法
" " 1. まず指定文字数に行を分割
" " 2. 次行の行頭禁則文字(JpKinsoku)を現在行へ移動
" " 3. 現在行の行末禁則文字(JpKinsokuE)を次行へ移動
" " 4. ぶら下がり文字数を超えてぶら下がっていたら追い出し(JpKinsokuO)
" "    (JpKinsokuOが未設定の場合はJpKinsokuで代用されます)
" " 行頭禁則
" let JpKinsoku = '[-!?}>－ｰ～！？゛゜ゝゞ）］｡｣､･ﾞﾟヽヾー々‐・:;.°′″、。，．,)\]｝〕〉》」』】〟’”»‥―…]'
" " 行末禁則
" let JpKinsokuE = '[0-9a-zA-Z([{<（｛〔〈《「『【〝‘“«]'
" " 句点と閉じ括弧
" let JpKutenParen = '[、。，．,)\]｝〕〉》」』】〟’”»]'
" " 句点と閉じ括弧で分離不可文字追い出し用
" " 分離不可文字を追い出す時JpNoDivNがあったら、そこから追い出し。
" " ですか？――<分割> があったら ？は残して――のみを追い出すための指定。
" let JpNoDivN = '[、。，．,)\]｝〕〉》」』】〟’”»!?！？]'
" " 分離不可
" let JpNoDiv = '[―…‥]'
"
" " 連結マーカー非使用時のTOLキャラクター
" let JpJoinTOL = '[\s　「・＊]'
" " 連結マーカー非使用時のEOLキャラクター
" let JpJoinEOL = '[。」！？］]'
"
" " 挿入モードへ移行したら自動連結
" " 0 : なにもしない
" " 1 : カーソル位置以降を自動連結
" " 2 : パラグラフを自動連結
" let JpAutoJoin = 1
"
" " gqを使用して整形を行う
" let JpFormatGqMode = 0
"
" " gqを使用して整形する場合の整形コマンド
" " 空文字列なら現在formatexprに設定しているコマンドが使用される
" let JpFormat_formatexpr = ''


" 記号移動
" 。
nnoremap <silent> <C-x><C-d> :call MyExecExCommand("call clever_f#find('f','。')")<CR>
nnoremap <silent> <C-z><C-d> :call MyExecExCommand("call clever_f#find('F','。')")<CR>
inoremap <silent> <C-x><C-d> <C-g>u<C-r>=MyExecExCommand("call clever_f#find('f','。')")<CR>
inoremap <silent> <C-z><C-d> <C-g>u<C-r>=MyExecExCommand("call clever_f#find('F','。')")<CR>
vnoremap <silent> <C-x><C-d> :call MyExecExCommand("call clever_f#find('f','。')")<CR>
vnoremap <silent> <C-z><C-d> :call MyExecExCommand("call clever_f#find('F','。')")<CR>

" 、
nnoremap <silent> <C-x><C-c> :call MyExecExCommand("call clever_f#find('f','、')")<CR>
nnoremap <silent> <C-z><C-c> :call MyExecExCommand("call clever_f#find('F','、')")<CR>
inoremap <silent> <C-x><C-c> <C-g>u<C-r>=MyExecExCommand("call clever_f#find('f','、')")<CR>
inoremap <silent> <C-z><C-c> <C-g>u<C-r>=MyExecExCommand("call clever_f#find('F','、')")<CR>
" 「
nnoremap <silent> <C-x><C-b> :call MyExecExCommand("call clever_f#find('f','「')")<CR>
nnoremap <silent> <C-z><C-b> :call MyExecExCommand("call clever_f#find('F','「')")<CR>
inoremap <silent> <C-x><C-g> <C-g>u<C-r>=MyExecExCommand("call clever_f#find('f','[「『]')")<CR>
inoremap <silent> <C-z><C-g> <C-g>u<C-r>=MyExecExCommand("call clever_f#find('F','[「『]')")<CR>
" ／
nnoremap <silent> <C-x><C-s> :call MyExecExCommand("call clever_f#find('f','／')")<CR>
nnoremap <silent> <C-z><C-s> :call MyExecExCommand("call clever_f#find('F','／')")<CR>
inoremap <silent> <C-x><C-s> <C-g>u<C-r>=MyExecExCommand("call clever_f#find('f','／')")<CR>
inoremap <silent> <C-z><C-s> <C-g>u<C-r>=MyExecExCommand("call clever_f#find('F','／')")<CR>

 """"""""""""""""""""""""""""""
 "IMEの状態とカーソル位置保存のため<C-r>を使用してコマンドを実行。
 """"""""""""""""""""""""""""""
 function! MyExecExCommand(cmd, ...)
 		let saved_ve = &virtualedit
 		let index = 1
 		while index <= a:0
 				if a:{index} == 'onemore'
 						silent setlocal virtualedit+=onemore
 				endif
 				let index = index + 1
 		endwhile

 		silent exec a:cmd
 		if a:0 > 0
 				silent exec 'setlocal virtualedit='.saved_ve
 		endif
 		return ''
 endfunction

