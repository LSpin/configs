return {
    "LSpin/do-androids-dream-of-electric-pink",
    lazy = false,
    priority = 1000,
    config = function()
        require("borrowed").setup({
            styles = {
                comments     = "italic",
                conditionals = "bold",
                constants    = "bold",
                keywords     = "bold",
            },
        })
        vim.cmd("colorscheme mayu")
    end,
}
