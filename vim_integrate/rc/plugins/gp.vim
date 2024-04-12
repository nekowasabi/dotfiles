lua << EOF
require("gp").setup({
agents =
{
  { 
      name = "ChatGPT4", 
      chat = true, 
      command = true, 
      -- string with model name or table with model name and parameters 
      model = { model = "gpt-4-turbo-2024-04-09gpt-4-0125-preview", temperature = 1.1, top_p = 1 }, 
      -- system prompt (use this to specify the persona/role of the AI) 
      system_prompt = "レスポンスは、日本語で回答してください\n\n" 
			.. "1つずつ、step by stepで説明してください。\n\n", 
  }, 
	{
			name = "ChatGPT3-5",
	},
	{
			name = "CodeGPT3-5",
	},

},
chat_assistant_prefix = { "🤖:", "[{{agent}}]" }, 
chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/chats",
chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-c>r" }, 
chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-c>d" }, 
chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-c>s" }, 
chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-c>c" }, 
})

EOF

" チャット画面呼び出し
nnoremap <silent> <leader>gv :GpChatNew vsplit<CR>
vmap <silent> <CR><CR> :GpChatNew vsplit<CR>
vnoremap <silent> <leader>gp :GpChatPaste vsplit<CR>
vnoremap <silent> <leader>gr :GpRewrite 

" .gitリポジトリのトップに、コンテキストとなるファイルを作成する（GpRewriteとかするてき、文脈として参照される）
nnoremap <silent> <leader>gP :GpContext<CR>
