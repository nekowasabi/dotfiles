lua << EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the four listed parsers should always be installed)
  ensure_installed = { "php", "lua", "vim", "javascript", "sql", "yaml", "markdown", "json", "jsdoc", "html", "gitignore", "gitcommit", "css", "bash" },

  -- Install parsers synchronously ()
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = {},

  indent = {
    enable = true,
  },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
    local max_filesize = 100 * 1024 -- 100 KB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    if ok and stats and stats.size > max_filesize then
      return true
      end
      end,

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      include_surrounding_whitespace = true,
      keymaps = {
        ['am'] = '@function.outer',
        ['im'] = '@function.inner',
        ['ak'] = '@class.outer',
        ['ik'] = '@class.inner',
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['ab'] = '@block.outer',
        ['ib'] = '@block.inner',
        ['as'] = '@statement.outer',
        ['is'] = '@statement.inner',
        ['ax'] = '@attribute.outer',
        ['ix'] = '@attribute.inner',
        ['i/'] = '@comment.inner',
        ['a/'] = '@comment.outer',
        ['i#'] = '@comment.inner',
        ['a#'] = '@comment.outer',
        ['i*'] = '@comment.inner',
        ['a*'] = '@comment.outer',
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        [']m'] = '@function.outer',
        [']k'] = '@class.outer',
        [']a'] = '@parameter.outer',
        [']b'] = '@block.outer',
        [']s'] = '@statement.outer',
        [']x'] = '@attribute.outer',
        [']*'] = '@comment.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']K'] = '@class.outer',
        [']A'] = '@parameter.outer',
        [']B'] = '@block.outer',
        [']S'] = '@statement.outer',
        [']X'] = '@attribute.outer',
        [']?'] = '@comment.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[k'] = '@class.outer',
        ['[a'] = '@parameter.outer',
        ['[b'] = '@block.outer',
        ['[s'] = '@statement.outer',
        ['[x'] = '@attribute.outer',
        ['[*'] = '@comment.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[K'] = '@class.outer',
        ['[A'] = '@parameter.outer',
        ['[B'] = '@block.outer',
        ['[S'] = '@statement.outer',
        ['[X'] = '@attribute.outer',
        ['[?'] = '@comment.outer',
      },
    },
  },
}
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.blade = {
  install_info = {
    url = "https://github.com/EmranMR/tree-sitter-blade",
    files = {"src/parser.c"},
    branch = "main",
  },
  filetype = "blade"
}
EOF

" Set the *.blade.php file to be filetype of blade 
augroup BladeFiltypeRelated
  " au BufNewFile,BufRead *.blade.php set ft=blade
  au BufNewFile,BufRead *.blade.php set ft=blade tabstop=2 softtabstop=2 shiftwidth=2 expandtab autoindent
augroup END
