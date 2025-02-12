" -----------------------------------------------------------
" Switch.vim
let g:switch_mapping = "-"
if has("mac")
	let g:switch_definitions = [['意外', '以外'], ['帰る', '変える','買える'], ['使用','しよう'], ['拾う','疲労'],['絶対','絶体']]
	nnoremap <Leader>S :<C-u>Switch<CR>
	inoremap <silent> <D-t> <C-o>:Switch<CR>
else
	" let g:switch_definitions = [['+engineer', '+documentation'], ['true', 'false'], ['public', 'protected', 'private'], ['==', '!='], ['（ ；´。 ｀；）', '（ ；´ワ ｀；）つ☆'], ['・', '済／'], ['月', '火', '水', '木', '金'], ['・○', '・△', '・×']]
endif

autocmd FileType changelog,text,shd let b:switch_custom_definitions = [
			\		['月', '火', '水', '木', '金'],
			\		['・', '済／'],
			\		['true','true'],
			\		['帰る', '変える','買える'],
			\		['使用','しよう'],
			\		['拾う','疲労'],
			\		['絶対','絶体'],
			\		['移行','以降'],
			\		['できた','で来た'],
			\		['出し','出汁'],
			\		['鳴らない','ならない'],
			\		['（ ；´。 ｀；）','（ ；´ワ ｀；）つ☆'],
			\		['NOTE', 'TODO','MEMO'],
			\   {
			\     ':\(\k\+\)\s\+=>': '\1:',
			\     '\<\(\k\+\):':     ':\1 =>',
			\   },
			\		{
			\			'^・\(Δ\)':   '・〇',
			\			'^・\(〇\)':   '・×',
			\			'^・\(×\)':   '・Δ',
			\		},
			\   {
			\     '意外\([なにのと]\)': '以外\1',
			\     '以外\([なにのと]\)': '意外\1',
			\   },
			\   {
			\     '出来': 'でき',
			\   },
			\   {
			\     'で切\([るたて]\)': 'でき\1',
			\   },
			\   {
			\     '感じ': '漢字',
			\     '漢字': '感じ',
			\   },
			\   {
			\     'と言う': 'という',
			\     'という': 'と言う',
			\   },
			\ ]

autocmd FileType php,javascript let b:switch_custom_definitions = [
			\		['true','false'],
			\		['public', 'protected', 'private'],
			\ ]

autocmd FileType markdown let b:switch_custom_definitions = [
			\		['- ','- [  ] '],
			\		['public', 'protected', 'private'],
			\ ]


