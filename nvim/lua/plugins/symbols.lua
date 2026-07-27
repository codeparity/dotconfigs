return {
  {
    "nvim-telescope/telescope-symbols.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      -- Normal mode mapping
      { "<A-e>", "<cmd>Telescope symbols<cr>", desc = "Find Symbols/Emoji" },
      -- Insert mode mapping
      { "<A-e>", "<cmd>Telescope symbols<cr>", mode = "i", desc = "Insert Symbol/Emoji" },
    },
  },
}
