lua << EOF
require("gp").setup({
	providers = {
		openai = {
			endpoint = "https://api.openai.com/v1/chat/completions",
			secret = os.getenv("OPENAI_API_KEY"),
		},
		anthropic = {
			endpoint = "https://api.anthropic.com/v1/messages",
			secret = os.getenv("ANTHROPIC_API_KEY"),
		},
		copilot = {
			endpoint = "https://api.githubcopilot.com/chat/completions",
			secret = {
				"bash",
				"-c",
				"cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'",
			},
		},
	},
 	agents = { 
 		{ 
 			name = "ExampleDisabledAgent", 
 			disable = true, 
 		}, 
 		{ 
 			provider = "copilot", 
 			name = "ChatCopilot", 
 			chat = true, 
 			command = false, 
 			-- string with model name or table with model name and parameters 
 			model = { model = "claude-sonnet-4", temperature = 1.1, top_p = 1 }, 
 			-- system prompt (use this to specify the persona/role of the AI) 
 			system_prompt = require("gp.defaults").chat_system_prompt, 
 		}, 
  },

  chat_assistant_prefix = { "🤖:", "[{{agent}}]" }, 
  chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/chats",
  chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-c>r" }, 
  chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-c>d" }, 
  chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-c>s" }, 
  chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-c>c" }
})
EOF

function! s:RewriteLine() abort
  if mode() ==# 'n'
    " normal modeの場合は現在行を選択
    normal! V
    '<,'>GpRewriteOMini
  else
    " visual modeの場合は選択範囲をそのまま使用
    GpRewriteOMini
  endif
endfunction

" normal modeとvisual modeで同じキーマッピングを使用
nnoremap <silent> <C-c><C-y> :call <SID>RewriteLine()<CR>
vnoremap <silent> <C-c><C-y> :call <SID>RewriteLine()<CR>

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
