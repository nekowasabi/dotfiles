nnoremap <leader>A :AIChat<CR>
xnoremap <leader>aa :AIChat<CR>
xnoremap <leader>ai :AIChat 
xnoremap <leader>aef :AIEdit 文章の内容を読みやすく表現を書き直し、誤字脱字を訂正してください。ただし、語尾はそのままにしてください。<CR>
xnoremap <leader>aet :AI テキストの内容をデシジョンツリーで分類整理して、最終的な出力結果をPlantUMLのマインドマップ形式で変換してください。AWESOME mindmapの設定は不要です。<CR>

autocmd FileType text,shd nnoremap <silent><CR> zMzv
autocmd FileType text,shd nnoremap <silent><CR><CR> za

let initial_prompt =<< trim END
>>> system
文章の内容を英語に変換したものを日本語に再翻訳してください。
END

let g:vim_ai_complete = {
      \  "engine": "complete",
      \  "options": {
      \    "model": "gpt-3.5-turbo-instruct",
      \    "endpoint_url": "https://api.openai.com/v1/completions",
      \    "max_tokens": 1000,
      \    "temperature": 0.1,
      \    "request_timeout": 20,
      \    "enable_auth": 1,
      \    "selection_boundary": "#####",
      \  },
      \  "ui": {
      \    "paste_mode": 1,
      \  },
      \}

let g:vim_ai_edit = {
\  "engine": "complete",
\  "options": {
\    "model": "gpt-3.5-turbo-instruct",
\    "endpoint_url": "https://api.openai.com/v1/completions",
\    "max_tokens": 1000,
\    "temperature": 0.1,
\    "request_timeout": 20,
\    "enable_auth": 1,
\    "selection_boundary": "#####",
\  },
\  "ui": {
\    "paste_mode": 1,
\  },
\}


let g:vim_ai_chat = {
      \  "options": {
      \    "model": "gpt-4-1106-preview",
      \    "max_tokens": 1000,
      \    "endpoint_url": "https://api.openai.com/v1/chat/completions",
      \    "temperature": 1,
      \    "request_timeout": 20,
      \    "enable_auth": 1,
      \    "selection_boundary": "#####",
      \    "initial_prompt": initial_prompt,
      \  },
      \  "ui": {
      \    "code_syntax_enabled": 1,
      \    "populate_options": 0,
      \    "open_chat_command": "preset_below",
      \    "scratch_buffer_keep_open": 0,
      \    "paste_mode": 1,
      \  },
      \}
