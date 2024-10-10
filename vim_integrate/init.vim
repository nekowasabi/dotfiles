" " minimum setting {{{1
" source ~/.config/nvim/rc/env.vim
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

nnoremap <silent> g<C-o> :Back<CR>
nnoremap <silent> g<C-i> :Forward<CR>

if g:IsWsl()
  let g:prompt_toml = '/home/takets/.config/nvim/prompt.toml'
endif
if g:IsMacNeovimInWezterm()
  let g:prompt_toml = '/Users/takets/.config/nvim/prompt.toml'
endif
if g:IsMacNeovimInWork()
  let g:prompt_toml = '/Users/ttakeda/.config/nvim/prompt.toml'
endif

nnoremap <silent> <M-p> :normal! vip<CR>
nnoremap <silent> <D-p> :normal! vip<CR>

let &grepprg='rg --vimgrep'


" viwがやりやすいようにする
onoremap i<space> iw
xnoremap i<space> iw
onoremap i<CR> iW
xnoremap i<CR> iW

" Visual <, >で連続してインデントを操作
xnoremap < <gv
xnoremap > >gv

" kulala
nnoremap <silent> ,rr :lua require('kulala').run()<CR>

" -----------------------------------------------------------
" lua
lua << EOF

local augend = require("dial.augend")
require("dial.config").augends:register_group{
  default = {
    augend.integer.alias.decimal,
    augend.integer.alias.hex,
    augend.date.new {
      pattern = "%(year)/%m/%d",
      default_kind = "day",
      custom_date_elements = {
        year = {
          -- %(year) カーソルがあたってるとき day が increment されるようになる
          kind = "day",
          regex = [[\d\d\d\d]],
          -- %(year) にマッチしたテキストをどう日付として解釈するか
          update_date = function(text, date)
            -- %(year) のテキストが "2024" だったとしたら、
            -- 日付のうち年の情報を 2024 に更新してくださいね、という意味
            date["year"] = tonumber(text)
            return date
          end,
          -- 増減後の日付をテキストの %(year) の部分に落とし込む方法
          format = function(time)
            local year = os.date("*t", time).year
            return ("%04d"):format(year)
          end,
        },
      },
    },
    augend.constant.alias.bool,
    augend.constant.new{ elements = {'public', 'private', 'private'}},
  },
  typescript = {
    augend.integer.alias.decimal,
    augend.integer.alias.hex,
    augend.constant.new{ elements = {"let", "const"} },
  },
  visual = {
    augend.integer.alias.decimal,
    augend.integer.alias.hex,
    augend.date.alias["%Y/%m/%d"],
    augend.constant.alias.alpha,
    augend.constant.alias.Alpha,
  },
}


vim.keymap.set("n", "<C-a>", function()
    require("dial.map").manipulate("increment", "normal")
end)
vim.keymap.set("n", "<C-x>", function()
    require("dial.map").manipulate("decrement", "normal")
end)
vim.keymap.set("n", "g<C-a>", function()
    require("dial.map").manipulate("increment", "gnormal")
end, {desc = "dial.nvim の gnormal increment"})
vim.keymap.set("n", "g<C-x>", function()
    require("dial.map").manipulate("decrement", "gnormal")
end)
vim.keymap.set("v", "<C-a>", function()
    require("dial.map").manipulate("increment", "visual")
end)
vim.keymap.set("v", "<C-x>", function()
    require("dial.map").manipulate("decrement", "visual")
end)
vim.keymap.set("v", "g<C-a>", function()
    require("dial.map").manipulate("increment", "gvisual")
end)
vim.keymap.set("v", "g<C-x>", function()
    require("dial.map").manipulate("decrement", "gvisual")
end)

require('Comment').setup()

require("mason").setup()

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
    model = "claude-3-5-sonnet-20240620",
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
    toggle = {
      debug = "<leader>vd",
      hint = "<leader>vh",
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

require("kulala").setup({
    -- cURL path
    -- if you have curl installed in a non-standard path,
    -- you can specify it here
    curl_path = "curl",

    -- split direction
    -- possible values: "vertical", "horizontal"
    split_direction = "vertical",

    -- default_view, body or headers or headers_body
    default_view = "body",

    -- dev, test, prod, can be anything
    -- see: https://learn.microsoft.com/en-us/aspnet/core/test/http-files?view=aspnetcore-8.0#environment-files
    default_env = "dev",

    -- enable/disable debug mode
    debug = false,

    -- default formatters/pathresolver for different content types
    contenttypes = {
      ["application/json"] = {
        ft = "json",
        formatter = { "jq", "." },
        pathresolver = require("kulala.parser.jsonpath").parse,
      },
      ["application/xml"] = {
        ft = "xml",
        formatter = { "xmllint", "--format", "-" },
        pathresolver = { "xmllint", "--xpath", "{{path}}", "-" },
      },
      ["text/html"] = {
        ft = "html",
        formatter = { "xmllint", "--format", "--html", "-" },
        pathresolver = {},
      },
    },

    -- can be used to show loading, done and error icons in inlay hints
    -- possible values: "on_request", "above_request", "below_request", or nil to disable
    -- If "above_request" or "below_request" is used, the icons will be shown above or below the request line
    -- Make sure to have a line above or below the request line to show the icons
    show_icons = "on_request",

    -- default icons
    icons = {
      inlay = {
        loading = "⏳",
        done = "✅",
        error = "❌",
      },
      lualine = "🐼",
    },

    -- additional cURL options
    -- see: https://curl.se/docs/manpage.html
    additional_curl_options = {},

    -- scratchpad default contents
    scratchpad_default_contents = {
      "@MY_TOKEN_NAME=my_token_value",
      "",
      "# @name scratchpad",
      "POST https://httpbin.org/post HTTP/1.1",
      "accept: application/json",
      "content-type: application/json",
      "",
      "{",
      '  "foo": "bar"',
      "}",
    },

    -- enable winbar
    winbar = false,

    -- Specify the panes to be displayed by default
    -- Current avaliable pane contains { "body", "headers", "headers_body", "script_output" },
    default_winbar_panes = { "body", "headers", "headers_body" },

    -- enable reading vscode rest client environment variables
    vscode_rest_client_environmentvars = false,

    -- disable the vim.print output of the scripts
    -- they will be still written to disk, but not printed immediately
    disable_script_print_output = false,

    -- set scope for environment and request variables
    -- possible values: b = buffer, g = global
    environment_scope = "b",

    -- certificates
    certificates = {},
})

EOF

" END
