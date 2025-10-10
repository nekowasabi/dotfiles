lua << EOF

require("parrot").setup({
  providers = {
    custom_openrouter = {
      name = "custom_openrouter",
      style = "openai",
      api_key = os.getenv "OPENROUTER_API_KEY",
      endpoint = "https://openrouter.ai/api/v1/chat/completions",
      topic = {
        model = "openai/gpt-oss-120b",
        params = { max_completion_tokens = 128 },
      },
      models ={
        "openai/gpt-oss-120b",
      },
      params = {
        chat = {
          temperature = 1.1,
          top_p = 1,
        },
        command = {
          temperature = 1.1,
          top_p = 1,
          provider = {
            only = { "Cerebras" }
          }
        },
      },
      headers = function(self)
        return {
          ["Content-Type"] = "application/json",
          ["Authorization"] = "Bearer " .. self.api_key,
        }
      end,
    },
    gemini = {
      name = "gemini",
      endpoint = function(self)
      return "https://generativelanguage.googleapis.com/v1beta/models/"
      .. self._model
      .. ":streamGenerateContent?alt=sse"
      end,
      model_endpoint = function(self)
      return { "https://generativelanguage.googleapis.com/v1beta/models?key=" .. self.api_key }
      end,
      api_key = os.getenv "GEMINI_API_KEY",
      params = {
        chat = { temperature = 1.1, topP = 1, topK = 10, maxOutputTokens = 8192 },
        command = { temperature = 0.8, topP = 1, topK = 10, maxOutputTokens = 8192 },
      },
      topic = {
        model = "gemini-2.5-flash-preview",
        params = { maxOutputTokens = 64 },
      },
      headers = function(self)
      return {
        ["Content-Type"] = "application/json",
        ["x-goog-api-key"] = self.api_key,
      }
      end,
      models = {
        "gemini-2.5-flash-preview-05-20",
        "gemini-2.5-pro-preview-05-06",
        "gemini-1.5-pro-latest",
        "gemini-1.5-flash-latest",
        "gemini-2.5-pro-exp-03-25",
        "gemini-2.0-flash-lite",
        "gemini-2.0-flash-thinking-exp",
        "gemma-3-27b-it",
      },
      preprocess_payload = function(payload)
      local contents = {}
      local system_instruction = nil
      for _, message in ipairs(payload.messages) do
        if message.role == "system" then
          system_instruction = { parts = { { text = message.content } } }
        else
          local role = message.role == "assistant" and "model" or "user"
          table.insert(
          contents,
          { role = role, parts = { { text = message.content:gsub("^%s*(.-)%s*$", "%1") } } }
          )
          end
          end
          local gemini_payload = {
            contents = contents,
            generationConfig = {
              temperature = payload.temperature,
              topP = payload.topP or payload.top_p,
              maxOutputTokens = payload.max_tokens or payload.maxOutputTokens,
            },
          }
          if system_instruction then
            gemini_payload.systemInstruction = system_instruction
            end
            return gemini_payload
            end,
            process_stdout = function(response)
            if not response or response == "" then
              return nil
              end
              local success, decoded = pcall(vim.json.decode, response)
              if
                success
                and decoded.candidates
                and decoded.candidates[1]
                and decoded.candidates[1].content
                and decoded.candidates[1].content.parts
                and decoded.candidates[1].content.parts[1]
                then
                return decoded.candidates[1].content.parts[1].text
                end
                return nil
                end,
    },
  },
	-- default system prompts used for the chat sessions and the command routines
	system_prompt = {
		chat = "You are a helpful assistant.",
		command = "Act as general purpose expert superhuman.",
	},

  -- the prefix used for all commands
  cmd_prefix = "Prt",

  -- optional parameters for curl
  curl_params = {},

  -- The directory to store persisted state information like the
  -- current provider and the selected models
  state_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/parrot/persisted",

  -- The directory to store the chats (searched with PrtChatFinder)
  chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/parrot/chats",

  -- Chat user prompt prefix
  chat_user_prefix = "🗨:",

  -- llm prompt prefix
  llm_prefix = "🦜:",

  -- Explicitly confirm deletion of a chat file
  chat_confirm_delete = true,

  -- Option to move the cursor to the end of the file after finished respond
  chat_free_cursor = false,

  -- use prompt buftype for chats (:h prompt-buffer)
  chat_prompt_buf_type = false,

  -- Enables the query spinner animation
  enable_spinner = true,
  -- Type of spinner animation to display while loading
  -- Available options: "dots", "line", "star", "bouncing_bar", "bouncing_ball"
  spinner_type = "star",
  -- Show hints for context added through completion with @file, @buffer or @directory
  show_context_hints = false,

  -- Local chat buffer shortcuts
  chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-c>r" },
  chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-c>d" },
  chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-c>s" },
  chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-c>c" },

	enable_preview_mode = false,
})

EOF
