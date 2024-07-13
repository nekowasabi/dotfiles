" -----------------------------------------------------------
" neosnippet

if g:IsWindowsGvim()
	let g:neosnippet#snippets_directory = "c:/tools/vim/vim90/mysnippet"
endif

if g:IsMacGvim()
	let g:neosnippet#snippets_directory = "~/.vim/mysnippet"
endif


if g:IsMacNeovim()
	let g:neosnippet#snippets_directory = "~/.config/nvim/mysnippet"
endif

if g:IsWsl()
  let g:neosnippet#snippets_directory = '/home/takets/.config/nvim/mysnippet'
endif

if g:IsLinux()
  let g:neosnippet#snippets_directory = '/home/kf/.config/nvim/mysnippet'
endif

let g:neosnippet#enable_completed_snippet = 1

" imap <C-s>     <Plug>(neosnippet_expand_or_jump)
" smap <C-s>     <Plug>(neosnippet_expand_or_jump)
" xmap <C-s>     <Plug>(neosnippet_expand_target)

" " SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
