" " minimal settings {{{1
" if empty('~/.config/nvim/autoload/' . 'plug.vim')
"  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
"        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"  autocmd VimEnter * PlugInstall | source $MYVIMRC
" endif
"
"
" call plug#begin('~/.config/nvim/autoload/' . 'plugged')
"
" Plug 'vim-denops/denops.vim'
" Plug 'Shougo/ddu.vim'
" Plug 'Shougo/ddu-ui-ff'
" Plug 'kuuote/ddu-source-mr'
" Plug 'Bakudankun/ddu-filter-matchfuzzy'
" Plug 'lambdalisue/vim-mr'
"
" call plug#end()
"
" call ddu#custom#patch_global(#{
"    \   kindOptions: #{
"    \     _: #{
"    \       defaultAction: 'open',
"    \     },
"    \   }
"    \ })
"
" call ddu#custom#patch_global(#{
"      \   ui: 'ff',
"      \ })
"
" call ddu#custom#patch_global(#{
"    \   sourceOptions: #{
"    \     _: #{
"    \       matchers: ['matcher_matchfuzzy'],
"    \     },
"    \   }
"    \ })
"
" autocmd FileType ddu-ff call s:ddu_uu_my_settings()
" function! s:ddu_uu_my_settings() abort
"   nnoremap <buffer><silent> i
"         \ <Cmd>call ddu#ui#do_action('openFilterWindow')<CR>
" endfunction
"
" " }}}1

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

let g:denops_server_addr = '127.0.0.1:32129'

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


" Augment
let g:augment_workspace_folders = ['~/.config/nvim/plugged/aider.vim/', '~/repos/laravel/']

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
EOF

" END
