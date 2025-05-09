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

" let g:denops_server_addr = '127.0.0.1:32129'

" url-highlight
let g:highlighturl_guifg = '#4aa3ff'

" glance
nnoremap gR <CMD>Glance references<CR>
nnoremap gD <CMD>Glance definitions<CR>
nnoremap gY <CMD>Glance type_definitions<CR>
nnoremap gI <CMD>Glance implementations<CR>

" keybind
nnoremap M %


" testing
let g:crosschannel_bluesky_id = 'takets.bsky.social'
let g:crosschannel_bluesky_password = $DSKY_PASSWORD

let g:crosschannel_mastodon_host = $MASTODON_HOST
let g:crosschannel_mastodon_client_name = 'crosschannel-nvim'
let g:crosschannel_mastodon_token = $MASTODON_TOKEN
let g:crosschannel_mastodon_username = $MASTODON_USERNAME
let g:crosschannel_mastodon_password = $MASTODON_PASSWORD

let g:crosschannel_x_consumer_key = $X_CONSUMER_KEY
let g:crosschannel_x_consumer_secret = $X_CONSUMER_SECRET
let g:crosschannel_x_access_token = $X_ACCESS_TOKEN
let g:crosschannel_x_access_token_secret = $X_ACCESS_TOKEN_SECRET
let g:crosschannel_x_bearer_token = $X_BEARER_TOKEN

nnoremap <Leader>: :

let g:autosave_enabled = v:true
let g:autosave_disable_inside_paths = [] " A list of paths inside which autosave should be disabled. 

" -----------------------------------------------------------
" lua

lua << EOF

require("nudge-two-hats").setup({
  -- Prompt configuration
  system_prompt = "Give advice about this code change, focusing on which hat (refactoring or feature) the programmer is wearing.",

  -- File type specific prompts
  filetype_prompts = {
    -- Text/writing related filetypes
    markdown = {
      prompt = "Give advice about this writing, focusing on clarity and structure.",
      role = "Cognitive behavioral therapy specialist",
      direction = "Guide towards clearer and more structured writing",
      emotion = "Empathetic and understanding",
      tone = "Supportive and encouraging but direct",
    },
    text = {
      purpose = "集中が途切れないように、ナッジによってさりげなく現在の行動を促す",
			hats = {
				"law",
				"chaos",
				"neutral",
				"trickster",
				},
      prompt = "テキスト内容を題材として、アドバイスしてください。前置きなしで、端的にメッセージのみを出力してください。",
      role = "トリックスターであり、常に民衆の意表を突く発言のみを行う",
      direction = "意味深なアドバイスを行う",
      emotion = "Empathetic and understanding",
      tone = "前置きなしで、直接的に",
    },

    -- Programming languages (examples)
    lua = "Give advice about this Lua code change, focusing on which hat (refactoring or feature) the programmer is wearing.",
    python = "Give advice about this Python code change, focusing on which hat (refactoring or feature) the programmer is wearing.",
  },

  -- Message length configuration
  message_length = 100, -- Default length of the advice message
  length_type = "characters", -- Can be "characters" (for Japanese) or "words" (for English)

  -- language configuration
  output_language = "ja", -- Can be "auto", "en" (English), or "ja" (Japanese)
  translate_messages = true, -- Whether to translate messages to the specified language

  -- Timing configuration
  execution_delay = 600000, -- Delay in milliseconds (1 minute)
  min_interval= 3, -- Minimum interval between API calls in seconds

	virtual_text = {
		idle_time = 1, -- Time in minutes before showing virtual text
    cursor_idle_delay = 1, -- Time in minutes before setting timers after cursor stops
		text_color = "#000000", -- Text color in hex format
		background_color = "#FFFFFF", -- Background color in hex format
  },

  -- Debug configuration
  debug_mode = false, -- When true, prints nudge text to Vim's 
})

function get_git_diff()
  local repo_path = vim.fn.expand("~/repos/changelog")
  local command = string.format("git -C %s log -p -5", repo_path)
  local diff_output = vim.fn.system(command)

  if vim.v.shell_error == 0 and diff_output and diff_output ~= "" then
    local lines_to_insert = vim.split(diff_output, "\n")
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_buf_set_lines(0, cursor_pos[1] - 1, cursor_pos[1] - 1, false, lines_to_insert)
    print("Git diff inserted at cursor.")
  else
    local error_message = "Failed to get git diff from " .. repo_path .. "."
    if vim.v.shell_error ~= 0 then
      error_message = error_message .. " Shell error code: " .. vim.v.shell_error
    end
    if diff_output and diff_output ~= "" then
       error_message = error_message .. "\nOutput:\n" .. diff_output
    elseif not diff_output or diff_output == "" then
       error_message = error_message .. " No output from git command."
    end
    local error_lines = vim.split(error_message, "\n")
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_buf_set_lines(0, cursor_pos[1] - 1, cursor_pos[1] - 1, false, error_lines)
    print("Error message inserted at cursor.")
  end
end

require('goose').setup({
  keymap = {
    global = {
      toggle = '<leader>gg',                 -- Open goose. Close if opened 
      open_input = '<leader>gi',             -- Opens and focuses on input window on insert mode
      open_input_new_session = '<leader>gI', -- Opens and focuses on input window on insert mode. Creates a new session
      open_output = '<leader>go',            -- Opens and focuses on output window 
      close = '<leader>gq',                  -- Close UI windows
      toggle_fullscreen = '<leader>gR',      -- Toggle between normal and fullscreen mode
      select_session = '<leader>gT',         -- Select and load a goose session
    },
    window = {
      submit = '<cr>',                     -- Submit prompt
      close = '<esc>',                     -- Close UI windows
      stop = '<C-c>',                      -- Stop a running job
      next_message = ']]',                 -- Navigate to next message in the conversation
      prev_message = '[[',                 -- Navigate to previous message in the conversation
      mention_file = '@'                   -- Pick a file and add to context. See File Mentions section
    }
    },
  ui = {
    window_width = 0.35,                   -- Width as percentage of editor width
    input_height = 0.15,                   -- Input height as percentage of window height
    fullscreen = false                     -- Start in fullscreen mode (default: false)
  }
})

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

require('Comment').setup()

EOF

" Lua関数get_git_diffをVimコマンドとして呼び出せるようにする
command! GetGitDiff lua get_git_diff()

" END
" i
