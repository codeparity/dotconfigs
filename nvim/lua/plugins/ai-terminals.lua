return {
  {
    "aweis89/ai-terminals.nvim",
    dependencies = { "folke/snacks.nvim" },
    keys = {
      { "<leader>at", function() require("ai-terminals").toggle("agy") end, mode = { "n", "v" }, desc = "Toggle AI Terminal (agy)" },
    },
    opts = {
      terminals = {
        agy = { cmd = "agy" },
      },
      auto_terminal_keymaps = {
        prefix = "<leader>a",
        terminals = {
          { name = "agy", key = "g" },
        },
      },
    },
    config = function(_, opts)
      require("ai-terminals").setup(opts)
      -- Optional Snacks picker integration
      local sa = require("ai-terminals.snacks_actions")
      pcall(function() sa.apply(require("snacks").config) end)
    end,
  },
}
