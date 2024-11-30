lua << EOF
require("lsp_lines").setup()
vim.diagnostic.config({
		virtual_text = false,
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
