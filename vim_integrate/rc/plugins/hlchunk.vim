lua << EOF
require("hlchunk").setup({
chunk = {
  enable = true,
  use_treesitter = true,
  notify = true,
  chars = {
    horizontal_line = "━",
    vertical_line = "┃",
    left_top = "┏",
    left_bottom = "┗",
    right_arrow = "▶",
  },
  style = "#edea82",
  support_filetypes = {
    "*.vim",
    "*.php",
    "*.md",
    "*.ts",
    "*.js",
    "*.yml",
  },
  exclude_filetypes = {
    "changelogmemo",
    "*.txt",
  },
},
indent = {
  chars = {
    "┃",
  },
  style = {
    "#FF0000",
    "#FF7F00",
    "#FFFF00",
    "#00FF00",
    "#00FFFF",
    "#0000FF",
    "#8B00FF",
  },
  exclude_filetypes = {
    aerial = true,
    changelog = true,
    text = true,
  },

},
line_num = {
  style = "#806d9c",
  exclude_filetypes = {
    "changelogmemo",
    "*.txt",
  },
},
blank = {
  enable = false,
  exclude_filetypes = {
    aerial = true,
    changelog = true,
    text = true,
  },

}
})

EOF
