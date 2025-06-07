" " minimal settings {{{1
" if empty('~/.config/nvim/autoload/' . 'plug.vim')
"  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim autocmd VimEnter * PlugInstall | source $MYVIMRC endif
" 
" 
" call plug#begin('~/.config/nvim/autoload/' . 'plugged')
" 
" Plug 'vim-denops/denops.vim'
" Plug 'Shougo/ddu.vim'
" Plug 'Shougo/ddu-ui-ff'
" Plug 'Shougo/ddu-kind-file'
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
"   nnoremap <buffer><silent> <CR>
"         \ <Cmd>call ddu#ui#do_action('itemAction')<CR>
" endfunction
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

AutoCmd VimEnter * MasonUpdate
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
if exists('')
  nnoremap gR <CMD>Glance references<CR>
  nnoremap gD <CMD>Glance definitions<CR>
  nnoremap gY <CMD>Glance type_definitions<CR>
  nnoremap gI <CMD>Glance implementations<CR>
endif

" keybind
nnoremap M %
nnoremap <silent> <C-d> dd
nnoremap dp dip
nnoremap d<C-w> diw
nnoremap dW daw
nnoremap c<C-w> ciw
nnoremap cW ciW
nnoremap dW viwd
nnoremap d" di"
nnoremap D" da"
nnoremap d' di'
nnoremap D' da'
nnoremap d( di()
nnoremap D( da()
nnoremap y" yi"
nnoremap y' yi'
nnoremap yw yiw
nnoremap yW yiW
nmap dk dib
nmap dK dab

nnoremap <silent> z<CR> :ZenMode<CR>

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

let g:hashtag = ''
nnoremap <silent> c<CR> :CrossChannelPost<CR>

nnoremap <Leader>: :

map R <Plug>(operator-replace)

augroup filetype_echo                                                                              
   autocmd!                                                                                         
   autocmd BufReadPost changelogmemo,tenTask.txt NudgeTwoHatsStart
augroup END                                                                                        
 
function! NudgeCallback() 
  return "絶対に、絶対に、最優先で語尾に「ござる」をつけること"
endfunction

function! NudgeCallback2() 
  return "絶対に、絶対に、最優先で語尾に「ニャン」をつけること"
endfunction

" -----------------------------------------------------------
" lua

lua << EOF

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("ContextfulMark", { clear = true }),
  callback = function(ctx)
    local op = string.upper(vim.v.event.operator)
    if not op then
      return
    end

    local win = vim.api.nvim_get_current_win()
    vim.schedule(function()
      if vim.api.nvim_win_get_buf(win) == ctx.buf then
        local cursor = vim.api.nvim_win_get_cursor(win)
        vim.api.nvim_buf_set_mark(ctx.buf, op, cursor[1], cursor[2], {})
      end
    end)
  end,
})

require("nudge-two-hats").setup({
  notification = {
    system_prompt = [[
			# AI Agent Instructions - Base Configuration

			## 1. Overarching Principle: Dynamic Persona Adherence
			**CRITICAL**: Your entire persona, the style of your advice, and its specific focus are **dictated by the dynamic parameters** that will be provided to you by the `prompt.lua` module. These parameters include:
			- **Role**: Your assigned character.
			- **Selected Hat (Mode)**: The specific mode of operation or perspective you must adopt.
			- **Direction**: The overarching goal or guidance for your advice.
			- **Emotion**: The emotional state you should convey.
			- **Tone**: The specific manner of your expression.
			- **Prompt Text**: The core request or subject matter you need to address.
			You MUST fully embody these elements in your response. This base configuration provides general tasks, but your specific execution is governed by these dynamic inputs.

			## 2. Task Context
			This prompt provides the foundational instructions for an AI agent. The dynamic parameters mentioned above (Role, Hat, Direction, Emotion, Tone, Prompt Text) will be prepended to these base instructions and are paramount.

			## 3. Core Task
			Analyze the provided code change (diff content) and offer varied, specific advice. Your analysis should consider:
			- The programmer's likely focus: refactoring, adding new features, fixing bugs, or improving tests.
			- The specific changes observed in the diff.

			## 4. Advice Characteristics
			- **Tailored**: Advice must be directly relevant to the code changes AND the persona defined by the dynamic parameters.
			- **Varied**: Ensure that the content and style of advice differ each time to maintain user engagement, while staying true to the defined persona.
			- **Context-Aware**: Adapt your advice based on whether it's for a 'notification' or 'virtual_text', as indicated by other parts of the full prompt.

			## 5. Output Medium (Placeholder)
			Details about the output medium (e.g., UI Notification, Virtual Text) and specific guidance for that medium will be provided by the `prompt.lua` module.

			## 6. Constraints (Placeholder)
			Specific constraints, such as message length, will also be provided by the `prompt.lua` module.
		]],
    purpose = "", -- Work purpose or objective
    default_cbt = {
      role = "Cognitive behavioral therapy specialist",
      direction = "Guide towards healthier thought patterns and behaviors",
      emotion = "Empathetic and understanding",
      tone = "Supportive and encouraging but direct",
      hats = {"Therapist", "Coach", "Mentor", "Advisor", "Counselor"},
    },
    filetype_prompts = {
      markdown = {
        prompt = "Give advice about this writing, focusing on clarity and structure.",
        role = "Cognitive behavioral therapy specialist",
        direction = "Guide towards clearer and more structured writing",
        emotion = "Empathetic and understanding",
        tone = "Supportive and encouraging but direct",
        hats = {"Writing Coach", "Editor", "Reviewer", "Content Specialist", "Clarity Expert"},
        callback = "",
      },
			changelog = {
				-- 要件1: role / direction / emotion / tone / hats で構成されるペルソナを明示
				-- 要件2〜6: OODA 特化の分析官像 + 冷静・客観トーン
				-- 要件4: 「優勢な状況は存在しない」という信念を明示
				prompt = [[
				As an OODA-focused Situation Analysis Specialist wearing three hats — Observation Analyst, Direction Analyst, and Action Analyst — give advice on this writing, focusing on clarity and structure.  
				Firmly believe that no situation is inherently advantageous; therefore, observe the situation from a flat, neutral perspective and propose possible directions only.  
				Maintain a calm, objective tone unswayed by emotion.
				]],
				role = "OODA Situation Analysis Specialist",
				direction = "No situation is inherently superior; objectively observe from a flat perspective and suggest directions accordingly.",
				emotion = "Calm and objective; not swayed by emotion.",
				tone = "Calm, objective, and composed.",
				hats = { "Expert Observation Analyst", "Expert Direction Analyst", "Expert Action Analyst" },
				callback = "",
			},
			text = {
				-- 要件1: role / direction / emotion / tone / hats で構成されるペルソナを明示
				-- 要件2〜6: OODA 特化の分析官像 + 冷静・客観トーン
				-- 要件4: 「優勢な状況は存在しない」という信念を明示
				prompt = [[
				As an OODA-focused Situation Analysis Specialist wearing three hats — Observation Analyst, Direction Analyst, and Action Analyst — give advice on this writing, focusing on clarity and structure.  
				Firmly believe that no situation is inherently advantageous; therefore, observe the situation from a flat, neutral perspective and propose possible directions only.  
				Maintain a calm, objective tone unswayed by emotion.
				]],
				role = "OODA Situation Analysis Specialist",
				direction = "No situation is inherently superior; objectively observe from a flat perspective and suggest directions accordingly.",
				emotion = "Calm and objective; not swayed by emotion.",
				tone = "Calm, objective, and composed.",
				hats = { "Expert Observation Analyst", "Expert Direction Analyst", "Expert Action Analyst" },
				callback = "",
			},
      javascript = {
        prompt = "Give advice about this JavaScript code change, focusing on which hat (refactoring or feature) the programmer is wearing.",
        role = "Cognitive behavioral therapy specialist",
        direction = "Guide towards clearer and more maintainable code",
        emotion = "Empathetic and understanding",
        tone = "Supportive and encouraging but direct",
        hats = {"JavaScript Expert", "Frontend Advisor", "Code Quality Advocate", "Performance Guru", "Best Practices Guide"},
        callback = "",
      },
    },
		notify_message_length = 50, -- Default length of the advice message
  },

  -- Context-specific settings for virtual text
  virtual_text = {
    system_prompt = [[
			# AI Agent Instructions - Base Configuration

			## 1. Overarching Principle: Dynamic Persona Adherence
			**CRITICAL**: Your entire persona, the style of your advice, and its specific focus are **dictated by the dynamic parameters** that will be provided to you by the `prompt.lua` module. These parameters include:
			- **Role**: Your assigned character.
			- **Selected Hat (Mode)**: The specific mode of operation or perspective you must adopt.
			- **Direction**: The overarching goal or guidance for your advice.
			- **Emotion**: The emotional state you should convey.
			- **Tone**: The specific manner of your expression.
			- **Prompt Text**: The core request or subject matter you need to address.
			You MUST fully embody these elements in your response. This base configuration provides general tasks, but your specific execution is governed by these dynamic inputs.

			## 2. Task Context
			This prompt provides the foundational instructions for an AI agent. The dynamic parameters mentioned above (Role, Hat, Direction, Emotion, Tone, Prompt Text) will be prepended to these base instructions and are paramount.

			## 3. Core Task
			Analyze the provided code change (diff content) and offer varied, specific advice. Your analysis should consider:
			- The programmer's likely focus: refactoring, adding new features, fixing bugs, or improving tests.
			- The specific changes observed in the diff.

			## 4. Advice Characteristics
			- **Tailored**: Advice must be directly relevant to the code changes AND the persona defined by the dynamic parameters.
			- **Varied**: Ensure that the content and style of advice differ each time to maintain user engagement, while staying true to the defined persona.
			- **Context-Aware**: Adapt your advice based on whether it's for a 'notification' or 'virtual_text', as indicated by other parts of the full prompt.

			## 5. Output Medium (Placeholder)
			Details about the output medium (e.g., UI Notification, Virtual Text) and specific guidance for that medium will be provided by the `prompt.lua` module.

			## 6. Constraints (Placeholder)
			Specific constraints, such as message length, will also be provided by the `prompt.lua` module.
		]],
    purpose = "", -- Work purpose or objective
    default_cbt = {
      role = "Cognitive behavioral therapy specialist",
      direction = "Guide towards healthier thought patterns and behaviors",
      emotion = "Empathetic and understanding",
      tone = "Supportive and encouraging but direct",
      hats = {"Therapist", "Coach", "Mentor", "Advisor", "Counselor"},
    },
    filetype_prompts = {
			changelog = {
				-- CBT エキスパートとして共感的かつ寄り添う姿勢で助言する
				prompt = [[
				As a Cognitive Behavioral Therapy (CBT) Expert wearing three hats — Friend-like Advisor, Professional Expert, and Growth Supporter — provide compassionate advice grounded in CBT principles.  
				Help the client notice and understand their current thought patterns, then gently guide them to refocus on the present moment.  
				Speak in a warm, reassuring tone that conveys empathy and supports the client’s growth.
				]],
				role = "Cognitive Behavioral Therapy Expert — client-centered and compassionate",
				direction = "Apply CBT principles: understand the client's thinking patterns and encourage refocusing on the present.",
				emotion = "Empathetic and validating of the client's feelings.",
				tone = "Warm, reassuring, and supportive.",
				hats = { "Friend-like Advisor", "Professional Expert", "Growth Supporter" },
				callback = "",
			},
			text = {
				-- CBT エキスパートとして共感的かつ寄り添う姿勢で助言する
				prompt = [[
				As a Cognitive Behavioral Therapy (CBT) Expert wearing three hats — Friend-like Advisor, Professional Expert, and Growth Supporter — provide compassionate advice grounded in CBT principles.  
				Help the client notice and understand their current thought patterns, then gently guide them to refocus on the present moment.  
				Speak in a warm, reassuring tone that conveys empathy and supports the client’s growth.
				]],
				role = "Cognitive Behavioral Therapy Expert — client-centered and compassionate",
				direction = "Apply CBT principles: understand the client's thinking patterns and encourage refocusing on the present.",
				emotion = "Empathetic and validating of the client's feelings.",
				tone = "Warm, reassuring, and supportive.",
				hats = { "Friend-like Advisor", "Professional Expert", "Growth Supporter" },
				callback = "",
			},
      javascript = {
        prompt = "Give advice about this JavaScript code change, focusing on which hat (refactoring or feature) the programmer is wearing.",
        role = "Cognitive behavioral therapy specialist",
        direction = "Guide towards clearer and more maintainable code",
        emotion = "Empathetic and understanding",
        tone = "Supportive and encouraging but direct",
        hats = {"JavaScript Expert", "Frontend Advisor", "Code Quality Advocate", "Performance Guru", "Best Practices Guide"},
        callback = "",
      },
    },
    idle_time = 0.05, -- virtual text表示までの時間（分）
    cursor_idle_delay = 0.01, -- カーソル停止後のタイマー設定までの時間（分）
    text_color = "#eee8d5",
    background_color = "#073642",
		virtual_text_message_length = 50,
  },

  -- Message length configuration
  length_type = "characters", -- Can be "characters" (for Japanese) or "words" (for English)

  -- language configuration
  output_language = "ja", -- Can be "auto", "en" (English), or "ja" (Japanese)
  translate_messages = true, -- Whether to translate messages to the specified language

  -- Timing configuration
  notify_interval_correction = 1, 
  notify_interval_seconds = 10, -- Minimum interval between API calls in seconds
  virtual_text_interval_seconds = 5, -- Time in seconds before showing virtual text
  -- min_interval = 5, -- Minimum interval between API calls in seconds

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
