" フォルダアイコンの表示をON
let g:WebDevIconsUnicodeDecorateFolderNodes = 1

imap <silent><script><expr> <C-L> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

let g:copilot_filetypes = {
			\ 'changelog': v:false,
			\ 'text': v:false,
			\ 'shd': v:false,
			\ 'aichat': v:false,
			\ 'gitcommit': v:true,
			\ 'yaml': v:true,
			\ }
