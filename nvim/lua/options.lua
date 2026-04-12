-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.expandtab   = true
vim.opt.tabstop     = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth  = 4

-- Writing mode toggle (<leader>w)
vim.keymap.set("n", "<leader>w", function()
    require("writing").toggle()
end, { desc = "Toggle writing mode" })
