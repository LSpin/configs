local M = {}

local writing_mode = false

function M.toggle()
    writing_mode = not writing_mode

    if writing_mode then
        vim.opt.wrap         = true
        vim.opt.linebreak    = true
        vim.opt.textwidth    = 0
        vim.opt.scrolloff    = 999
        vim.opt.spell        = true
        vim.opt.spelllang    = "en_us"
        vim.opt.conceallevel = 2
        vim.opt.number         = true
        vim.opt.relativenumber = false

        vim.cmd("Lazy load vim-pencil")
        vim.cmd("Lazy load zen-mode.nvim")
        vim.cmd("Lazy load twilight.nvim")

        vim.cmd("PencilSoft")
        require("zen-mode").open()
        require("twilight").enable()

        vim.notify("Writing mode ON", vim.log.levels.INFO)
    else
        vim.opt.wrap           = false
        vim.opt.linebreak      = false
        vim.opt.scrolloff      = 8
        vim.opt.spell          = false
        vim.opt.conceallevel   = 0
        vim.opt.number         = true
        vim.opt.relativenumber = false

        vim.cmd("PencilOff")
        require("zen-mode").close()
        require("twilight").disable()

        vim.notify("Writing mode OFF", vim.log.levels.INFO)
    end
end

return M
