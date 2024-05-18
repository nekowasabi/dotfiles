lua << EOF
vim.keymap.set({"x", "o"}, "m", function()
  require("treemonkey").select({ ignore_injections = false })
end)
vim.keymap.set({"n"}, "M", function()
  require("treemonkey").select({ ignore_injections = false })
end)

EOF
