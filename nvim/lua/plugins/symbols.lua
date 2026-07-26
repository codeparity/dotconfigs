return {
  {
    "nvim-telescope/telescope-symbols.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      -- Normal mode mapping
      { "<leader>fe", "<cmd>Telescope symbols<cr>", desc = "Find Symbols/Emoji" },
      -- Insert mode mapping
      { "<A-e>", "<Esc><cmd>Telescope symbols<cr>", mode = "i", desc = "Insert Symbol/Emoji" },
    },
  },
}
