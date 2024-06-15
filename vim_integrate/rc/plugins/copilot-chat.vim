lua << EOF
local copilot_chat = require("CopilotChat")
copilot_chat.setup({
  debug = false,
  show_system_prompt = false,
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
      normal = 'gm',
      insert = '<C-m>'
    },
    accept_diff = {
      normal = 'ga',
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
  window = {
    layout = 'horizontal', -- 'vertical', 'horizontal', 'float'
    -- Options below only apply to floating windows
    relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
    border = 'double', -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
    width = 0.8, -- fractional width of parent
    height = 0.6, -- fractional height of parent
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
" vnoremap <leader>cv :CopilotChat 
vnoremap <CR>cr :CopilotChatReview
vnoremap <CR>cd :CopilotChat
vnoremap <CR>ce :CopilotChatExplain
vnoremap <CR>cc :CopilotChat 
vnoremap <M-c> :CopilotChat 
vnoremap <D-c> :CopilotChat 
vnoremap <CR>cf :CopilotChatFix 
vnoremap <CR>co :CopilotChatOptimize 
nnoremap <CR>cc :CopilotChat<CR>
nnoremap <silent> <M-c> :CopilotChat<CR>
nnoremap <silent> <D-c> :CopilotChat<CR>
