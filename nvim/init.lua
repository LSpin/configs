-- Leader
vim.g.mapleader = " "

require("options")

-- Motion rebinds
vim.keymap.set({'n', 'v', 'o'}, 'b', '^', { noremap = true })
vim.keymap.set({'n', 'v', 'o'}, 'B', '$', { noremap = true })

-- Disable arrow keys
for _, key in ipairs({'<Up>', '<Down>', '<Left>', '<Right>'}) do
    vim.keymap.set({'n', 'v', 'i', 'o'}, key, '<Nop>', { noremap = true })
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable",
        "https://github.com/folke/lazy.nvim.git", lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup("plugins")
