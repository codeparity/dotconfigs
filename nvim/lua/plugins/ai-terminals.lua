return {
  {
    "aweis89/ai-terminals.nvim",
    dependencies = { "folke/snacks.nvim" },
    keys = {
      {
        "<leader>at",
        function()
          require("ai-terminals").toggle("codex")
        end,
        mode = { "n", "v" },
        desc = "Toggle AI Terminal (codex)",
      },
    },
    opts = {
      terminals = {
        codex = { cmd = "codex" },
      },
      auto_terminal_keymaps = {
        prefix = "<leader>a",
        terminals = {
          { name = "codex", key = "g" },
        },
      },
    },
    config = function(_, opts)
      require("ai-terminals").setup(opts)
      -- Optional Snacks picker integration
      local sa = require("ai-terminals.snacks_actions")
      pcall(function()
        sa.apply(require("snacks").config)
      end)
    end,
  },
}
