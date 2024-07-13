" -----------------------------------------------------------
" open-browser
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
let g:openbrowser_use_vimproc = 1
if has("mac")
else
	let g:openbrowser_browser_commands = [{'name': 'C:\Program Files\Google\Chrome\Application\chrome.exe', 'args': ['start', '{browser}', '{uri}']}]
endif
