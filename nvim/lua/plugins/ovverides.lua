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
      cmdline = {
        enabled = true,
        keymap = {
          preset = "cmdline",
          ["<Tab>"] = { "show_and_insert_or_accept_single", "select_next", "fallback" },
          ["<S-Tab>"] = {
            function(cmp)
              return cmp.show_and_insert_or_accept_single({ initial_selected_item_idx = -1 })
            end,
            "select_prev",
            "fallback",
          },
          ["<Down>"] = { "select_next", "fallback" },
          ["<Up>"] = { "select_prev", "fallback" },
          ["<C-n>"] = { "select_next", "fallback" },
          ["<C-p>"] = { "select_prev", "fallback" },
          ["<CR>"] = { "accept_and_enter", "fallback" },
          ["<Right>"] = false,
          ["<Left>"] = false,
        },
        completion = {
          menu = {
            auto_show = true,
          },
          ghost_text = {
            enabled = true,
          },
          list = {
            selection = {
              preselect = false,
              auto_insert = true,
            },
          },
        },
      },
    },
  },
}
