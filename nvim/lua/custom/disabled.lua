return {
  -- Aggressively disable heavy coding plugins to ensure an instant, distraction-free writing environment.
  { "neovim/nvim-lspconfig", enabled = false },
  { "williamboman/mason.nvim", enabled = false },
  { "williamboman/mason-lspconfig.nvim", enabled = false },
  { "hrsh7th/nvim-cmp", enabled = false },
  { "L3MON4D3/LuaSnip", enabled = false },
  { "stevearc/conform.nvim", enabled = false },
  { "mfussenegger/nvim-lint", enabled = false },
  { "nvim-treesitter/nvim-treesitter", 
    opts = function(_, opts) 
      -- Ensure only markdown and yaml are parsed, saving massive CPU cycles
      opts.ensure_installed = { "markdown", "markdown_inline", "yaml" }
    end 
  },
}
