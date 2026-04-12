return {
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
        config = function()
            local jdtls = require("jdtls")
            local mason_path = vim.fn.stdpath("data") .. "/mason"

            local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
            local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. project_name

            local config = {
                cmd = {
                    mason_path .. "/bin/jdtls",
                    "-data", workspace_dir,
                },
                root_dir = vim.fs.dirname(
                    vim.fs.find({ "pom.xml", "build.gradle", ".git", "mvnw", "gradlew" }, { upward = true })[1]
                ),
                settings = {
                    java = {
                        configuration = {
                            runtimes = {},
                        },
                    },
                },
                on_attach = function(_, bufnr)
                    local opts = { buffer = bufnr }
                    -- Java-specific keymaps
                    vim.keymap.set("n", "<leader>jo", jdtls.organize_imports,      vim.tbl_extend("force", opts, { desc = "Organize imports" }))
                    vim.keymap.set("n", "<leader>jg", jdtls.generate,              vim.tbl_extend("force", opts, { desc = "Generate (getters/setters/etc)" }))
                    vim.keymap.set("n", "<leader>jv", jdtls.extract_variable,      vim.tbl_extend("force", opts, { desc = "Extract variable" }))
                    vim.keymap.set("v", "<leader>jm", function() jdtls.extract_method(true) end, vim.tbl_extend("force", opts, { desc = "Extract method" }))
                end,
            }

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "java",
                callback = function()
                    jdtls.start_or_attach(config)
                end,
            })
        end,
    },
}
