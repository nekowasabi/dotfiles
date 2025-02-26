" init setting {{{1

" 環境ごとの設定ディレクトリパスを取得
set runtimepath+=/usr/local/opt/fzf
source ~/.config/nvim/rc/env.vim
source ~/.config/nvim/rc/plugin.vim

exe "MasonUpdate"
" }}}1

" Easy autocmd {{{1
augroup MyVimrc
  autocmd!
augroup END

command! -nargs=* AutoCmd autocmd MyVimrc <args>
" }}}1

" colorscheme {{{1
set termguicolors
colorscheme NeoSolarized
set background=dark

let g:neosolarized_contrast = "low"
let g:neosolarized_visibility = "normal"
let g:neosolarized_vertSplitBgTrans = 1
let g:neosolarized_bold = 1
let g:neosolarized_underline = 1
let g:neosolarized_italic = 0
let g:neosolarized_termBoldAsBright = 1

set t_8f=^[[38;2;%lu;%lu;%lum
set t_8b=^[[48;2;%lu;%lu;%lum

" }}}1

" denopsテスト用コメント
let g:denops#debug = 0

" temp
nmap <leader>r .

" url-highlight
let g:highlighturl_guifg = '#4aa3ff'

" -----------------------------------------------------------
" lua
lua << EOF

-- nvim-navic {{{1
local navic = require("nvim-navic")
local on_attach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
  end
end
require("mason-lspconfig").setup_handlers {
  function (server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup {
      on_attach = on_attach, --keyバインドなどの設定を登録
    }
  end,
}

require("lspconfig").vimls.setup {
    on_attach = on_attach
}

require("lspconfig").intelephense.setup {
    on_attach = on_attach
}

require("lspconfig").denols.setup {
    on_attach = on_attach
}
-- }}}1

require('Comment').setup()

require("avante_lib").load()

require("avante").setup({
	provider = "copilot",
	copilot = {
		model = "claude-3.7-sonnet",
    max_tokens = 16000,
	},
	auto_suggestions_provider = "copilot", -- 一応設定しておく
	file_selector = {
		provider = "telescope",
	},
	behaviour = {
		auto_suggestions = false, -- 試験的機能につき無効化を推奨
		auto_set_highlight_group = true,
		auto_set_keymaps = true,
		auto_apply_diff_after_generation = false,
		support_paste_from_clipboard = true,
		minimize_diff = true,
    enable_cursor_planning_mode = false,
	},
  mappings = {
    ask = "<tab>", -- ask
    edit = "<leader>ve", -- edit
    refresh = "<leader>vv", -- refresh
  },
	windows = {
		position = "right",
		wrap = true,
		width = 40,
		sidebar_header = {
			enabled = true,
			align = "right",
			rounded = false,
		},
		input = {
			height = 5,
		},
		edit = {
			border = "single",
			start_insert = true,
		},
		ask = {
			floating = true,
			start_insert = true,
			border = "single",
		},
	},
})

EOF

" END
