autocmd FileType sql,vim,php,typescript lua require('cmp').setup.buffer {
\   enabled = false
\ }


lua << EOF
local cmp = require'cmp'

cmp.setup({
filetypes = { "markdown" },
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
  end,
},
mapping = cmp.mapping.preset.insert({
['<C-u>'] = cmp.mapping.scroll_docs(-4),
['<C-d>'] = cmp.mapping.scroll_docs(4),
["<C-p>"] = cmp.mapping.select_prev_item(),
["<C-n>"] = cmp.mapping.select_next_item(),
['<C-e>'] = cmp.mapping.abort(),
["<CR>"] = cmp.mapping.confirm { select = true },
}),
window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
sources = {
  { name = 'buffer' },
  { name = 'path' },
},
method = "getCompletionsCycling",
matching = {
	disallow_fuzzy_matching = false,
	disallow_partial_fuzzy_matching = false,
  disallow_partial_matching = true,
	},
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources(
  {
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  },
  {
      { name = 'buffer' },
  })
})
cmp.setup.filetype('markdown', {
  sources = cmp.config.sources({
  { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer',
      option = {
        get_bufnrs = function()
        return vim.api.nvim_list_bufs()
        end
      }

      },
    })
  })

-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--   { name = 'path' }
--   }, {
--     { name = 'cmdline' }
--   })
--   })

-- cmp git
local format = require("cmp_git.format")
local sort = require("cmp_git.sort")

require("cmp_git").setup({
-- defaults
filetypes = { "gitcommit", "octo" },
remotes = { "upstream", "origin" }, -- in order of most to least prioritized
enableRemoteUrlRewrites = false, -- enable git url rewrites, see https://git-scm.com/docs/git-config#Documentation/git-config.txt-urlltbasegtinsteadOf
git = {
  commits = {
    limit = 100,
    sort_by = sort.git.commits,
    format = format.git.commits,
  },
},
github = {
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
