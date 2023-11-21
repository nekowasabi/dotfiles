function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

lua << EOF
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'everforest',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
    },
  sections = {
    lualine_a = {'mode'},
    lualine_b = { {'filetype', icon_only = true}, {'filename', path = 1} },
    lualine_c = {},
    lualine_x = {'encoding', 'fileformat'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_a = {'branch', 'diff'},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {
      function()
        -- return ''
        return vim.b.coc_nav[1].label .. ' ' .. vim.b.coc_nav[1].name .. ' ' .. vim.b.coc_nav[2].label .. ' ' .. vim.b.coc_nav[2].name
      end 
    },
    lualine_y = { "diagnostics" },
    lualine_z = { "require'lsp-status'.status()", "overseer" }
  },
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
EOF
