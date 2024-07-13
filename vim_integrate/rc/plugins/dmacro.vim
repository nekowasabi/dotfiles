lua << EOF
-- require('dmacro').setup({
--     dmacro_key = '<C-u>' --  you need to set the dmacro_key
-- })

vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        require('dmacro').setup()
    end,
    once = true
})
vim.keymap.set({ "i", "n" }, '<C-u>', function() require('dmacro').play_macro() end)
EOF


