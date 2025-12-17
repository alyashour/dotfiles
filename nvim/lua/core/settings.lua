-- leader
vim.g.mapleader = " "

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tabs & Indentation
vim.opt.tabstop = 4        -- spaces per tab
vim.opt.shiftwidth = 4     -- spaces for indentation
vim.opt.expandtab = true   -- use spaces instead of tabs
vim.opt.smartindent = true -- absolutely goated

-- UI
vim.opt.cursorline = true  -- highlight the current line
vim.opt.wrap = false       -- don't do by default
vim.opt.linebreak = true   -- always, always, always
vim.opt.signcolumn = "yes" -- idk what this does tbh, gonna see
vim.opt.termguicolors = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- LSP Diagnostics
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { silent = true })

-- Format on save
-- Shout out my barber
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        vim.lsp.buf.format()
    end,
})
