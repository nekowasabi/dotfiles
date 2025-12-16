" treesitter.vim - nvim-treesitter configuration (new API)
let g:_ts_force_sync_parsing = v:true

lua << EOF
-- Filetypes to enable treesitter features
local ts_filetypes = { 'vim', 'lua', 'php', 'javascript', 'sql', 'yaml', 'json', 'html', 'css', 'bash', 'gitcommit' }
-- Filetypes to disable treesitter highlight
local ts_disable_highlight = { 'c', 'rust', 'blade', 'markdown' }
-- Max filesize for treesitter highlight (512KB)
local max_filesize = 512 * 1024

-- Helper: check if value is in table
local function contains(tbl, val)
  for _, v in ipairs(tbl) do
    if v == val then return true end
  end
  return false
end

-- Helper: check if file is too large
local function is_large_file(buf)
  local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
  return ok and stats and stats.size > max_filesize
end

-- Setup nvim-treesitter (new API)
local ok, ts = pcall(require, 'nvim-treesitter')
if ok then
  ts.setup {
    install_dir = vim.fn.stdpath('data') .. '/site'
  }
end

-- Blade parser configuration (for User TSUpdate event)
vim.api.nvim_create_autocmd('User', {
  pattern = 'TSUpdate',
  callback = function()
    local parsers_ok, parsers = pcall(require, 'nvim-treesitter.parsers')
    if parsers_ok then
      parsers.blade = {
        install_info = {
          url = 'https://github.com/EmranMR/tree-sitter-blade',
          files = { 'src/parser.c' },
          branch = 'main',
        },
      }
    end
  end,
})

-- Register blade filetype
vim.filetype.add({
  pattern = {
    ['.*%.blade%.php'] = 'blade',
  },
})

-- Enable treesitter highlight for supported filetypes
vim.api.nvim_create_autocmd('FileType', {
  pattern = ts_filetypes,
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    -- Skip if filetype is in disable list
    if contains(ts_disable_highlight, ft) then
      return
    end
    -- Skip if file is too large
    if is_large_file(args.buf) then
      return
    end
    -- Start treesitter highlight
    pcall(vim.treesitter.start, args.buf)
  end,
})

-- Enable treesitter indentation for supported filetypes
vim.api.nvim_create_autocmd('FileType', {
  pattern = ts_filetypes,
  callback = function(args)
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
EOF

" Toggle TreeSitter highlight for markdown files
augroup MarkdownTreeSitterToggle
  autocmd!
  autocmd FileType markdown nnoremap <buffer> <Leader>th <Cmd>lua if vim.b.ts_highlight then vim.treesitter.stop() vim.b.ts_highlight = false else vim.treesitter.start() vim.b.ts_highlight = true end<CR>
augroup END
