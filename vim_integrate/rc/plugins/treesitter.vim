let g:_ts_force_sync_parsing = v:true

lua << EOF
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local ok, ts_configs = pcall(require, 'nvim-treesitter.configs')
    if not ok then
      vim.notify('nvim-treesitter not found, skipping configuration', vim.log.levels.WARN)
      return
    end

    ts_configs.setup {
      -- A list of parser names, or "all" (the four listed parsers should always be installed)
      ensure_installed = { "php", "lua", "vim", "javascript", "sql", "yaml", "json", "jsdoc", "html", "gitignore", "gitcommit", "css", "bash"},

      -- Install parsers synchronously ()
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = false,

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
        disable = { "c", "rust", "blade", "markdown"},
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        disable = function(lang, buf)
          local max_filesize = 512 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = true,
      },
    }

    -- Blade parser configuration
    local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
    parser_config.blade = {
      install_info = {
        url = "https://github.com/EmranMR/tree-sitter-blade",
        files = { "src/parser.c" },
        branch = "main",
      },
      filetype = "blade",
    }

    vim.filetype.add({
      pattern = {
        [".*%.blade%.php"] = "blade",
      },
    })
  end,
  once = true,
})
EOF

" Toggle TreeSitter highlight for markdown files
augroup MarkdownTreeSitterToggle
  autocmd!
  autocmd FileType markdown nnoremap <buffer> <Leader>th :TSToggle highlight<CR>
augroup END
