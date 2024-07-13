" -----------------------------------------------------------
" easy-motion
" smartcase
let g:EasyMotion_smartcase = 1
" デフォルトだと<Leader><Leader>となってるprefixキーを変更
" 候補選択: 候補が最初から2キー表示されるので大文字や打ちにくい文字は全面的に消す
" なお、最後の数文字が2キーの時の最初のキーになるので打ちやすいものを選ぶとよさそうです。
let g:EasyMotion_keys='hklyuiopnm,qwertzxcvbasdgjf;'
" Migemo
let g:EasyMotion_use_migemo = 1
" Jump to first with enter & space
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_space_jump_first = 1
" Prompt
let g:EasyMotion_prompt = '{n}> '
" Highlight cursor
let g:EasyMotion_cursor_highlight = 1
let g:EasyMotion_do_mapping = 0

" s{char}{char} to move to {char}{char}
nmap Sw <Plug>(easymotion-overwin-f2)

" vmap s <Plug>(easymotion-bd-f2)
" " imap <C-j> <Esc><Plug>(easymotion-overwin-f2)
" 
" 
" " search & EasyMotion
" nmap g; <Plug>(easymotion-sn)
" xmap g; <Plug>(easymotion-sn)
" omap g; <Plug>(easymotion-tn)
" 
" " surround.vimと被らないように
" omap z <Plug>(easymotion-s2)
" 
" " =======================================
" " Line Motions
" " =======================================
" let g:EasyMotion_startofline = 0
" " map <Leader>J <Plug>(easymotion-sol-j)
" " map <Leader>K <Plug>(easymotion-sol-k)
" 
" " vim-edgemotion
" nmap <C-x> <Plug>(edgemotion-j)
" nmap <C-e> <Plug>(edgemotion-k)
" 
" 
