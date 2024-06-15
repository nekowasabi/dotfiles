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
- 英語の記事は日本語に翻訳する
- 誤字脱字を修正する
- 要約はmarkdown形式とする
- 最初の項目に、タイトルは以下のフォーマットとする
  - `* {{記事のタイトル}}:`
    - ``で強調されたテンプレートのフォーマットに従う
- 次の項目に、## Raw input という項目だけを追加し、入力されたテキストをそのままコピーしてください
- 次の項目に、## Structure（構造） という項目を追加し、人間が書き込むスペースのため、空欄にしてください
- 次の項目に、## Process（再現性）という項目を追加し、人間が書き込むスペースのため、空欄にしてください
- 次の項目に、## summary（内容を2～3行で要約する） という項目を追加し、人間が書き込むスペースのため、空欄にしてください
- キャッチフレーズまで作成したら、処理を終了してください。

	END

    " 選択範囲のテキストを出力
		echo prompt
    exe "GpRewrite " . join(prompt, "\n")
endfunction

" コマンドを定義（ビジュアルモード用）
command! -range=% GpRewriteTidyToMarkdown call GpRewriteTidyToMarkdown()

" チャット画面呼び出し
nnoremap <silent> ,, :GpChatNew vsplit<CR>
nnoremap <silent> <M-g> :GpChatNew vsplit<CR>
nnoremap <silent> <D-g> :GpChatNew vsplit<CR>
vmap <silent> <CR><CR> :GpChatNew vsplit<CR>
vnoremap <silent> ,, :GpChatPaste vsplit<CR>
vnoremap <silent> <leader>gr :GpRewrite 

" .gitリポジトリのトップに、コンテキストとなるファイルを作成する（GpRewriteとかするとき、文脈として参照される）
nnoremap <silent> <leader>gP :GpContext<CR>
