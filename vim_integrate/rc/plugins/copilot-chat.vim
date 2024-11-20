lua << EOF
local copilot_chat = require("CopilotChat")
copilot_chat.setup({
  debug = false,
  show_system_prompt = false,
	model = "claude-3.5-sonnet",
	chat_autocomplete = true,
  mappings = {
    complete = {
      detail = 'Use @<Tab> or /<Tab> for options.',
      insert ='gc',
    },
    close = {
      normal = 'q',
    },
    reset = {
      normal ='<C-c>',
      insert = '<C-c>'
    },
    submit_prompt = {
      normal = '<CR>',
      insert = '<C-s>'
    },
    accept_diff = {
      normal = 'ga',
      insert = '<C-y>'
    },
    show_diff = {
      normal = 'gd'
    },
    show_system_prompt = {
      normal = 'gp'
    },
    show_user_selection = {
      normal = 'gs'
    },
  },
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
  prompts = {
    Explain = {
      prompt = '/COPILOT_EXPLAIN Write a explanation for the code above as paragraphs of text by Japanese.',
    },
    Tests = {
      prompt = '/COPILOT_TESTS Write a set of detailed unit test functions for the code above. And copilot system message text by Japanese.',
    },
    Fix = {
      prompt = '/COPILOT_FIX There is a problem in this code. Rewrite the code to show it with the bug fixed. And copilot system message text by Japanese.',
    },
    Optimize = {
      prompt = '/COPILOT_REFACTOR Optimize the selected code to improve performance and readablilty. And copilot system message text by Japanese.',
    },
    Docs = {
      prompt = '/COPILOT_REFACTOR Write documentation for the selected code. The reply should be a codeblock containing the original code with the documentation added as comments. Use the most appropriate documentation style for the programming language used (e.g. JSDoc for JavaScript, docstrings for Python etc. And copilot system message text by Japanese.',
    },
    FixDiagnostic = {
      prompt = 'Please assist with the following diagnostic issue in file. And copilot system message text by Japanese.:',
    },
    Commit = {
      prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit. And copilot system message text by Japanese.',
    },
    Review = {
      prompt = 'Review the selected code. And copilot system message text by Japanese.',
    },

    CommitStaged = {
      prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit. And copilot system message text by Japanese.',
      selection = function(source)
        return select.gitdiff(source, true)
      end,
    },
  },
  build = function()
    vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
  end,
  event = "VeryLazy",
})



EOF

" CopilotChat
vnoremap <leader>cr :CopilotChatReview
vnoremap <leader>ce :CopilotChatExplain
vnoremap <leader>cc :CopilotChat 
vnoremap <leader>cf :CopilotChatFix 
vnoremap <leader>co :CopilotChatOptimize 
nnoremap <leader>cc :CopilotChat<CR>
vnoremap <M-c> :CopilotChat 
vnoremap <D-c> :CopilotChat 
nnoremap <silent> <M-c> :CopilotChat<CR>
nnoremap <silent> <D-c> :CopilotChat<CR>
