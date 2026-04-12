-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.expandtab   = true
vim.opt.tabstop     = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth  = 4

-- Diagnostics
vim.diagnostic.config({
    virtual_text = {
        prefix = "●",
        source = "always",
        format = function(d)
            local code = d.code and ("[" .. d.code .. "] ") or ""
            return code .. d.message
        end,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
            [vim.diagnostic.severity.HINT]  = " ",
        },
    },
    float = {
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

vim.api.nvim_set_hl(0, "DiagnosticError",               { fg = "#FF4444", bold = true })
vim.api.nvim_set_hl(0, "DiagnosticWarn",                { fg = "#FFB86C", bold = true })
vim.api.nvim_set_hl(0, "DiagnosticInfo",                { fg = "#00CFFF", bold = true })
vim.api.nvim_set_hl(0, "DiagnosticHint",                { fg = "#50FA7B", bold = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError",    { fg = "#FF4444", bold = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn",     { fg = "#FFB86C", bold = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo",     { fg = "#00CFFF", bold = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint",     { fg = "#50FA7B", bold = true })

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic float" })

-- Writing mode toggle (<leader>w)
vim.keymap.set("n", "<leader>w", function()
    require("writing").toggle()
end, { desc = "Toggle writing mode" })
