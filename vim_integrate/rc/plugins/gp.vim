lua << EOF
require("gp").setup({
agents =
{
  { 
      name = "ChatGPT4", 
      chat = true, 
      command = true, 
      -- string with model name or table with model name and parameters 
      model = { model = "gpt-4o-2024-05-13", temperature = 1.1, top_p = 1 }, 
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

" 選択範囲のテキストをechoするコマンド
function! GpRewriteTidyToMarkdown()
	let prompt =<< trim END
	Your task is to take the text provided and rewrite it into a clear, grammatically correct version while preserving the original meaning as closely as possible. Correct any spelling mistakes, punctuation errors, verb tense issues, word choice problems, and other grammatical mistakes.

	Output should only include the rewritten text, without any quotes or commentary or preamble from you. :
	Reformat the following sentences. Structure it so that notes can be taken effectively. Ensure that key points, ideas, and action items are clearly highlighted. Check for correct grammar and punctuation. Do not change the tone. Use as much of the original text as possible.

	Must!! Do not remove raw voice input!!!!
	Must!! Do not remove raw voice input!!!!
	Must!! Do not remove raw voice input!!!!
	Must!! Do not remove raw voice input!!!!
	Must!! Do not remove raw voice input!!!!

	````
	## 変換前のテキスト
	`ここに変換前のテキストを一切変更することなく表示する`

	## Text after reformatting
	`ここに整理されたテキストをmarkdownで構造的に整理して出力する`
	```
	END

    " 選択範囲のテキストを出力
		echo prompt
    exe "GpRewrite " . join(prompt, "\n")
endfunction

" コマンドを定義（ビジュアルモード用）
command! -range=% GpRewriteTidyToMarkdown call GpRewriteTidyToMarkdown()

" チャット画面呼び出し
nnoremap <silent> ,, :GpChatNew vsplit<CR>
vmap <silent> <CR><CR> :GpChatNew vsplit<CR>
vnoremap <silent> ,, :GpChatPaste vsplit<CR>
vnoremap <silent> <leader>gr :GpRewrite 

" .gitリポジトリのトップに、コンテキストとなるファイルを作成する（GpRewriteとかするとき、文脈として参照される）
nnoremap <silent> <leader>gP :GpContext<CR>
