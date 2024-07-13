function! s:twihi_keymap() abort
  nmap <buffer> <silent> <C-y> <Plug>(twihi:tweet:yank)
  nmap <buffer> <silent> <C-f> <Plug>(twihi:tweet:like)
  nmap <buffer> <silent> <C-o> <Plug>(twihi:tweet:open)
  nmap <buffer> <silent> <C-p> <Plug>(twihi:reply)
  nmap <buffer> <silent> <C-r> <Plug>(twihi:retweet:comment)
endfunction

nnoremap <Leader>Tt :TwihiTweet<CR>
nnoremap <Leader>TT :TwihiHome<CR>

augroup twihi_keymap
  au!
  au FileType twihi-timeline call <SID>twihi_keymap()
augroup END
