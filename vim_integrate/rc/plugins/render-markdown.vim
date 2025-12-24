lua << EOF
require('render-markdown').setup({
    html = {
        comment = {
            conceal = false,
        },
    },
})
EOF
