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

" url-highlight
let g:highlighturl_guifg = '#4aa3ff'

" nnoremap <silent> <leader>va :<Cmd>AvanteAsk<CR>
" vnoremap <silent> <leader>va :<Cmd>AvanteAsk<CR>
" nnoremap <silent> <leader>ve :<Cmd>AvanteEdit<CR>
" vnoremap <silent> <leader>ve :<Cmd>AvanteEdit<CR>
" nnoremap <silent> <leader>vr :<Cmd>AvanteRefresh<CR>
" nnoremap <silent> <leader>vt :<Cmd>AvanteToggle<CR>

" glance
nnoremap gR <CMD>Glance references<CR>
nnoremap gD <CMD>Glance definitions<CR>
nnoremap gY <CMD>Glance type_definitions<CR>
nnoremap gI <CMD>Glance implementations<CR>


" -----------------------------------------------------------
" lua
lua << EOF


-- Lua configuration
local glance = require('glance')
local actions = glance.actions

glance.setup({
  height = 18, -- Height of the window
  zindex = 45,

  -- When enabled, adds virtual lines behind the preview window to maintain context in the parent window
  -- Requires Neovim >= 0.10.0
  preserve_win_context = true,

  -- Controls whether the preview window is "embedded" within your parent window or floating
  -- above all windows.
  detached = function(winid)
    -- Automatically detach when parent window width < 100 columns
    return vim.api.nvim_win_get_width(winid) < 100
  end,
  -- Or use a fixed setting: detached = true,

  preview_win_opts = { -- Configure preview window options
    cursorline = true,
    number = true,
    wrap = true,
  },

  border = {
    enable = true, -- Show window borders. Only horizontal borders allowed
    top_char = '―',
    bottom_char = '―',
  },

  list = {
    position = 'right', -- Position of the list window 'left'|'right'
    width = 0.33, -- Width as percentage (0.1 to 0.5)
  },

  theme = {
    enable = true, -- Generate colors based on current colorscheme
    mode = 'auto', -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
  },

  mappings = {
    list = {
      ['j'] = actions.next, -- Next item
      ['k'] = actions.previous, -- Previous item
      ['<Down>'] = actions.next,
      ['<Up>'] = actions.previous,
      ['<Tab>'] = actions.next_location, -- Next location (skips groups, cycles)
      ['<S-Tab>'] = actions.previous_location, -- Previous location (skips groups, cycles)
      ['<C-u>'] = actions.preview_scroll_win(5), -- Scroll up the preview window
      ['<C-d>'] = actions.preview_scroll_win(-5), -- Scroll down the preview window
      ['v'] = actions.jump_vsplit, -- Open location in vertical split
      ['s'] = actions.jump_split, -- Open location in horizontal split
      ['t'] = actions.jump_tab, -- Open in new tab
      ['<CR>'] = actions.jump, -- Jump to location
      ['o'] = actions.jump,
      ['l'] = actions.open_fold,
      ['h'] = actions.close_fold,
      ['<leader>l'] = actions.enter_win('preview'), -- Focus preview window
      ['q'] = actions.close, -- Closes Glance window
      ['Q'] = actions.close,
      ['<Esc>'] = actions.close,
      ['<C-q>'] = actions.quickfix, -- Send all locations to quickfix list
      -- ['<Esc>'] = false -- Disable a mapping
    },

    preview = {
      ['Q'] = actions.close,
      ['<Tab>'] = actions.next_location, -- Next location (skips groups, cycles)
      ['<S-Tab>'] = actions.previous_location, -- Previous location (skips groups, cycles)
      ['<leader>l'] = actions.enter_win('list'), -- Focus list window
    },
  },

  hooks = {}, -- Described in Hooks section

  folds = {
    fold_closed = '',
    fold_open = '',
    folded = true, -- Automatically fold list on startup
  },

  indent_lines = {
    enable = true, -- Show indent guidelines
    icon = '│',
  },

  winbar = {
    enable = true, -- Enable winbar for the preview (requires neovim-0.8+)
  },

  use_trouble_qf = false -- Quickfix action will open trouble.nvim instead of built-in quickfix list
})

vim.keymap.set("n", "W", function()
    local pos = require("budouxify.motion").find_forward({
        row = vim.api.nvim_win_get_cursor(0)[1],
        col = vim.api.nvim_win_get_cursor(0)[2],
        head = true,
    })
    if pos then
        vim.api.nvim_win_set_cursor(0, { pos.row, pos.col })
    end
end)
vim.keymap.set("n", "E", function()
    local pos = require("budouxify.motion").find_forward({
        row = vim.api.nvim_win_get_cursor(0)[1],
        col = vim.api.nvim_win_get_cursor(0)[2],
        head = false,
    })
    if pos then
        vim.api.nvim_win_set_cursor(0, { pos.row, pos.col })
    end
end)

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

-- trash
-- avante.nvim {{{1
-- require("avante_lib").load()
--
-- require("avante").setup({
-- 	provider = "copilot",
-- 	copilot = {
-- 		model = "claude-3.7-sonnet",
--     max_tokens = 16000,
-- 	},
-- 	auto_suggestions_provider = "copilot", -- 一応設定しておく
-- 	file_selector = {
-- 		provider = "telescope",
-- 	},
-- 	behaviour = {
-- 		auto_suggestions = false,
-- 		auto_set_highlight_group = true,
-- 		auto_set_keymaps = false,
-- 		auto_apply_diff_after_generation = true,
-- 		support_paste_from_clipboard = true,
-- 		minimize_diff = true,
--     enable_cursor_planning_mode = true,
-- 	},
-- 	windows = {
-- 		position = "right",
-- 		wrap = true,
-- 		width = 40,
-- 		sidebar_header = {
-- 			enabled = true,
-- 			align = "right",
-- 			rounded = false,
-- 		},
-- 		input = {
-- 			height = 10,
-- 		},
-- 		edit = {
-- 			border = "single",
-- 			start_insert = true,
-- 		},
-- 		ask = {
-- 			floating = true,
-- 			start_insert = true,
-- 			border = "single",
-- 		},
-- 	},
-- })
-- }}}1
-- minuet {{{1
-- local system_template =  [[
-- You are the backend of an AI-powered text completion engine. Your task is to
-- provide text suggestions based on the user's input. The user's text will be
-- enclosed in markers:
--
-- - `<contextAfterCursor>`: Text context after the cursor
-- - `<cursorPosition>`: Current cursor location
-- - `<contextBeforeCursor>`: Text context before the cursor
-- ]]
--
-- local chat_input_template =
--     '{{{language}}}\n{{{tab}}}\n<contextBeforeCursor>\n{{{context_before_cursor}}}<cursorPosition>\n<contextAfterCursor>\n{{{context_after_cursor}}}'
--
-- local default_few_shots = {
--     {
--         role = 'user',
--         content = [[
--     <contextBeforeCursor>
--     <cursorPosition>
--     <contextAfterCursor>
--     ]],
--     },
--     {
--         role = 'assistant',
--         content = [[
-- <endCompletion>
-- ]],
--     },
-- }

-- require('minuet').setup {
--     cmp = {
--         enable_auto_complete = true,
--     },
--     provider = 'openai_compatible',
--     n_completions = 1, -- recommend for local model for resource saving
--     -- I recommend beginning with a small context window size and incrementally
--     -- expanding it, depending on your local computing power. A context window
--     -- of 512, serves as an good starting point to estimate your computing
--     -- power. Once you have a reliable estimate of your local computing power,
--     -- you should adjust the context window to a larger value.
--     context_window = 1000,
--     provider_options = {
--         openai_compatible = {
--           guidelines = "カジュアルな口調で、一般の読者が理解しやすいように書いてください。",
--           system = {
--             template = "あなたは日本語で文章を作成するアシスタントです。日本語の文法や表現に精通しています。",
--           },
--           few_shots = {
--             {
--               role = "user",
--               content = "量子コンピュータの基本原理とは",
--             },
--             {
--               role = "assistant",
--               content = "量子コンピュータとは、量子力学の原理を利用して従来のコンピュータでは難しい計算を高速に行う装置です。...",
--             },
--           },
--             api_key = 'OPENROUTER_API_KEY',
--             end_point = 'https://openrouter.ai/api/v1/chat/completions',
--             model = 'meta-llama/llama-3.3-70b-instruct',
--             name = 'Openrouter',
--             optional = {
--                 max_tokens = 128,
--                 top_p = 0.9,
--                 provider = {
--                      -- Prioritize throughput for faster completion
--                     sort = 'throughput',
--                 },
--             },
--         },
--     },
--     virtualtext = {
--         auto_trigger_ft = {
--           'changelog',
--           },
--         keymap = {
--             -- accept whole completion
--             accept = '<C-l>',
--             -- accept one line
--             accept_line = '<A-a>',
--             -- accept n lines (prompts for number)
--             -- e.g. "A-z 2 CR" will accept 2 lines
--             accept_n_lines = '<A-z>',
--             -- Cycle to prev completion item, or manually invoke completion
--             prev = '<C-y>',
--             -- Cycle to next completion item, or manually invoke completion
--             next = '<A-p>',
--             dismiss = '<A-e>',
--         },
--     },
-- }
-- }}}1
EOF

" END
