let g:Lf_PopupWidth = 0.9
" don't show the help in normal mode
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_IgnoreCurrentBufferName = 1
" popup mode
let g:Lf_WindowPosition = 'popup'
let g:Lf_PopupPreviewPosition = 'bottom'
let g:Lf_PreviewInPopup = 1
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "ルイカ等幅-０７" }
let g:Lf_PopupPosition = [5, 10]
let g:Lf_ShowDevIcons = 1
let g:Lf_PreviewCode = 1
let g:Lf_WorkingDirectoryMode = 'fA'
let g:Lf_PopupColorscheme = 'solarized'

let g:Lf_PreviewResult = {
			\ 'File': 1,
			\ 'Buffer': 1,
			\ 'Mru': 1,
			\ 'Tag': 0,
			\ 'BufTag': 1,
			\ 'Function': 1,
			\ 'Line': 1,
			\ 'Colorscheme': 0,
			\ 'Rg': 1,
			\ 'Gtags': 0
			\}

let g:Lf_DevIconsPalette = {
			\  'light': {
			\      '_': {
			\                'gui': 'NONE',
			\                'font': 'NONE',
			\                'guifg': '#505050',
			\                'guibg': 'NONE',
			\                'cterm': 'NONE',
			\                'ctermfg': '238',
			\                'ctermbg': 'NONE'
			\              },
			\      'default': {
			\                'guifg': '#505050',
			\                'ctermfg': '238',
			\              },
			\      },
			\      'vim': {
			\                'guifg': '#007F00',
			\                'ctermfg': '28',
			\              },
			\      }

let g:Lf_DevIconsExtensionSymbols = {
     \ 'txt': "\uf0f6",
     \ 'changelogmemo': "\uf0f6",
     \}

let g:Lf_PopupShowBorder = 1
let g:Lf_PopupBorders = ["━","┃","━","┃","┏","┓","┛","┗"]

if g:IsWindowsGvim()
	let g:changelog_path = "g:/dropbox/files/changelog"
endif

if g:IsMacGvim()
	let g:changelog_path = "~/Dropbox/files/changelog" 
endif

" mru, cmdHistory
nnoremap <leader><Leader> :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
nnoremap <leader>h :<C-U><C-R>=printf("Leaderf cmdHistory %s", "")<CR><CR>

" grep
nnoremap <Leader>gR :Leaderf rg --current-buffer -e 
nnoremap <Leader>gr :<C-U><C-R>=printf("Leaderf rg --current-buffer -e %s ", expand("<cword>"))<CR><CR>
xnoremap <Leader>gr :<C-U><C-R>=printf("Leaderf rg -F -e %s ", leaderf#Rg#visual())<CR><CR>

" document
nnoremap <Leader>gD :<C-U><C-R>=printf("Leaderf rg %s -e %s ", g:changelog_path, "")<CR>
nnoremap <Leader>gd :<C-U><C-R>=printf("Leaderf rg -e %s %s", expand("<cword>"), g:changelog_path)<CR><CR>
xnoremap <Leader>gd :<C-U><C-R>=printf("Leaderf rg -F -e %s %s", leaderf#Rg#visual(), g:changelog_path)<CR><CR>

" project
nnoremap <Leader>gP :Leaderf rg --current-buffer -e 
nnoremap <Leader>gp :<C-U><C-R>=printf("Leaderf rg --wd-mode=ac -e %s", expand("<cword>"))<CR><CR>
xnoremap <Leader>gp :<C-U><C-R>=printf("Leaderf rg --wd-mode=ac -F -e %s", leaderf#Rg#visual())<CR><CR>

" line
" [worklog]絞込
nnoremap <leader>lw :Leaderf line --fuzzy --no-sort --input '[worklog]: '<LEFT>
" markdownのヘッダ検索
nnoremap <leader>lm :Leaderf line --regexMode --input \(\s\+\)\@<!\_^#\+\s\+.*<CR>
