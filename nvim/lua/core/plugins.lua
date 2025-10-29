require("lazy").setup({
  -- Theme
  { "folke/tokyonight.nvim", priority=1000, config = function() vim.cmd.colorscheme("tokyonight") end },

  -- LSP + Utils
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim", -- manage LSP servers
  "williamboman/mason-lspconfig.nvim",

  -- Completion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip",

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", run=":TSUpdate" },
})
