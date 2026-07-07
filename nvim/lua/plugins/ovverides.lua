return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "super-tab", -- This enables Tab to accept suggestions
      },
    },
  },
  -- get the classic commmand line
  -- {
  --   "folke/noice.nvim",
  --   opts = {
  --     cmdline = {
  --       enabled = false,
  --     },
  --     messages = {
  --       enabled = false,
  --     },
  --   },
  -- },
  --
}
