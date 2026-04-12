return {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.header.val = {
            "                                                                        ",
            "  ｦ ｩ ｬ ｯ ｲ ｵ ｸ ｻ ｾ ﾁ ﾄ ﾇ ﾊ ﾍ ﾐ ﾓ ﾖ ﾙ ﾜ 0 1 0 ｦ ｩ ｬ ｯ ｲ ｵ ｸ ｻ ｾ ﾁ ﾄ  ",
            "    ｧ ｪ ｭ ｰ ｳ ｶ ｹ ｼ ｿ ﾂ ﾅ ﾈ ﾋ ﾎ ﾑ ﾔ ﾗ ﾚ ﾝ 1 0 1 ｧ ｪ ｭ ｰ ｳ ｶ ｹ ｼ ｿ ﾂ ﾅ  ",
            "  0 ｫ ｮ ｱ ｴ ｷ ｺ ｽ ﾀ ﾃ ﾆ ﾉ ﾌ ﾏ ﾒ ﾕ ﾘ ﾛ 0 1 0 1 ｫ ｮ ｱ ｴ ｷ ｺ ｽ ﾀ ﾃ ﾆ ﾉ  ",
            "                                                                        ",
            "  ███████╗██╗     ███████╗ ██████╗████████╗██████╗ ██╗ ██████╗        ",
            "  ██╔════╝██║     ██╔════╝██╔════╝╚══██╔══╝██╔══██╗██║██╔════╝        ",
            "  █████╗  ██║     █████╗  ██║        ██║   ██████╔╝██║██║             ",
            "  ██╔══╝  ██║     ██╔══╝  ██║        ██║   ██╔══██╗██║██║             ",
            "  ███████╗███████╗███████╗╚██████╗   ██║   ██║  ██║██║╚██████╗        ",
            "  ╚══════╝╚══════╝╚══════╝ ╚═════╝   ╚═╝   ╚═╝  ╚═╝╚═╝ ╚═════╝       ",
            "                                                                        ",
            "            ██████╗ ██╗███╗   ██╗██╗  ██╗                             ",
            "            ██╔══██╗██║████╗  ██║██║ ██╔╝                             ",
            "            ██████╔╝██║██╔██╗ ██║█████╔╝                              ",
            "            ██╔═══╝ ██║██║╚██╗██║██╔═██╗                              ",
            "            ██║     ██║██║ ╚████║██║  ██╗                             ",
            "            ╚═╝     ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝                            ",
            "                                                                        ",
            "              do androids dream of electric pink?                      ",
            "                                                                        ",
            "  0 ｫ ｮ ｱ ｴ ｷ ｺ ｽ ﾀ ﾃ ﾆ ﾉ ﾌ ﾏ ﾒ ﾕ ﾘ ﾛ 0 1 0 1 ｫ ｮ ｱ ｴ ｷ ｺ ｽ ﾀ ﾃ ﾆ ﾉ  ",
            "    ｧ ｪ ｭ ｰ ｳ ｶ ｹ ｼ ｿ ﾂ ﾅ ﾈ ﾋ ﾎ ﾑ ﾔ ﾗ ﾚ ﾝ 1 0 1 ｧ ｪ ｭ ｰ ｳ ｶ ｹ ｼ ｿ ﾂ ﾅ  ",
            "  ｦ ｩ ｬ ｯ ｲ ｵ ｸ ｻ ｾ ﾁ ﾄ ﾇ ﾊ ﾍ ﾐ ﾓ ﾖ ﾙ ﾜ 0 1 0 ｦ ｩ ｬ ｯ ｲ ｵ ｸ ｻ ｾ ﾁ ﾄ  ",
            "                                                                        ",
        }

        dashboard.section.header.opts.hl = "AlphaHeader"

        dashboard.section.buttons.val = {
            dashboard.button("n", "  New file",     ":enew<CR>"),
            dashboard.button("p", "  Find file",    ":Telescope find_files<CR>"),
            dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
            dashboard.button("g", "  Live grep",    ":Telescope live_grep<CR>"),
            dashboard.button("q", "  Quit",         ":qa<CR>"),
        }

        -- Pink highlight for the header
        vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#ff77bb" })
        vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#ffaacc" })

        alpha.setup(dashboard.config)
    end,
}
