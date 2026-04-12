return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
        require("telescope").setup({
            extensions = {
                ["ui-select"] = require("telescope.themes").get_dropdown(),
            },
        })
        require("telescope").load_extension("ui-select")
    end,
    keys = {
        { "<C-p>",      "<cmd>Telescope find_files<cr>", desc = "Find files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Live grep" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>",  desc = "Help tags" },
    },
}
