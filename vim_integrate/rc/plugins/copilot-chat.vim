lua << EOF
local copilot_chat = require("CopilotChat")

copilot_chat.setup({
  -- Shared config starts here (can be passed to functions at runtime and configured via setup function)

  model = 'o3-mini', -- Default model to use, see ':CopilotChatModels' for available models (can be specified manually in prompt via $).
  agent = 'copilot', -- Default agent to use, see ':CopilotChatAgents' for available agents (can be specified manually in prompt via @).
  context = nil, -- Default context or array of contexts to use (can be specified manually in prompt via #).
  sticky = nil, -- Default sticky prompt or array of sticky prompts to use at start of every new chat.

  temperature = 0.1, -- GPT result temperature
  headless = false, -- Do not write to chat buffer and use history(useful for using callback for custom processing)
  callback = nil, -- Callback to use when ask response is received

  -- default selection
  selection = function(source)
    return select.visual(source) or select.buffer(source)
  end,

  -- default window options
  window = {
    layout = 'vertical', -- 'vertical', 'horizontal', 'float', 'replace'
    width = 0.5, -- fractional width of parent, or absolute width in columns when > 1
    height = 0.5, -- fractional height of parent, or absolute height in rows when > 1
    -- Options below only apply to floating windows
    relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
    border = 'single', -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
    row = nil, -- row position of the window, default is centered
    col = nil, -- column position of the window, default is centered
    title = 'Copilot Chat', -- title of chat window
    footer = nil, -- footer of chat window
    zindex = 1, -- determines if window is on top or below other floating windows
  },

  show_help = true, -- Shows help message as virtual lines when waiting for user input
  show_folds = true, -- Shows folds for sections in chat
  highlight_selection = true, -- Highlight selection
  highlight_headers = true, -- Highlight headers in chat, disable if using markdown renderers (like render-markdown.nvim)
  auto_follow_cursor = true, -- Auto-follow cursor in chat
  auto_insert_mode = false, -- Automatically enter insert mode when opening window and on new prompt
  insert_at_end = false, -- Move cursor to end of buffer when inserting text
  clear_chat_on_new_prompt = false, -- Clears chat on every new prompt

  -- Static config starts here (can be configured only via setup function)

  debug = false, -- Enable debug logging (same as 'log_level = 'debug')
  log_level = 'info', -- Log level to use, 'trace', 'debug', 'info', 'warn', 'error', 'fatal'
  proxy = nil, -- [protocol://]host[:port] Use this proxy
  allow_insecure = false, -- Allow insecure server connections

  chat_autocomplete = true, -- Enable chat autocompletion (when disabled, requires manual `mappings.complete` trigger)

  log_path = vim.fn.stdpath('state') .. '/CopilotChat.log', -- Default path to log file
  history_path = vim.fn.stdpath('data') .. '/copilotchat_history', -- Default path to stored history

  question_header = '# User ', -- Header to use for user questions
  answer_header = '# Copilot ', -- Header to use for AI answers
  error_header = '# Error ', -- Header to use for errors
  separator = '───', -- Separator to use in chat

  -- -- default providers
  -- -- see config/providers.lua for implementation
  -- providers = {
  --   copilot = {
  --   },
  --   github_models = {
  --   },
  --   copilot_embeddings = {
  --   },
  -- }
  --
  -- -- default contexts
  -- -- see config/contexts.lua for implementation
  -- contexts = {
  --   buffer = {
  --   },
  --   buffers = {
  --   },
  --   file = {
  --   },
  --   files = {
  --   },
  --   git = {
  --   },
  --   url = {
  --   },
  --   register = {
  --   },
  --   quickfix = {
  --   },
  -- },

  -- default prompts
  -- see config/prompts.lua for implementation
  prompts = {
    Explain = {
      prompt = '> /COPILOT_EXPLAIN\n\nWrite an explanation for the selected code as paragraphs of text.',
    },
    Review = {
      prompt = '> /COPILOT_REVIEW\n\nReview the selected code.',
    },
    Fix = {
      prompt = '> /COPILOT_GENERATE\n\nThere is a problem in this code. Rewrite the code to show it with the bug fixed.',
    },
    Optimize = {
      prompt = '> /COPILOT_GENERATE\n\nOptimize the selected code to improve performance and readability.',
    },
    Docs = {
      prompt = '> /COPILOT_GENERATE\n\nPlease add documentation comments to the selected code.',
    },
    Tests = {
      prompt = '> /COPILOT_GENERATE\n\nPlease generate tests for my code.',
    },
    Commit = {
      prompt = '> #git:staged\n\nWrite commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.',
    },
  },

  -- default mappings
  -- see config/mappings.lua for implementation
  mappings = {
    complete = {
      insert = '<Tab>',
    },
    close = {
      normal = 'q',
      insert = '<C-c>',
    },
    reset = {
      normal = '<C-l>',
      insert = '<C-l>',
    },
    submit_prompt = {
      normal = '<CR>',
      insert = '<C-s>',
    },
    toggle_sticky = {
      detail = 'Makes line under cursor sticky or deletes sticky line.',
      normal = 'gr',
    },
    accept_diff = {
      normal = '<C-y>',
      insert = '<C-y>',
    },
    jump_to_diff = {
      normal = 'gj',
    },
    quickfix_answers = {
      normal = 'gqa',
    },
    quickfix_diffs = {
      normal = 'gqd',
    },
    yank_diff = {
      normal = 'gy',
      register = '"', -- Default register to use for yanking
    },
    show_diff = {
      normal = 'gd',
      full_diff = false, -- Show full diff instead of unified diff when showing diff window
    },
    show_info = {
      normal = 'gi',
    },
    show_context = {
      normal = 'gc',
    },
    show_help = {
      normal = 'gh',
    },
  },
})

EOF

" CopilotChat
" 行選択モードで <leader>cr を押すと CopilotChatReview を実行
vnoremap <leader>cr :CopilotChatReview<CR>

" 行選択モードで <leader>ce を押すと CopilotChatExplain を実行
vnoremap <leader>ce :CopilotChatExplain<CR>

" 行選択モードで <Tab> を押すと CopilotChat を実行
vnoremap <Tab> :CopilotChat 

" 行選択モードで <leader>cf を押すと CopilotChatFix を実行
vnoremap <leader>cf :CopilotChatFix<CR>

" 行選択モードで <leader>co を押すと CopilotChatOptimize を実行
vnoremap <leader>co :CopilotChatOptimize<CR>

" 行選択モードで <M-c> と <D-c> を押すと CopilotChat を実行
vnoremap <M-c> :CopilotChat
vnoremap <D-c> :CopilotChat

" 通常モードで <M-c> と <D-c> を押すと CopilotChat を実行
nnoremap <silent> <M-c> :CopilotChat<CR>
nnoremap <silent> <D-c> :CopilotChat<CR>
