lua << EOF
require('render-markdown').setup({
    -- Why: 既定の rendered=3 では syntax/markdown.vim の }}}1 などの代替文字(cchar)まで消えるため 2 にする
    win_options = {
        conceallevel = { rendered = 2 },
    },
    html = {
        comment = {
            conceal = false,
        },
    },
})
EOF
