" " minimal env {{{1
" if &compatible
"   set nocompatible               " Be iMproved
" endif
" 
" if empty(glob('~/.config/nvim/autoload/plug.vim'))
"   silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
"        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"   autocmd VimEnter * PlugInstall | source $MYVIMRC
" endif
" 
" call plug#begin('~/.config/nvim/plugged')
" Plug 'vim-denops/denops.vim'
" Plug 'prabirshrestha/vim-lsp'
" Plug 'mattn/vim-lsp-settings'
" Plug 'Shougo/ddu.vim'
" Plug 'Shougo/ddu-ui-ff'
" Plug 'Shougo/ddu-kind-file'
" Plug 'Shougo/ddu-filter-matcher_substring'
" Plug 'uga-rosa/ddu-source-lsp'
" Plug 'kuuote/ddu-source-mr'
" Plug 'matsui54/ddu-source-help'
" 
" call plug#end()
" 
" " You must set the default ui.
" " NOTE: ff ui
" " https://github.com/Shougo/ddu-ui-ff
" call ddu#custom#patch_global(#{
" 			\   ui: 'ff',
" 			\ })
" 
" " You must set the default action.
" " NOTE: file kind
" " https://github.com/Shougo/ddu-kind-file
" call ddu#custom#patch_global(#{
" 			\   kindOptions: #{
" 			\     file: #{
" 			\       defaultAction: 'open',
" 			\     },
" 			\   }
" 			\ })
" 
" " Specify matcher.
" " NOTE: matcher_substring filter
" " https://github.com/Shougo/ddu-filter-matcher_substring
" call ddu#custom#patch_global(#{
" 			\   sourceOptions: #{
" 			\     _: #{
" 			\       matchers: ['matcher_substring'],
" 			\     },
" 			\   }
" 			\ })
" 
" let g:ddu_source_lsp_clientName = 'vim-lsp'
" call ddu#custom#patch_global(#{
"       \ kindOptions: #{
"       \   lsp: #{
"       \     defaultAction: 'open',
"       \   },
"       \   lsp_codeAction: #{
"       \     defaultAction: 'apply',
"       \   },
"       \ },
"       \})
" 
" nnoremap <silent> O 
"     \ <Cmd>call ddu#start(#{
"     \ sync: v:true,
"     \ sources: [#{
"     \   name: 'lsp_definition',
"     \ }],
"     \ uiParams: #{
"     \   ff: #{
"     \     immediateAction: 'open',
"     \   },
"     \ }
"     \})<CR>
" 
" " " }}}1

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

" let g:denops#debug = 1
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

" -----------------------------------------------------------
" lua
lua << EOF
--- for caw's workaround
local M = {}
---@param lnum integer
---@param col integer
---@return boolean
function M.has_syntax(lnum, col)
  local bufnr = vim.api.nvim_get_current_buf()
  local captures = vim.treesitter.get_captures_at_pos(bufnr, lnum - 1, col - 1)
  for _, capture in ipairs(captures) do
    if capture.capture == "comment" then
      return true
    end
  end
  return false
end
---@diagnostic disable-next-line: duplicate-set-field
_G.package.preload.caw = function() return M end

require("mason").setup()

require("lsp_lines").setup()
vim.diagnostic.config({
  virtual_text = false,
})

 
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
      model = { model = "gpt-4-1106-preview", temperature = 1.1, top_p = 1 }, 
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

-- local highlight = {
--     "RainbowRed",
--     "RainbowYellow",
--     "RainbowBlue",
--     "RainbowOrange",
--     "RainbowGreen",
--     "RainbowViolet",
--     "RainbowCyan",
-- }
-- 
-- local hooks = require "ibl.hooks"
-- hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
-- -- create the highlight groups in the highlight setup hook, so they are reset
-- -- every time the colorscheme changes
-- hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
--     vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
--     vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
--     vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
--     vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
--     vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
--     vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
--     vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
-- end)
-- 
-- require("ibl").setup { indent = { highlight = highlight } }

require("hlchunk").setup({
chunk = {
  enable = true,
  use_treesitter = true,
  notify = true,
  chars = {
    horizontal_line = "─",
    vertical_line = "│",
    left_top = "╭",
    left_bottom = "╰",
    right_arrow = "▶",
  },
  style = "#806d9c",
},
indent = {
  chars = {
    "│",
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
support_filetypes = {
  "*.vim",
  "*.php",
  "*.md",
  "*changelogmemo",
},
blank = {
  enable = false,
}
})

EOF

" END
