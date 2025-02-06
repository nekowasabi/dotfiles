lua << EOF
local copilot_chat = require("CopilotChat")

-- config.mappings.show_user_selection is deprecated, use config.mappings.show_context instead.
-- Feature will be removed in CopilotChat.nvim 3.0.X
-- config.mappings.show_system_prompt is deprecated, use config.mappings.show_info instead.
-- Feature will be removed in CopilotChat.nvim 3.0.X

copilot_chat.setup({
  utils = {
    get_default_branch = function()
      local handle = io.popen('git symbolic-ref refs/remotes/origin/HEAD 2> /dev/null')
      if not handle then
        return nil
      end
      local result = handle:read('*a')
      handle:close()

      local branch = result and result:match('refs/remotes/origin/(%S+)') or 'main'
      return branch
    end,

    parse_diff = function(diff_output)
      local diff_lines = {}
      local current_old_line, current_new_line

      for line in diff_output:gmatch('[^\r\n]+') do
        local old_line_start, old_line_count, new_line_start, new_line_count =
          line:match('^@@ %-(%d+),?(%d*) %+(%d+),?(%d*) @@')

        if old_line_start and new_line_start then
          table.insert(diff_lines, line)
          current_old_line = tonumber(old_line_start)
          current_new_line = tonumber(new_line_start)
        elseif line:sub(1, 1) == '-' and current_old_line then
          table.insert(diff_lines, string.format('%d: %s', current_old_line, line))
          current_old_line = current_old_line + 1
        elseif line:sub(1, 1) == '+' and current_new_line then
          table.insert(diff_lines, string.format('%d: %s', current_new_line, line))
          current_new_line = current_new_line + 1
        else
          if current_old_line and current_new_line then
            table.insert(diff_lines, string.format('   %s', line))
            current_old_line = current_old_line + 1
            current_new_line = current_new_line + 1
          end
        end
      end

      return table.concat(diff_lines, '\n')
    end,

    gitdiff = function(select, source)
      local select_buffer = select.buffer(source)
      if not select_buffer then
        return nil
      end

      local bufname = vim.api.nvim_buf_get_name(source.bufnr)
      local file_path = bufname:gsub('^%w+://', '')
      local dir = vim.fn.fnamemodify(file_path, ':h')
      if not dir or dir == '' then
        return nil
      end
      dir = dir:gsub('.git$', '')

      local default_branch = require("CopilotChat").utils.get_default_branch()
      if not default_branch or default_branch == '' then
        return nil
      end

      local cmd_staged = string.format('git -C %s diff --no-color --no-ext-diff --staged', dir)
      local handle_staged = io.popen(cmd_staged)
      if not handle_staged then
        return nil
      end

      local result_staged = handle_staged:read('*a')
      handle_staged:close()

      if result_staged and result_staged ~= '' then
        select_buffer.filetype = 'diff'
        select_buffer.lines = require("CopilotChat").utils.parse_diff(result_staged)
        return select_buffer
      end

      local cmd_default = string.format('git -C %s diff --no-color --no-ext-diff %s...HEAD', dir, default_branch)
      local handle_default = io.popen(cmd_default)
      if not handle_default then
        return nil
      end

      local result_default = handle_default:read('*a')
      handle_default:close()

      if not result_default or result_default == '' then
        return nil
      end

      select_buffer.filetype = 'diff'
      select_buffer.lines = require("CopilotChat").utils.parse_diff(result_default)
      return select_buffer
    end,
  },
  debug = false,
  show_info = false,
	model = "o3-mini-paygo",
	-- model = "claude-3.5-sonnet",
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
      normal ='<C-c>c',
      insert = '<C-c>c'
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
    show_info = {
      normal = 'gp'
    },
    show_context = {
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
			prompt = 'このコードをレビューしてください。',
			system_prompt = [[
与えられたコードのdiffをレビューし、特に読みやすさと保守性に焦点を当ててください。
以下に関連する問題を特定してください：
- 名前付け規則が不明確、誤解を招く、または使用されている言語の規則に従っていない場合。
- 不要なコメントの有無、または必要なコメントが不足している場合。
- 複雑すぎる表現があり、簡素化が望ましい場合。
- ネストのレベルが高く、コードが追いづらい場合。
- 変数や関数に対して名前が過剰に長い場合。
- 命名、フォーマット、または全体的なコーディングスタイルに一貫性が欠けている場合。
- 抽象化や最適化によって効率的に処理できる繰り返しのコードパターンがある場合。

フィードバックは簡潔に行い、各特定された問題について次の要素を直接示してください：
- 問題が見つかった具体的な行番号
- 問題の明確な説明
- 改善または修正方法に関する具体的な提案

フィードバックの形式は次のようにしてください：
line=<行番号>: <問題の説明>

問題が複数行にわたる場合は、次の形式を使用してください：
line=<開始行>-<終了行>: <問題の説明>

同じ行に複数の問題がある場合は、それぞれの問題を同じフィードバック内でセミコロンで区切って記載してください。
指摘が複数にわたる場合は、一行にまとめるように文字列を整形してください。

フィードバック例：
line=3: 変数名「x」が不明瞭です。変数宣言の横にあるコメントは不要です。
line=8: 式が複雑すぎます。式をより簡単な要素に分解してください。
line=10: この部分でのキャメルケースの使用はLuaの慣例に反します。スネークケースを使用してください。
line=11-15: ネストが過剰で、コードの追跡が困難です。\nネストレベルを減らすためにリファクタリングを検討してください。

コードスニペットに読みやすさの問題がない場合、その旨を簡潔に記し、コードが明確で十分に書かれていることを確認してください。

diffの出力には、変更された行やその位置を示す情報が含まれています。この情報を用いて、**変更後のコードの正確な行番号**を特定し、その行番号に基づいて指摘を行ってください。

重要度に応じて以下のキーワードを含めてください：
- 重大な問題: "error:" または "critical:"
- 警告: "warning:"
- スタイル的な提案: "style:"
- その他の提案: "suggestion:"
]],
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
