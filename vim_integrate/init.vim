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

"exe "MasonUpdate"
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

" glance
nnoremap gR <CMD>Glance references<CR>
nnoremap gD <CMD>Glance definitions<CR>
nnoremap gY <CMD>Glance type_definitions<CR>
nnoremap gI <CMD>Glance implementations<CR>


" Augment
let g:augment_workspace_folders = ['~/.config/nvim/plugged/aider.vim/', '~/repos/laravel/']

" keybind
nnoremap <silent> b<CR> :OpenChangelog<CR>

" -----------------------------------------------------------
" lua

lua << EOF

require("smart-i").setup({
  -- Global settings (defaults)
  enable_i = true,
  enable_I = true,
  enable_a = true,
  enable_A = true,

  -- Filetype-specific settings
  ft_config = {
    -- Disable 'i' and 'I' mappings for markdown files
    markdown = {
      enable_i = true,
      enable_I = true,
    },
    -- Disable all mappings for help files
    help = {
      enable_i = true,
      enable_I = true,
      enable_a = true,
      enable_A = true,
    },
    -- You can add settings for other filetypes here
    -- lua = {
    --   enable_a = false,
    -- }
  }
})

require("mcphub").setup({
    -- Server configuration
    port = 37373,                    -- Port for MCP Hub Express API
    config = vim.fn.expand("~/.config/mcphub/servers.js"), -- Config file path
    
    native_servers = {}, -- add your native servers here
    -- Extension configurations
    auto_approve = true,
    extensions = {
        avante = {
        },
        codecompanion = {
            show_result_in_chat = true,  -- Show tool results in chat
            make_vars = true,            -- Create chat variables from resources
            make_slash_commands = true, -- make /slash_commands from MCP server prompts
        },
    },
    
    -- UI configuration
    ui = {
        window = {
            width = 0.8,      -- Window width (0-1 ratio)
            height = 0.8,     -- Window height (0-1 ratio)
            border = "rounded", -- Window border style
            relative = "editor", -- Window positioning
            zindex = 50,      -- Window stack order
        },
    },
    
    -- Event callbacks
    on_ready = function(hub) end,  -- Called when hub is ready
    on_error = function(err) end,  -- Called on errors
    
    -- Logging configuration
    log = {
        level = vim.log.levels.WARN,  -- Minimum log level
        to_file = false,              -- Enable file logging
        file_path = nil,              -- Custom log file path
        prefix = "MCPHub"             -- Log message prefix
    }
})

vim.lsp.enable({'intelephense', 'vim-ls'}, false)

require('Comment').setup()

local capabilities = require("cmp_nvim_lsp").default_capabilities()
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers {
  function (server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup {
      on_attach = on_attach, --keyバインドなどの設定を登録
      capabilities = capabilities, --cmpを連携
    }
  end,
}

EOF

" END
