lua << EOF
local copilot_chat = require("CopilotChat")
copilot_chat.setup({
  debug = true,
  show_help = "yes",
  prompts = {
    Explain = "Explain how it works by Japanese language.",
    Review = "Review the following code and provide concise suggestions.",
    Tests = "Briefly explain how the selected code works, then generate unit tests.",
    Refactor = "Refactor the code to improve clarity and readability.",
		Aaa = "hello",
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

