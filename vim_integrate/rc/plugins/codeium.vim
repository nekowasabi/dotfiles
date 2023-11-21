" codeium
let g:codeium_disable_bindings = 1
imap <script><silent><nowait><expr> <C-l> codeium#Accept()

let g:codeium_filetypes = {
    \ "changelog": v:false,
    \ "text": v:false,
    \ }


