" dsky
let g:dsky_id = 'takets.bsky.social'
let g:dsky_password = $DSKY_PASSWORD
nnoremap <leader>Pb :DSkySay<CR>

" mastodon.nvim
nnoremap <leader>Pm <Plug>(mstdn-editor-open)

" dsky+mastodon
function! s:CrossPost()
  let l:word = input("post > ", "")
  if l:word == ""
    return
  endif
  execute "DSkySay"
	let pos = getpos(".")
	execute ":normal a" . l:word
	call setpos('.', pos)
  call feedkeys("\<Esc>", 'n')  " normalモードに移行
  execute "normal \<Plug>(dsky_say_post_buffer)"

  call mstdn#request#post("takets@social.penguinability.net", #{status: l:word})

  " クリップボードにコピー
  if g:IsWsl()
    call setreg('+', l:word)
    call setreg('*', l:word)
  else
    let @+ = l:word
    let @* = l:word
  endif
endfunction
nnoremap <leader>PP :call <SID>CrossPost()<CR>

