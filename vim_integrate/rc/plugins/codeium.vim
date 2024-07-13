" codeium
let g:codeium_disable_bindings = 1
imap <script><silent><nowait><expr> <C-l> codeium#Accept()
imap <silent><nowait> <C-]> <Cmd>call codeium#CycleCompletions(1)<CR>

let g:codeium_filetypes = {
    \ "changelog": v:false,
    \ "text": v:false,
    \ }


