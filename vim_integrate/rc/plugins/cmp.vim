" cmp.vim - nvim-cmp specific settings
" Note: Completion switching logic is in autoload/completion.vim

lua << EOF

local cmp = require'cmp'

local function get_buffer_source_bufnrs()
  local buf = vim.api.nvim_get_current_buf()
  local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
  if byte_size > 1024 * 1024 then
  -- 現在のバッファのみを返す
    return { buf }
  end
  -- 1MB を超える場合は全バッファを返す
    return vim.api.nvim_list_bufs()
end

cmp.setup({
  filetypes = { "markdown", "changelog", "text" },
  enabled = function()
    -- vim.b.cmp_enabled is set by completion#apply()
    -- Default to true if not set (for unknown filetypes)
    return vim.b.cmp_enabled ~= false
  end,
  performance = {
    debounce = 100,
    throttle = 100,
    fetching_timeout = 1,
  },
  snippet = {
    expand = function(_)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ['<C-e>'] = cmp.mapping.abort(),
    -- ['<C-s>'] = function(fallback)
    --       if cmp.visible() then
    --         local confirm_opts = {
    --           select = true,
    --           behavior = cmp.ConfirmBehavior.Insert,
    --         }
    --         cmp.confirm(confirm_opts, function()
    --           local key = vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
    --           vim.api.nvim_feedkeys(key, 't', true)
    --         end)
    --       else
    --         fallback()
    --       end
    --     end,
    -- insert, commandモードでの補完を有効にする
    -- cmp.mappingと{'i', 'c'}を指定することで、insert, commandモードでの補完を有効にする
    ["<CR>"] = cmp.mapping({
      i = function(fallback)
        if cmp.visible() then
          cmp.confirm({ select = true })
        else
          fallback()
        end
      end,
      c = cmp.mapping.confirm({ select = true }),
    }),
  }),
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  view = {
    entries = {
      follow_cursor = true,
    }
  },
  method = "getCompletionsCycling",
  matching = {
    disallow_fuzzy_matching = false,
    disallow_partial_fuzzy_matching = false,
    disallow_partial_matching = false,
  },
   sources = {
     { name = 'path' },
     { name = 'neosnippet' },
     { name = 'buffer', 
       keyword_length = 4,
       entry_filter = function(entry, ctx)
         return string.len(entry.completion_item.label) < 30
       end
     },
     { name = "neosnippet", keyword_length = 3 },
     { name = "git" },
   },
   formatting = {
     fields = {'menu', 'abbr', 'kind'},
     format = function(entry, item)
         local menu_icon ={
             buffer = '🦋',
             path = '📂',
             cmdline = '🔍',
             cmd_yanky = '📋',
             calc = '🔢',
             neosnippet = '✂️',
             nvim_lsp = '🔗',
         }
         local kind_icon = {
           Text = '  ',
           Method = '  ',
           Function = '  ',
           Constructor = '  ',
           Field = '  ',
           Variable = '  ',
           Class = '  ',
           Interface = '  ',
           Module = '  ',
           Property = '  ',
           Unit = '  ',
           Value = '  ',
           Enum = '  ',
           Keyword = '  ',
           Snippet = '  ',
           Color = '  ',
           File = '  ',
           Reference = '  ',
           Folder = '  ',
           EnumMember = '  ',
           Constant = '  ',
           Struct = '  ',
           Event = '  ',
           Operator = '  ',
           TypeParameter = '  ',
         }
         item.menu = menu_icon[entry.source.name]
         item.kind = kind_icon[item.kind]
         return item
     end,
   },
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources(
  {
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  },
  {
      { name = 'buffer',
        entry_filter = function(entry, ctx)
          return string.len(entry.completion_item.label) < 30
        end
      },
  })
})

cmp.setup.filetype('markdown', {
  snippet = {
    expand = function(_)
    end,
  },
  sources = cmp.config.sources(
  {
      { name = 'calc' },
      { name = 'emoji' },
      { name = 'neosnippet', keyword_length = 3 },
      {
					name = 'buffer',
					keyword_length = 2,
          entry_filter = function(entry, ctx)
            return string.len(entry.completion_item.label) < 30
          end,
          option = {
            get_bufnrs = get_buffer_source_bufnrs,
            indexing_interval = 1000,
          },
      },
  }),

})

-- cmp.setup.filetype({'vim', 'typescript', 'python', 'lua'}, {
--   sources = cmp.config.sources({
--     { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
--   },
--   {
--     { name = "nvim_lsp", keyword_length = 3 },
--     { name = 'path' },
--     { name = 'buffer',
--       option = {
--         get_bufnrs = function()
--         return vim.api.nvim_list_bufs()
--         end
--       },
--     },
--     { name = 'neosnippet', keyword_length = 3 },
--     { name = 'context_nvim' },
--   }),
--   window = {
--     completion = cmp.config.window.bordered(),
--     -- documentation = cmp.config.window.bordered(),
--   },
--   view = {
--     entries = {
--       follow_cursor = true,
--     }
--   },
-- })
-- 動的な有効化判定（上記のautocmdで処理済みのためコメントアウト）
-- cmp.setup.filetype({'vim', 'typescript', 'python', 'lua', 'go'}, {
--   enabled = false
-- })

cmp.setup.filetype('copilot-chat', {
  sources = cmp.config.sources({
  { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  },
  {
    { name = 'buffer',
      entry_filter = function(entry, ctx)
        return string.len(entry.completion_item.label) >= 30
      end,
      option = {
        get_bufnrs = function()
        return vim.api.nvim_list_bufs()
        end
      },
    },
    { name = 'neosnippet', keyword_length = 3 },
    { name = 'context_nvim' }
  })
})

cmp.setup.filetype('changelog', {
  snippet = {
    expand = function(_)
    end,
  },
  sources = cmp.config.sources(
  {
      { name = 'calc' },
      { name = 'emoji' },
      { name = 'neosnippet', keyword_length = 3 },
      {
					name = 'buffer',
					keyword_length = 2,
          entry_filter = function(entry, ctx)
            return string.len(entry.completion_item.label) < 30
          end,
          option = {
            get_bufnrs = get_buffer_source_bufnrs,
            indexing_interval = 1000,
          },
      },
  }),
})

cmp.setup.filetype('text', {
  sources = cmp.config.sources(
  {
      { name = 'calc' },
      { name = 'emoji' },
      { name = 'cmp_yanky', 
        keyword_length = 4,
        option = {
          onlyCurrentFiletype = false,
          minLength = 3,
        }
      },
      {
					name = 'buffer',
					keyword_length = 4,
          entry_filter = function(entry, ctx)
            return string.len(entry.completion_item.label) < 30
          end,
          option = {
            get_bufnrs = function()
            return vim.api.nvim_list_bufs()
            end
          },
      },
  })
})



-- Command line setup for ':' and '/' commands
-- For ':' commands (Ex commands)
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline({
    ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 'c'}),
    ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 'c'}),
    ['<C-y>'] = cmp.mapping(cmp.mapping.confirm({ select = true }), {'i', 'c'}),
    ['<C-e>'] = cmp.mapping(cmp.mapping.abort(), {'i', 'c'}),
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 'c'}),
    ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 'c'}),
    ['<CR>'] = cmp.mapping(cmp.mapping.confirm({ select = true }), {'i', 'c'}),
  }),
  enabled = function()
    -- コマンドラインに ! が含まれる場合は補完を無効化
    local cmdline = vim.fn.getcmdline()
    if string.match(cmdline, '!') then
      -- 補完ウィンドウが開いていれば閉じる
      if cmp.visible() then
        cmp.close()
      end
      return false
    end
    return true
  end,
  sources = cmp.config.sources({
    { name = 'path' },
    { 
				name = 'cmdline',
				keyword_length = 2,
				option = {
					ignore_cmds = { 'Man', '!', 'w', 'wa', 'wqa', 'wq', 'qall', 'bd', 'bd!' }
				}
		},
  }),
  window = {
    completion = cmp.config.window.bordered(),
  },
})

-- For '/' commands (search commands)
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline({
    ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 'c'}),
    ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 'c'}),
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 'c'}),
    ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 'c'}),
    ['<CR>'] = cmp.mapping(cmp.mapping.confirm({ select = true }), {'i', 'c'}),
  }),
  sources = cmp.config.sources({
    { name = 'buffer',
      entry_filter = function(entry, ctx)
        return string.len(entry.completion_item.label) >= 30
      end
    }
  }),
  window = {
    completion = cmp.config.window.bordered(),
  },
})

-- cmp git
local format = require("cmp_git.format")
local sort = require("cmp_git.sort")

require("cmp_git").setup({
    -- defaults
    filetypes = { "gitcommit", "octo", "NeogitCommitMessage" },
    remotes = { "upstream", "origin" }, -- in order of most to least prioritized
    enableRemoteUrlRewrites = false, -- enable git url rewrites, see https://git-scm.com/docs/git-config#Documentation/git-config.txt-urlltbasegtinsteadOf
    git = {
        commits = {
            limit = 100,
            sort_by = sort.git.commits,
            format = format.git.commits,
            sha_length = 7,
        },
    },
    github = {
        hosts = {},  -- list of private instances of github
        issues = {
            fields = { "title", "number", "body", "updatedAt", "state" },
            filter = "all", -- assigned, created, mentioned, subscribed, all, repos
            limit = 100,
            state = "open", -- open, closed, all
            sort_by = sort.github.issues,
            format = format.github.issues,
        },
        mentions = {
            limit = 100,
            sort_by = sort.github.mentions,
            format = format.github.mentions,
        },
        pull_requests = {
            fields = { "title", "number", "body", "updatedAt", "state" },
            limit = 100,
            state = "open", -- open, closed, merged, all
            sort_by = sort.github.pull_requests,
            format = format.github.pull_requests,
        },
    },
    gitlab = {
        hosts = {},  -- list of private instances of gitlab
        issues = {
            limit = 100,
            state = "opened", -- opened, closed, all
            sort_by = sort.gitlab.issues,
            format = format.gitlab.issues,
        },
        mentions = {
            limit = 100,
            sort_by = sort.gitlab.mentions,
            format = format.gitlab.mentions,
        },
        merge_requests = {
            limit = 100,
            state = "opened", -- opened, closed, locked, merged
            sort_by = sort.gitlab.merge_requests,
            format = format.gitlab.merge_requests,
        },
    },
    trigger_actions = {
        {
            debug_name = "git_commits",
            trigger_character = ":",
            action = function(sources, trigger_char, callback, params, git_info)
                return sources.git:get_commits(callback, params, trigger_char)
            end,
        },
        {
            debug_name = "github_issues_and_pr",
            trigger_character = "#",
            action = function(sources, trigger_char, callback, params, git_info)
                return sources.github:get_issues_and_prs(callback, git_info, trigger_char)
            end,
        },
        {
            debug_name = "github_mentions",
            trigger_character = "@",
            action = function(sources, trigger_char, callback, params, git_info)
                return sources.github:get_mentions(callback, git_info, trigger_char)
            end,
        },
    },
  }
)

EOF
