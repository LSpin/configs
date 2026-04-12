return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "jdtls", "pyright", "html", "cssls", "emmet_ls" },
                automatic_installation = true,
            })

            vim.lsp.enable({ "lua_ls", "pyright", "html", "cssls" })

            require("lspconfig").emmet_ls.setup({
                filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" },
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(event)
                    local opts = { buffer = event.buf }
                    vim.keymap.set("n", "K",          vim.lsp.buf.hover,       vim.tbl_extend("force", opts, { desc = "Hover info" }))
                    vim.keymap.set("n", "gD",         vim.lsp.buf.definition,  vim.tbl_extend("force", opts, { desc = "Go to definition" }))
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code actions" }))
                end,
            })
        end,
    },
}
