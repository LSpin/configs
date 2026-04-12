return {
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        config = function()
            require("typescript-tools").setup({
                on_attach = function(_, bufnr)
                    local opts = { buffer = bufnr }
                    vim.keymap.set("n", "<leader>ti", "<cmd>TSToolsOrganizeImports<cr>",    vim.tbl_extend("force", opts, { desc = "Organize imports" }))
                    vim.keymap.set("n", "<leader>tr", "<cmd>TSToolsRenameFile<cr>",         vim.tbl_extend("force", opts, { desc = "Rename file (updates imports)" }))
                    vim.keymap.set("n", "<leader>tu", "<cmd>TSToolsRemoveUnusedImports<cr>", vim.tbl_extend("force", opts, { desc = "Remove unused imports" }))
                    vim.keymap.set("n", "<leader>ta", "<cmd>TSToolsAddMissingImports<cr>",  vim.tbl_extend("force", opts, { desc = "Add missing imports" }))
                    vim.keymap.set("n", "<leader>gd",  "<cmd>TSToolsGoToSourceDefinition<cr>", vim.tbl_extend("force", opts, { desc = "Go to source definition" }))
                end,
                settings = {
                    expose_as_code_action = "all",
                },
            })
        end,
    },
}
