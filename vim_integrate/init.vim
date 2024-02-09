
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

let g:chat_gpt_max_tokens=2000
let g:chat_gpt_model='gpt-4-1106-preview'
let g:chat_gpt_session_mode=1
let g:chat_gpt_temperature = 0.7
let g:chat_gpt_lang = 'Japanese'
" let g:chat_gpt_split_direction = 'vertical'


call ai_review#config({ 'chat_gpt': { 'model': 'gpt-4' } })

let g:lsp_settings_filetype_typescript = ['typescript-language-server', 'eslint-language-server', 'deno']

let g:gpt_commit_msg = {}
let g:gpt_commit_msg.api_key = $OPENAI_API_KEY

" vim-perplexity
let g:perplexity_token = $PERPLEXITY_TOKEN
let g:perplexity_model = 'llama-2-70b-chat'
let g:perplexity_log_directory = '/tmp/perplexity'

" lazygit
nnoremap <silent> <leader>lg :LazyGit<CR>

" CopilotChat
nnoremap <silent> <leader>cce :CopilotChatExplain<CR>

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

-- gp.nvim
require("gp").setup({
agents =
{
  { 
      name = "ChatGPT4", 
      chat = true, 
      command = true, 
      -- string with model name or table with model name and parameters 
      model = { model = "gpt-4-0125-preview", temperature = 1.1, top_p = 1 }, 
      -- system prompt (use this to specify the persona/role of the AI) 
      system_prompt = "レスポンスとは、日本語で回答してください\n\n" 
			.. "1つずつ、step by stepで説明してください。\n\n", 
  }, 
	{
			name = "ChatGPT3-5",
	},
	{
			name = "CodeGPT3-5",
	},

},
chat_assistant_prefix = { "🤖:", "[{{agent}}]" }, 
chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/chats",
chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-c>r" }, 
chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-c>d" }, 
chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-c>s" }, 
chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-c>c" }, 
})

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

-- lsp keyboard shortcut
-- vim.keymap.set('n', '<space>ck',  '<cmd>lua vim.lsp.buf.hover()<CR>')
-- vim.keymap.set('n', '<space>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
-- vim.keymap.set('n', '<space>cr', '<cmd>lua vim.lsp.buf.references()<CR>')
-- vim.keymap.set('n', '<space>cd', '<cmd>lua vim.lsp.buf.definition()<CR>')
-- vim.keymap.set('n', '<space>cD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
-- vim.keymap.set('n', '<space>ci', '<cmd>lua vim.lsp.buf.implementation()<CR>')
-- vim.keymap.set('n', '<space>ct', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
-- vim.keymap.set('n', '<space>cn', '<cmd>lua vim.lsp.buf.rename()<CR>')
-- vim.keymap.set('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
-- vim.keymap.set('n', '<space>ce', '<cmd>lua vim.diagnostic.open_float()<CR>')
-- vim.keymap.set('n', '<space>c]', '<cmd>lua vim.diagnostic.goto_next()<CR>')
-- vim.keymap.set('n', '<space>c[', '<cmd>lua vim.diagnostic.goto_prev()<CR>')

local on_attach = function(client, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', '<space>ck', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<space>cd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', '<space>ci', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<space>cr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>cr', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>cD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', '<space>ci', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<space>ct', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<space>ce', vim.diagnostic.open_float, bufopts)
end



require("swagger-preview").setup({
    -- The port to run the preview server on
    port = 8000,
    -- The host to run the preview server on
    host = "localhost",
})


require("CopilotChat").setup({
  mode = "split",
  prompts = {
    Explain = "コードの内容を日本語でステップバイステップで説明してください",
    Review = "review the following code and provide concise suggestions.",
    Tests = "briefly explain how the selected code works, then generate unit tests.",
    Refactor = "refactor the code to improve clarity and readability.",
    Aaa = "Add comment by Japanese",
  },
  event = "VeryLazy",
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

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
      null_ls.builtins.formatting.deno_fmt, 
      null_ls.builtins.diagnostics.deno_lint,
    },
})
vim.keymap.set('n', '<leader>p', function() vim.lsp.buf.format { async = true } end)
EOF

" END
