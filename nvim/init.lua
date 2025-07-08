local config_root = vim.fn.fnamemodify(vim.fn.resolve(vim.fn.stdpath("config")), ":p")

-- IMPORTANT: Adjust Lua's package.path to include your config's root and subdirectories.
-- This tells Lua where to look for 'core.settings', 'plugins.lsp', etc.
package.path = package.path .. ";" .. config_root .. "/?.lua;" .. config_root .. "/?/init.lua"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..."},
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Setup mapleader and maplocalleader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

---- setup lazy.nvim
--require("lazy").setup({
--	spec = {
--		-- add plugins here
--	},
--	-- other settings here
--	-- colorscheme
--	install = { colorscheme = { "habamax" } },
--	-- automatically check plugin updates
--	checker = { enabled = true},
--})

-- Other files
-- core (opts, keymaps, plugin list)
require("core.settings")
require("core.keymaps")
require("core.plugins")

-- plugin-specific setups
require("plugins.theme")
require("plugins.cmp")
require("plugins.lsp")
