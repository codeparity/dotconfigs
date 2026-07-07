return {
  {
    "preservim/tagbar",
    -- Optional: lazy load only when needed (e.g., opening Tagbar)
    lazy = true,
    -- Optional: configure with keymaps
    keys = {
      { "<leader>T", "<cmd>TagbarToggle<cr>", desc = "Toggle Tagbar" },
    },
    config = function()
      -- Your Tagbar setup here if needed, but often defaults work [1].
      vim.g.tagbar_autoclose = 1 -- Close when leaving the window (optional)
    end,
  },
}
