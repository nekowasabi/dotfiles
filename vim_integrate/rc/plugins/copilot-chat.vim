lua << EOF
local copilot_chat = require("CopilotChat")
local select = require("CopilotChat.select")
copilot_chat.setup({
  debug = false,
  show_system_prompt = false,
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
      prompt = 'Please assist with the following diagnostic issue in file:',
      selection = select.diagnostics,
    },
    Commit = {
      prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit. And copilot system message text by Japanese.',
      selection = select.gitdiff,
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
vnoremap <silent> <leader>cv :CopilotChatVisual 
vnoremap <silent> <leader>cx :CopilotChatInPlace<CR>
nnoremap <silent> <leader>ce :CopilotChatExplain<CR>
