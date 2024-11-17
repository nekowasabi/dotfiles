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
  agents =
  {
    {
      provider = "copilot",
      name = "copilot-3-5-Sonnet",
      chat = true,
      command = false,
      model = { model = "claude-3.5-sonnet", temperature = 0.8, top_p = 1 },
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      provider = "anthropic",
      name = "anthropic-3-5-Sonnet",
      chat = true,
      command = false,
      model = { model = "claude-3-5-sonnet-20241022", temperature = 0.8, top_p = 1 },
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    { 
        name = "ChatGPT4o", 
        chat = true, 
        command = true, 
        -- string with model name or table with model name and parameters 
        model = { model = "gpt-4o-2024-08-06", temperature = 1.1, top_p =
        1 }, 
        -- system prompt (use this to specify the persona/role of the AI) 
        system_prompt = "レスポンスは、日本語で回答してください\n\n" 
        .. "1つずつ、step by stepで説明してください。\n\n", 

        system_prompt = "You are a general AI assistant.\n\n"
        .. "レスポンスは、日本語で回答してください\n\n" 
        .. "The user provided the additional info about how they would like you to respond:\n\n"
        .. "- If you're unsure don't guess and say you don't know instead.\n"
        .. "- Ask question if you need clarification to provide better answer.\n"
        .. "- Think deeply and carefully from first principles step by step.\n"
        .. "- Zoom out first to see the big picture and then zoom in to details.\n"
        .. "- Use Socratic method to improve your thinking and coding skills.\n"
        .. "- Don't elide any code from your output if the answer requires coding.\n"
        .. "- Take a deep breath; You've got this!\n",
    }, 
    { 
        name = "ChatGPT4oMini", 
        chat = true, 
        command = true, 
        -- string with model name or table with model name and parameters 
        model = { model = "gpt-4o-mini", temperature = 1.1, top_p =
        1 }, 
        -- system prompt (use this to specify the persona/role of the AI) 
        system_prompt = "レスポンスは、日本語で回答してください\n\n" 
        .. "1つずつ、step by stepで説明してください。\n\n", 

        system_prompt = "You are a general AI assistant.\n\n"
        .. "レスポンスは、日本語で回答してください\n\n" 
        .. "The user provided the additional info about how they would like you to respond:\n\n"
        .. "- If you're unsure don't guess and say you don't know instead.\n"
        .. "- Ask question if you need clarification to provide better answer.\n"
        .. "- Thin deeply and carefully from first principles step by step.\n"
        .. "- Zoom out first to see the big picture and then zoom in to details.\n"
        .. "- Use Socratic method to improve your thinking and coding skills.\n"
        .. "- Don't elide any code from your output if the answer requires coding.\n"
        .. "- Take a deep breath; You've got this!\n",
    }
  },
  hooks = {
    RewriteOMini = function(gp, params)
      local template = "Having following from {{filename}}:\n\n"
        .. "```{{filetype}}\n{{selection}}\n```\n\n"
        .. "Please rewrite this according to the contained instructions.\n\n"
        .. ".以下のテキストに以下の処理を行ってください\n\n"
        .. "# Do\n"
        .. "- 誤字脱字の修正\n"
        .. "- 英単語のスペルミスの修正\n"
        .. "- 適切な句読点を追加\n"
        .. "- テキストの意味を損なわないように、slackでのメッセージとして伝わるように変換する\n"
        .. "- 必要に応じて段落分けも行う\n\n"
        .. "# Not to do\n"
        .. "- 行頭に・がある時は削除しないでください\n"
        .. "- 語尾は変更しないでください\n"
        .. "- 「余分な説明は不要です」\n"
        .. "- 「挨拶や前置きは省略してください」\n"
        .. "- 「追加の説明や例示は不要です」\n"
        .. "- テキストを「」囲まないでください\n"
        .. "- 以下のように修正しました。は不要です\n"
        .. "- テキストの修正結果のみを返してください\n"
        .. "- ダブルクオテーションで囲まないでください\n"


      local agent = gp.get_command_agent()
      gp.logger.info("Implementing selection with agent: " .. agent.name)

      -- you can also create a chat with a specific fixed agent like this:
      local agent = gp.get_chat_agent("ChatGPT4oMini")

      gp.Prompt(
        params,
        gp.Target.rewrite,
        agent,
        template,
        nil, -- command will run directly without any prompting for user input
        nil -- no predefined instructions (e.g. speech-to-text from Whisper)
      )
    end
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
  " カーソルのある行を選択
  normal! V

  '<,'>GpRewriteOMini
endfunction
nnoremap <silent> <C-y> :call <SID>RewriteLine()<CR>


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
