return {
  {
    "coffebar/neovim-project",
    opts = {
      projects = {
        "~/projects/*",
        "~/.config/*",
      },
      picker = {
        type = "telescope", -- "telescope", "fzf-lua", or "snacks"
      },
      dashboard_mode = true,
    },
    init = function()
      -- enable saving global variables that plugins store
      vim.opt.sessionoptions:append("globals")
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
      { "Shatur/neovim-session-manager" },
    },
    lazy = false,
    priority = 100,
    keys = {
      { "<leader>fp", "<cmd>NeovimProjectDiscover<cr>", desc = "Find Projects (Discover)" },
      { "<leader>fh", "<cmd>NeovimProjectHistory<cr>", desc = "Recent Projects History" },
    },
  },
}
