
" init setting {{{1

" 環境ごとの設定ディレクトリパスを取得
set runtimepath+=/usr/local/opt/fzf
source ~/.config/nvim/rc/env.vim
source ~/.config/nvim/rc/plugin.vim
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

let g:denops#debug = 0 
" let g:denops_server_addr = '127.0.0.1:32123'
" let g:denops_disable_version_check = 0
" let g:denops#deno = '/Users/takets/.deno/bin/deno'

" let g:denops#server#deno_args = get(g:,
"      \ 'denops#server#service#deno_args', [
"      \ '-q',
"      \ '--no-check',
"      \ '--unstable',
"      \ '-A',
"      \ '--inspect-brk',
"      \ ])

call ai_review#config({ 'chat_gpt': { 'model': 'gpt-4' } })

" vim-perplexity
let g:perplexity_token = $PERPLEXITY_TOKEN
let g:perplexity_model = 'llama-2-70b-chat'
let g:perplexity_log_directory = '/tmp/perplexity'

" lazygit
nnoremap <silent> <leader>lg :LazyGit<CR>

" CopilotChat
vnoremap <silent> <leader>cv :CopilotChatVisual 
vnoremap <silent> <leader>cx :CopilotChatInPlace<CR>
nnoremap <silent> <leader>ce :CopilotChatExplain<CR>

" keybind
nnoremap <silent> <Tab> <C-w>w

" telescop
nnoremap <silent> <leader>E :Telescope emoji<CR>

" -----------------------------------------------------------
" lua
lua << EOF

-- telescope
require("telescope").setup {
  extensions = {
    emoji = {
      action = function(emoji)
        -- argument emoji is a table.
        -- {name="", value="", cagegory="", description=""}

        vim.fn.setreg("*", emoji.value)
        print([[Press p or "*p to paste this emoji]] .. emoji.value)

        -- -- insert emoji when picked
        -- vim.api.nvim_put({ emoji.value }, 'c', false, true)
      end,
    }
  },
}

 
-- rest.nvim
require("rest-nvim").setup({
    -- Open request results in a horizontal split
    result_split_horizontal = false,
    -- Keep the http file buffer above|left when split horizontal|vertical
    result_split_in_place = false,
    -- stay in current windows (.http file) or change to results window (default)
    stay_in_current_window_after_split = true,
    -- Skip SSL verification, useful for unknown certificates
    skip_ssl_verification = true,
    -- Encode URL before making request
    encode_url = true,
    -- Highlight request on run
    highlight = {
      enabled = true,
      timeout = 150,
    },
    result = {
      -- toggle showing URL, HTTP info, headers at top the of result window
      show_url = true,
      -- show the generated curl command in case you want to launch
      -- the same request via the terminal (can be verbose)
      show_curl_command = false,
      show_http_info = true,
      show_headers = true,
      -- table of curl `--write-out` variables or false if disabled
      -- for more granular control see Statistics Spec
      show_statistics = false,
      -- executables or functions for formatting response body [optional]
      -- set them to false if you want to disable them
      formatters = {
        json = "jq",
        html = function(body)
          return vim.fn.system({"tidy", "-i", "-q", "-"}, body)
        end
      },
    },
    -- Jump to request line on run
    jump_to_request = false,
    env_file = '.env',
    custom_dynamic_variables = {},
    yank_dry_run = true,
    search_back = true,
})

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>rr", "<Plug>RestNvim", opts)
vim.api.nvim_set_keymap("n", "<leader>rp", "<Plug>RestNvimPreview", opts)
vim.api.nvim_set_keymap("n", "<leader>rl", "<Plug>RestNvimLast", opts)

vim.keymap.set({"x", "o"}, "m", function()
  require("treemonkey").select({ ignore_injections = false })
end)


require("hlchunk").setup({
chunk = {
  enable = true,
  use_treesitter = true,
  notify = true,
  -- chars = {
  --   horizontal_line = "─",
  --   vertical_line = "│",
  --   left_top = "╭",
  --   left_bottom = "╰",
  --   right_arrow = "▶",
  -- },
  chars = {
    horizontal_line = "━",
    vertical_line = "┃",
    left_top = "┏",
    left_bottom = "┗",
    right_arrow = "▶",
  },

  style = "#edea82",
  support_filetypes = {
    "*.vim",
    "*.php",
    "*.md",
    "*.ts",
    "*.js",
    "*.yml",
  },
},
indent = {
  chars = {
    "┃",
  },
  style = {
    "#FF0000",
    "#FF7F00",
    "#FFFF00",
    "#00FF00",
    "#00FFFF",
    "#0000FF",
    "#8B00FF",
  },
},
line_num = {
  style = "#806d9c",
},
blank = {
  enable = false,
}
})

require("swagger-preview").setup({
    -- The port to run the preview server on
    port = 8000,
    -- The host to run the preview server on
    host = "localhost",
})


require("ssr").setup({
  border = "rounded",
  min_width = 50,
  min_height = 5,
  max_width = 120,
  max_height = 25,
  adjust_window = true,
  keymaps = {
    close = "q",
    next_match = "n",
    prev_match = "N",
    replace_confirm = "<cr>",
    replace_all = "<leader><cr>",
  },
})
vim.keymap.set({ "n", "x" }, "<leader>sr", function() require("ssr").open() end)

require("deno-nvim").setup({
})

local copilot_chat = require("CopilotChat")
copilot_chat.setup({
  debug = true,
  show_help = "yes",
  prompts = {
    Explain = "Explain how it works by Japanese language.",
    Review = "Review the following code and provide concise suggestions.",
    Tests = "Briefly explain how the selected code works, then generate unit tests.",
    Refactor = "Refactor the code to improve clarity and readability.",
  },
  build = function()
    vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
  end,
  event = "VeryLazy",
})

-- local null_ls = require("null-ls")
-- null_ls.setup({
--     sources = {
--       null_ls.builtins.formatting.deno_fmt, 
--       null_ls.builtins.diagnostics.deno_lint,
--     },
-- })
-- vim.keymap.set('n', '<leader>p', function() vim.lsp.buf.format { async = true } end)

EOF

" END
