lua << EOF
local lspkind = require('lspkind')
lspkind.init({
preset = 'codicons',
symbol_map = {
  Text          = ' ',
  Method        = ' ',
  Function      = ' ',
  Constructor   = ' ',
  Field         = ' ',
  Variable      = ' ',
  Class         = ' ',
  Interface     = ' ',
  Module        = ' ',
  Property      = ' ',
  Unit          = ' ',
  Value         = ' ',
  Enum          = ' ',
  Keyword       = ' ',
  Snippet       = ' ',
  Color         = ' ',
  File          = ' ',
  Reference     = ' ',
  Folder        = ' ',
  EnumMember    = ' ',
  Constant      = ' ',
  Struct        = ' ',
  Event         = ' ',
  Operator      = ' ',
  TypeParameter = ' ',
  Copilot       = ' ',
},
})

local cmp = require'cmp'

cmp.setup({
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
  vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
  end,
},
mapping = cmp.mapping.preset.insert({
['<C-u>']     = cmp.mapping.scroll_docs(-4),
['<C-d>']     = cmp.mapping.scroll_docs(4),
["<C-p>"] = cmp.mapping.select_prev_item(),
["<C-n>"] = cmp.mapping.select_next_item(),
['<C-l>'] = cmp.mapping.complete(),
['<C-e>'] = cmp.mapping.abort(),
["<CR>"] = cmp.mapping.confirm { select = true },
}),
window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
sources = {
  { name = 'buffer' },
  { name = 'nvim_lsp' },
  { name = 'cmp_tabnine' },
  { name = "git" },
  { name = 'vsnip' },
  { name = 'path' },
  { name = 'nvim_lsp_signature_help' },
  { name = 'treesitter' },
  { name = 'nvim_lsp_document_symbol' },
},
method = "getCompletionsCycling",
formatting = {
  format = lspkind.cmp_format({
  fields = { 'abbr', 'kind', 'menu' },
  with_text = false,
  -- mode = "symbol",
  menu = ({
  buffer = "[Buffer]",
  nvim_lsp = "[LSP]",
  cmp_tabnine = "[TabNine]",
  git = "[Git]",
  vsnip = "[Vsnip]",
  path = "[Path]",
  treesitter = "[TSitter]",
  })
  }),
},
})

-- `:` cmdline setup.
local incsearch_settings = {
  mapping = cmp.mapping.preset.cmdline({
    ['<C-n>'] = vim.NIL,
    ['<C-p>'] = vim.NIL,
    ['<C-e>'] = vim.NIL,
  }),
  sources = {
    { name = 'buffer' },
  },
  formatting = {
    fields = { 'abbr' },
    format = lspkind.cmp_format({ with_text = false })
  },
  incseach_redraw_keys = '<C-r><BS>',
}

cmp.setup.cmdline('/', incsearch_settings)
cmp.setup.cmdline('?', incsearch_settings)
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline({
    ['<C-n>'] = vim.NIL,
    ['<C-p>'] = vim.NIL,
    ['<C-e>'] = vim.NIL,
  }),
  sources = cmp.config.sources({
    { name = 'cmdline' },
    {
      name = 'fuzzy_path',
      trigger_characters = { ' ', '.', '/', '~' },
      options = {
        fd_cmd = {
          'fd',
          '--hidden',
          '--max-depth',
          '20',
          '--full-path',
          '--exclude',
          '.git',
        },
      },
    },
  }),
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, vim_item)
      if vim.tbl_contains({ 'fuzzy_path' }, entry.source.name) then
        local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
        if icon then
          vim_item.kind = icon
          vim_item.kind_hl_group = hl_group
        else
          vim_item.kind = ' '
        end
      elseif vim.tbl_contains({ 'cmdline' }, entry.source.name) then
        vim_item.kind = ' '
        vim_item.dup = true
      end

      return lspkind.cmp_format()(entry, vim_item)
    end
  },
})


-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
  { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
  })
cmp.setup.filetype('markdown', {
  sources = cmp.config.sources({
  { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
  })


-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
  })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
  { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
  })

-- cmp tabnine
local tabnine = require('cmp_tabnine.config')

tabnine:setup({
max_lines = 1000,
max_num_results = 20,
sort = true,
run_on_every_keystroke = true,
snippet_placeholder = '..',
ignored_file_types = {
  -- default is not to ignore
  -- uncomment to ignore in lua:
  -- lua = true
},
show_prediction_strength = false
})

local compare = require('cmp.config.compare')
cmp.setup({
sorting = {
  priority_weight = 2,
  comparators = {
    require('cmp_tabnine.compare'),
    compare.offset,
    compare.exact,
    compare.score,
    compare.recently_used,
    compare.kind,
    compare.sort_text,
    compare.length,
    compare.order,
  },
},
})

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

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['intelephense'].setup {
  capabilities = capabilities,
  settings = {
    intelephense = {
      files = {
        associations = {"*.php", "*.module", "*.inc"},
        maxSize = 20000000000,
      },
      completion = {
        triggerParameterHints = true,
        insertUseDeclaration = true,
        fullyQualifyGlobalConstantsAndFunctions = true,
      },
    },
  }
}
require('lspconfig')['vimls'].setup {
  capabilities = capabilities
}
require('lspconfig')['sumneko_lua'].setup {
  capabilities = capabilities
}
require('lspconfig')['tsserver'].setup {
  capabilities = capabilities,
  }
EOF
