-- Setup mapleader and maplocalleader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Set path (mainly for zig tomfoolery)
vim.env.PATH = "/usr/local/bin:" .. vim.env.PATH

-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Load core settings + keymaps + plugins
require("core.settings")
require("core.keymaps")
require("core.plugins")

-- plugin-specific setups
require("plugins.theme")
require("plugins.cmp")
require("plugins.lsp")
