return {
  "folke/which-key.nvim",
  opts = {
    spec = {
      { "<leader>a", group = "ai" }, -- codecompanion: aa/ac/ai
      { "<leader>r", group = "run" }, -- code_runner.nvim: rr/rf/rft/rp/rc
      { "<leader>wW", desc = "Sticky Window Mode" },
      { "<leader>wm", group = "+move window" },
      { "<leader>wz", desc = "Zoom/maximize" },
      { "<leader>w=", group = "+width" },
      { "<leader>wv", group = "+height" },
      { "<leader><tab>", group = "+tabs" },
    },
  },
}
