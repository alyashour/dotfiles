local lspconfig = require("lspconfig")
local mason = require("mason")
local mlc = require("mason-lspconfig")

mason.setup()
mlc.setup({ ensure_installed = { "pyright", "rust_analyzer", "clangd", "lua_ls" } })

-- on_attach
local on_attach = function(client, bufnr) 
  -- buffer-local keymaps/options
  -- none rn
end
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- loop through server configs folder
local servers = { "pyright", "rust_analyzer", "clangd", "lua_ls" }
for _, name in ipairs(servers) do
  local ok, config = pcall(require, "plugins.servers." .. name)
  if ok then
    config = vim.tbl_deep_extend("force", {
      on_attach = on_attack,
      capabilities = capabilities,
    }, config)
  else
    config = { on_attach = on_attach, capabilities = capabilities }
  end
  lspconfig[name].setup(config)
end
