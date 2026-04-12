return {
    -- Distraction-free centered writing
    {
        "folke/zen-mode.nvim",
        opts = {
            window = {
                width = 76,
                options = {
                    number = true,
                    relativenumber = false,
                    signcolumn = "no",
                    cursorline = false,
                },
            },
            on_open = function(win)
                local cfg = vim.api.nvim_win_get_config(win)
                cfg.col = 4
                vim.api.nvim_win_set_config(win, cfg)
            end,
        },
    },

    -- Dims inactive paragraphs
    {
        "folke/twilight.nvim",
        opts = {
            dimming = { alpha = 0.25 },
            context = 10,
        },
    },

    -- Prose-friendly word wrap
    { "preservim/vim-pencil" },

    -- Live markdown preview
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install",
        ft = { "markdown" },
    },

    -- Statusline with word count
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = "auto",
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff" },
                lualine_c = { "filename" },
                lualine_x = {
                    {
                        function()
                            local words = vim.fn.wordcount().words
                            return "  " .. words .. " words"
                        end,
                    },
                },
                lualine_y = { "filetype" },
                lualine_z = { "location" },
            },
        },
    },
}
