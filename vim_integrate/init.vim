" " minimum setting {{{1 source ~/.config/nvim/rc/env.vim
"
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

" スト用コメント
let g:denops#debug = 0
" if g:IsWsl()
"   let g:denops_server_addr = '127.0.0.1:32123'
" endif

" yazi
nnoremap <silent> <leader>f :Yazi<CR>

" yanky
nnoremap <silent> <leader>y :Telescope yank_history<CR>

" gptme
let g:gptme_no_mappings = 1


" filetype
autocmd BufRead,BufNewFile *.ks set filetype=tyranoscript
autocmd Filetype tyranoscript setlocal commentstring=;\ %s

" clean command
augroup histclean
  autocmd!
  autocmd ModeChanged c:* call s:HistClean()
augroup END

function! s:HistClean() abort
  let cmd = histget(":", -1)
  if cmd == "x" || cmd == "xa" || cmd =~# "^w\\?q\\?a\\?!\\?$"
    call histdel(":", -1)
  endif
endfunction

" dsky
let g:dsky_id = 'takets.bsky.social'
let g:dsky_password = $DSKY_PASSWORD
nnoremap <leader>Pb :DSkySay<CR>

" mastodon.nvim
nnoremap <leader>Pm <Plug>(mstdn-editor-open)

function! s:CrossPost()
  let l:word = input("post > ", "")
  if l:word == ""
    return
  endif
  execute "DSkySay"
	let pos = getpos(".")
	execute ":normal a" . l:word
	call setpos('.', pos)
  call feedkeys("\<Esc>", 'n')  " normalモードに移行
  execute "normal \<Plug>(dsky_say_post_buffer)"

  call mstdn#request#post("takets@social.penguinability.net", #{status: l:word})

  " クリップボードにコピー
  if g:IsWsl()
    call setreg('+', l:word)
    call setreg('*', l:word)
  else
    let @+ = l:word
    let @* = l:word
  endif
endfunction
nnoremap <leader>PP :call <SID>CrossPost()<CR>
nnoremap <M-p> :call <SID>CrossPost()<CR>
nnoremap <D-p> :call <SID>CrossPost()<CR>

" " Avante
" nmap <silent> <Leader>va <Plug>(AvanteAsk)
" nmap <silent> <Leader>ve <Plug>(AvanteEdit)
" nmap <silent> <Leader>vr <Plug>(AvanteRefresh)
" vmap <silent> <Leader>va <Plug>(AvanteAsk)
" vmap <silent> <Leader>ve <Plug>(AvanteEdit)
" vmap <silent> <Leader>vr <Plug>(AvanteRefresh)

" codecompanion
nnoremap <C-a> :CodeCompanionActions<CR>
vnoremap <C-a> :CodeCompanionActions<CR>
nnoremap <Leader>ca :CodeCompanionChat Toggle<CR>
vnoremap <Leader>ca :CodeCompanionChat Toggle<CR>
vnoremap ga :CodeCompanionChat Add<CR>

" Previm
let g:previm_open_cmd = 'open -a "Microsoft Edge"'

" context.nvim
nnoremap <silent> ,ccf :ContextNvim add_current_file<CR>
nnoremap <silent> ,ccl :ContextNvim add_line_lsp_daig<CR>
nnoremap <silent> ,cch :ContextNvim find_context_history<CR>
nnoremap <silent> ,ccm :ContextNvim find_context_manual<CR>
vnoremap <silent> ,ccc :ContextNvim add_current<CR>

function! s:ClearContext()
  execute "ContextNvim clear_manual"
  execute "ContextNvim clear_history"
endfunction
nnoremap <silent> ,ccc :call <SID>ClearContext()<CR>

" temp
nmap <leader>r .

function! s:LazyGit()
  call setcellwidths([])
  lua require("snacks").lazygit()
endfunction
command! LazyGit call <SID>LazyGit()
nnoremap <silent> <leader>lg :LazyGit<CR>

function! s:Terminal()
  call setcellwidths([])
  lua require("snacks").terminal()
endfunction
command! Terminal call <SID>Terminal()
nnoremap <silent> <leader>gt :Terminal<CR>

" -----------------------------------------------------------
" lua
lua << EOF

require("codecompanion").setup({
  opts = {
    language = "Japanese",
  },
  display = {
    chat = {
      render_headers = true,
    },
  },
  diff = {
    enabled = true,
    close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
    layout = "vertical", -- vertical|horizontal split for default provider
    opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
    provider = "default", -- default|mini_diff
  },
  inline = {
    -- If the inline prompt creates a new buffer, how should we display this?
    layout = "vertical", -- vertical|horizontal|buffer
  },
  strategies = {
    chat = {
      adapter = "copilot",
      slash_commands = {
        ["file"] = {
          opts = {
            -- ref: https://github.com/olimorris/codecompanion.nvim/discussions/276
            provider = "telescope",
          },
        },
      },
    },
    inline = {
      adapter = "copilot",
    },
    agent = {
      adapter = "copilot",
    },
  },

  adapters = {
    copilot = function()
      return require("codecompanion.adapters").extend("copilot", {
        schema = {
          model = {
            default = "claude-3.5-sonnet",
          },
        },
      })
    end,
  },
})

require("mason").setup()

local navic = require("nvim-navic")
local on_attach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
  end
end
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers {
  function (server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup {
      on_attach = on_attach, --keyバインドなどの設定を登録
    }
  end,
}

local on_attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end

require("lspconfig").vimls.setup {
    on_attach = on_attach
}

require("lspconfig").intelephense.setup {
    on_attach = on_attach
}

require("lspconfig").denols.setup {
    on_attach = on_attach
}

require'nvim-web-devicons'.setup {
 -- your personnal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- DevIcon will be appended to `name`
 override = {
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  }
 };
 -- globally enable different highlight colors per icon (default to true)
 -- if set to false all icons will have the default icon's color
 color_icons = true;
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
 -- globally enable "strict" selection of icons - icon will be looked up in
 -- different tables, first by filename, and if not found by extension; this
 -- prevents cases when file doesn't have any extension but still gets some icon
 -- because its name happened to match some extension (default to false)
 strict = true;
 -- set the light or dark variant manually, instead of relying on `background`
 -- (default to nil)
 variant = "light|dark";
 -- same as `override` but specifically for overrides by filename
 -- takes effect when `strict` is true
 override_by_filename = {
  [".gitignore"] = {
    icon = "",
    color = "#f1502f",
    name = "Gitignore"
  }
 };
 -- same as `override` but specifically for overrides by extension
 -- takes effect when `strict` is true
 override_by_extension = {
  ["log"] = {
    icon = "",
    color = "#81e043",
    name = "Log"
  }
 };
 -- same as `override` but specifically for operating system
 -- takes effect when `strict` is true
 override_by_operating_system = {
  ["apple"] = {
    icon = "",
    color = "#A2AAAD",
    cterm_color = "248",
    name = "Apple",
  },
 };
}

require("snacks").setup({
  opts = {
    lazygit = { enabled = true },
    bufdelete = { enabled = true },
    notify = { enabled = true },
    scratch = { enabled = true },
    terminal = { enabled = true },
    toggle = {
      enabled = true,
      map = vim.keymap.set, -- keymap.set function to use
      which_key = true, -- integrate with which-key to show enabled/disabled icons and colors
      notify = true, -- show a notification when toggling
      -- icons for enabled/disabled states
      icon = {
        enabled = " ",
        disabled = " ",
      },
      -- colors for enabled/disabled states
      color = {
        enabled = "green",
        disabled = "yellow",
      },
    },
  },
})


require("context_nvim").setup({ 
  enable_history = true, -- whether to enable history context by tracking opened files/buffers
  history_length = 10, -- how many history items to track
  history_for_files_only = true, -- only use history for files, any non-file buffers will be ignored
  history_pattern = "*", -- history pattern to match files/buffers that will be tracked
  root_dir = ".", -- root directory of the project, used for finding files and constructing paths
  cmp = {
    enable = true, -- whether to enable the nvim-cmp source for referencing contexts

    register_cmp_avante = true, -- whether to include the cmp source for avante input buffers. 
                                -- They need to be registered using an autocmd, so this is a separate config option
    manual_context_keyword = "@manual_context", -- keyword to use for manual context
    history_keyword = "@history_context", -- keyword to use for history context
    prompt_keyword = "@prompt", -- keyword to use for prompt context
  },

  telescope = {
    enable = true, -- whether to enable the telescope picker
  },

  logger = {
    level = "error", -- log level for the plenary logger 
  },

  lsp = {
    ignore_sources = {}, -- lsp sources to ignore when adding line diagnostics to the manual context
  },
  prompts = {
        { 
            name = 'unit tests', -- the name of the prompt (required)
            prompt = 'Generate a suite of unit tests using Jest, respond with only code.', -- the prompt text (required)
            cmp = 'jest' -- an alternate name for the cmp completion source (optional) defaults to 'name'
        },
    }
})

require('cr-remover').setup{{
  exclude_patterns = { "%.git/" },
  -- auto_remove_on_save = true,
  auto_remove_on_paste = true,
  debug = false
}}

require('render-markdown').setup({
  file_types = { 'markdown', 'copilot-chat' },
})

if vim.fn.executable("nvr") == 1 then
  vim.env.GIT_EDITOR = "nvr --remote-tab-wait +'set bufhidden=delete'"
end

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

-- Gitsigns text objects
vim.keymap.set({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')

require('Comment').setup()


-- -- avante {{{1
-- require("img-clip").setup({
--   default = {
--     embed_image_as_base64 = false,
--     prompt_for_file_name = false,
--     drag_and_drop = {
--       insert_mode = true,
--     },
--   },
-- })
--
-- require('avante_lib').load()
-- require("avante").setup({
--   ---@alias Provider "openai" | "claude" | "azure"  | "copilot" | "cohere" | [string]
--   provider = "copilot",
--   claude = {
--     endpoint = "https://api.anthropic.com",
--     model = "claude-3-5-sonnet-20241022",
--     temperature = 0,
--     max_tokens = 8000,
--   },
--   copilot = {
--     endpoint = "https://api.githubcopilot.com",
--     model = "gpt-4o-2024-08-06",
--     proxy = nil, -- [protocol://]host[:port] Use this proxy
--     allow_insecure = false, -- Allow insecure server connections
--     timeout = 30000, -- Timeout in milliseconds
--     temperature = 0,
--     max_tokens = 4096,
--   },
--   dual_boost = {
--     enabled = false,
--     first_provider = "claude",
--     second_provider = "copilot",
--     prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
--     timeout = 60000, -- Timeout in milliseconds
--   },
-- 	-- provider = "copilot",
--   -- auto_suggestions_provider = "copilot",
--   behaviour = {
--     auto_suggestions = false, -- Experimental stage
--     auto_set_highlight_group = true,
--     auto_set_keymaps = false,
--     auto_apply_diff_after_generation = false,
--     support_paste_from_clipboard = true,
--   },
--   mappings = {
--     ask = "<leader>va",
--     edit = "<leader>ve",
--     refresh = "<leader>vr",
--     toggle = "<leader>vt",
--     frocus = "<leader>vf",
--     toggle = {
--       default = "<leader>vt",
--       debug = "<leader>vd",
--       hint = "<leader>vh",
--       suggestion = "<leader>vs",
--       repo_map = "<leader>vz",
--     },
--     --- @class AvanteConflictMappings
--     diff = {
--       ours = "co",
--       theirs = "ct",
--       both = "cb",
--       next = "]x",
--       prev = "[x",
--     },
--     jump = {
--       next = "]]",
--       prev = "[[",
--     },
--     submit = {
--       normal = "<CR>",
--       insert = "<C-s>",
--     },
--     suggestion = {
--       accept = "<M-l>",
--       next = "<M-]>",
--       prev = "<M-[>",
--       dismiss = "<C-]>",
--     },
--     toggle = {
--       debug = "<leader>vd",
--       hint = "<leader>vh",
--     },
--     sidebar = {
--       apply_all = "A",
--       apply_cursor = "a",
--       switch_windows = "<Tab>",
--       reverse_switch_windows = "<S-Tab>",
--     },
--   },
--   hints = { enabled = true },
--   windows = {
--     wrap = true, -- similar to vim.o.wrap
--     width = 50, -- default % based on available width
--     sidebar_header = {
--       align = "center", -- left, center, right for title
--       rounded = true,
--     },
--     ask = {
--       floating = false,
--       start_insert = true,
--       border = "rounded"
--     },
--   },
--   highlights = {
--     ---@type AvanteConflictHighlights
--     diff = {
--       current = "DiffText",
--       incoming = "DiffAdd",
--     },
--   },
--   --- @class AvanteConflictUserConfig
--   diff = {
--     debug = false,
--     autojump = true,
--     ---@type string | fun(): any
--     list_opener = "copen",
--   },
-- })
-- -- }}}1

EOF

" END
