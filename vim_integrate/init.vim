" " minimum setting {{{1 source ~/.config/nvim/rc/env.vim
" if empty(g:GetAutoloadPath() . 'plug.vim')
"   silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"     autocmd  VimEnter * PlugInstall | source $MYVIMRC
" endif
"
" call plug#begin(g:GetVimConfigRootPath() . 'plugged')
" Plug 'kdheepak/lazygit.nvim'
" call plug#end()
"
" " }}}1

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

" テスト用コメント
let g:denops#debug = 0
" if g:IsWsl()
"   let g:denops_server_addr = '127.0.0.1:32123'
" endif

" yanky
nnoremap <silent> <leader>y :Telescope yank_history<CR>

autocmd BufRead,BufNewFile *.ks set filetype=tyranoscript
autocmd Filetype tyranoscript setlocal commentstring=;\ %s

" -----------------------------------------------------------
" lua
lua << EOF

require("telescope").load_extension("yank_history")
require("yanky").setup({
  ring = {
    history_length = 100,
    storage = "shada",
    sync_with_numbered_registers = true,
    cancel_event = "update",
    ignore_registers = { "_" },
    update_register_on_cycle = false,
  },
  system_clipboard = {
    sync_with_ring = true,
  }
})

vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")

vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")

require('Comment').setup()

require("mason").setup()

-- avante {{{1
require("img-clip").setup({
  default = {
    embed_image_as_base64 = false,
    prompt_for_file_name = false,
    drag_and_drop = {
      insert_mode = true,
    },
  },
})

require('avante_lib').load()
require("avante").setup({
  ---@alias Provider "openai" | "claude" | "azure"  | "copilot" | "cohere" | [string]
  provider = "claude",
  claude = {
    endpoint = "https://api.anthropic.com",
    model = "claude-3-5-sonnet-20241022",
    temperature = 0,
    max_tokens = 4096,
  },
  behaviour  =  {
    auto_set_highlight_group  =  true, 
    auto_apply_diff_after_generation  =  false, 
    support_paste_from_clipboard  =  true, 
  }, 
  mappings = {
    ask = "<leader>va",
    edit = "<leader>ve",
    refresh = "<leader>vr",
    toggle = "<leader>vt",
    focus = "<leader>vf",
    toggle = {
      default = "<leader>at",
      debug = "<leader>ad",
      hint = "<leader>ah",
      suggestion = "<leader>as",
      repo_map = "<leader>az",
    },
    behaviour = {
      auto_suggestions = true, -- Experimental stage
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
    },
    --- @class AvanteConflictMappings
    diff = {
      ours = "co",
      theirs = "ct",
      both = "cb",
      next = "]x",
      prev = "[x",
    },
    jump = {
      next = "]]",
      prev = "[[",
    },
    submit = {
      normal = "<CR>",
      insert = "<C-s>",
    },
    suggestion = {
      accept = "<M-l>",
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
    toggle = {
      debug = "<leader>vd",
      hint = "<leader>vh",
    },
    sidebar = {
      apply_all = "A",
      apply_cursor = "a",
      switch_windows = "<Tab>",
      reverse_switch_windows = "<S-Tab>",
    },
  },
  hints = { enabled = true },
  windows = {
    wrap = true, -- similar to vim.o.wrap
    width = 30, -- default % based on available width
    sidebar_header = {
      align = "center", -- left, center, right for title
      rounded = true,
    },
  },
  highlights = {
    ---@type AvanteConflictHighlights
    diff = {
      current = "DiffText",
      incoming = "DiffAdd",
    },
  },
  --- @class AvanteConflictUserConfig
  diff = {
    debug = false,
    autojump = true,
    ---@type string | fun(): any
    list_opener = "copen",
  },
})
-- }}}1

EOF

" END
