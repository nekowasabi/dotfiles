let g:vista_sidebar_width          = 30
let g:vista_echo_cursor_strategy   = 'both'
let g:vista_update_on_text_changed = 1
let g:vista_blink                  = [1, 100]
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]

if g:IsWindowsGvim()
	let g:vista_default_executive = 'vim_lsp'
endif
if g:IsLinux() && !g:IsWsl() 
	let g:vista_default_executive = 'coc'
endif
if g:IsMacNeovimInWork()
	let g:vista_default_executive = 'coc'
endif
if g:IsMacNeovimInWezterm()
	let g:vista_default_executive = 'coc'
endif
if g:IsWsl()
	let g:vista_default_executive = 'coc'
endif

let g:vista#renderer#enable_icon = 1

let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }
