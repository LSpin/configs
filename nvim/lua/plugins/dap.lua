return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
            "jay-babu/mason-nvim-dap.nvim",
            "mfussenegger/nvim-dap-python",
            "jbyuki/one-small-step-for-vimkind", -- Lua debugger
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- Install debuggers via Mason
            require("mason-nvim-dap").setup({
                ensure_installed = {
                    "python",    -- Python (debugpy)
                    "javadbg",   -- Java
                    "js",        -- JavaScript / TypeScript
                },
                automatic_installation = true,
            })

            -- Python
            require("dap-python").setup("python")

            -- JavaScript / TypeScript
            dap.adapters["pwa-node"] = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = "node",
                    args = {
                        vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
                        "${port}",
                    },
                },
            }
            for _, lang in ipairs({ "javascript", "typescript" }) do
                dap.configurations[lang] = {
                    {
                        type = "pwa-node",
                        request = "launch",
                        name = "Launch file",
                        program = "${file}",
                        cwd = "${workspaceFolder}",
                    },
                }
            end

            -- Lua
            dap.adapters.nlua = function(callback, config)
                callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
            end
            dap.configurations.lua = {
                {
                    type = "nlua",
                    request = "attach",
                    name = "Attach to Neovim",
                    host = "127.0.0.1",
                    port = 8086,
                },
            }

            -- UI
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
            dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
            dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end

            -- Keymaps
            vim.keymap.set("n", "<C-r>",      dap.continue,          { desc = "Debug: run/continue" })
            vim.keymap.set("n", "<F5>",       dap.continue,          { desc = "Debug: continue" })
            vim.keymap.set("n", "<F10>",      dap.step_over,         { desc = "Debug: step over" })
            vim.keymap.set("n", "<F11>",      dap.step_into,         { desc = "Debug: step into" })
            vim.keymap.set("n", "<F12>",      dap.step_out,          { desc = "Debug: step out" })
            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: toggle breakpoint" })
            vim.keymap.set("n", "<leader>du", dapui.toggle,          { desc = "Debug: toggle UI" })
        end,
    },
}
