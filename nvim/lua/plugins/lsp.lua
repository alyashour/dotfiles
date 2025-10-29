local mason = require("mason")
local mlc = require("mason-lspconfig")

-- Setup Mason
mason.setup()
mlc.setup({
    ensure_installed = { "pyright", "rust_analyzer", "clangd", "lua_ls", "zls" }
})

-- Shared on_attach function
local on_attach = function(client, bufnr)
    -- Your keybindings and settings here
    -- Example:
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
    -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
end

-- Capabilities for nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities(
    vim.lsp.protocol.make_client_capabilities()
)

-- Server configurations
local servers = {
    pyright = {},
    rust_analyzer = {},
    clangd = {},
    lua_ls = {
        settings = {
            Lua = {
                diagnostics = { globals = { "vim" } },
                workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                telemetry = { enable = false },
            },
        },
    },
    zls = {
        -- Enable formatting for Zig
        on_attach = function(client, bufnr)
            -- Call the standard on_attach first
            on_attach(client, bufnr)

            -- Enable format on save for Zig files
            if client.supports_method("textDocument/formatting") then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ bufnr = bufnr })
                    end,
                })
            end
        end,
        zig_exe_path = "/usr/local/bin/zig",
        enable_build_on_save = true,
    },
}

-- Configure and start LSP servers using the new API
for server_name, server_config in pairs(servers) do
    -- Merge base config with server-specific config
    local config = vim.tbl_deep_extend("force", {
        capabilities = capabilities,
        on_attach = server_config.on_attach or on_attach,
    }, server_config)

    -- Remove the custom on_attach from server_config to avoid duplication
    config.on_attach = server_config.on_attach or on_attach

    -- Use vim.lsp.config to define the server
    vim.lsp.config[server_name] = {
        cmd = server_config.cmd or vim.lsp.config[server_name].cmd,
        root_markers = server_config.root_markers,
        capabilities = config.capabilities,
        on_attach = config.on_attach,
        settings = config.settings,
    }

    -- Enable the server (it will auto-start when a matching filetype is opened)
    vim.lsp.enable(server_name)
end
