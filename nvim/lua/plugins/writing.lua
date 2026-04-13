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
        config = function(_, opts)
            require("twilight").setup(opts)
            -- Patch get_node to guard against buffers with no treesitter parser
            -- (upstream calls parser:for_each_tree without a nil check)
            local view = require("twilight.view")
            local orig = view.get_node
            view.get_node = function(buf, line)
                local ok, parser = pcall(vim.treesitter.get_parser, buf, nil, { error = false })
                if not ok or not parser then return end
                return orig(buf, line)
            end
        end,
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
