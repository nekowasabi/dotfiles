lua << EOF
vim.diagnostic.config({
		virtual_text = false,
    virtual_lines = true,
		text = {
			[vim.diagnostic.severity.ERROR] = 'Z',
			[vim.diagnostic.severity.WARN] = '',
		},
		linehl = {
			[vim.diagnostic.severity.ERROR] = 'ErrorMsg',
		},
		numhl = {
			[vim.diagnostic.severity.WARN] = 'WarningMsg',
		},
})
EOF
