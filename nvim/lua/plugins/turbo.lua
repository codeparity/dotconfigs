-- Turbo.nvim: Nostalgia UI (Borland / Turbo C++ 3.0 interface for Neovim)
return {
  -- Ensure bufferline does not auto-toggle showtabline off when 0 or 1 buffer is open,
  -- and clear offsets so the "Neo-tree" sidebar offset isn't rendered into buffer winbars.
  {
    "akinsho/bufferline.nvim",
    optional = true,
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.always_show_bufferline = true
      opts.options.auto_toggle_bufferline = false
      opts.options.offsets = {}
    end,
  },
  -- Restore the Neo-tree title/source selector directly in the Neo-tree pane
  {
    "nvim-neo-tree/neo-tree.nvim",
    optional = true,
    opts = {
      source_selector = {
        winbar = true,
        statusline = false,
      },
    },
  },
  {
    "codeparity/turbo.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- theme = nil (default: respects whatever colorscheme you have active!)
      enable_tabline = true,     -- Row 0: Top nostalgic menubar (Alt+F, Alt+E, Alt+S, etc.)
      enable_winbar = true,      -- Row 1: Bufferline tabs rendered directly below menubar!
      enable_keymaps = true,     -- Alt+<Key> accelerators and F10 menu
      enable_statusline = false, -- Preserves your existing lualine setup
      enable_lazy_keys = false,  -- Preserves all your custom keymaps
    },
  },
}
