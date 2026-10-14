return {
  -- ═══════════════════════════════════════════════════════════
  -- snacks.nvim — enable image viewer with SVG support
  -- Uses Kitty Graphics Protocol + ImageMagick to rasterize SVGs
  -- ═══════════════════════════════════════════════════════════
  {
    "folke/snacks.nvim",
    opts = {
      image = {
        enabled = true,
        formats = {
          "png",
          "jpg",
          "jpeg",
          "gif",
          "bmp",
          "webp",
          "tiff",
          "heic",
          "avif",
          "mp4",
          "mov",
          "avi",
          "mkv",
          "webm",
          "pdf",
          "icns",
          "svg",
        },
        doc = {
          enabled = true,
          inline = true,
          float = true,
        },
      },
    },
  },

  -- ═══════════════════════════════════════════════════════════
  -- live-preview.nvim — browser-based SVG/HTML/CSS preview
  -- ═══════════════════════════════════════════════════════════
  {
    "brianhuster/live-preview.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    cmd = { "LivePreview", "StopPreview" },
    keys = {
      { "<leader>lp", "<cmd>LivePreview<CR>", desc = "Live Preview: Start" },
      { "<leader>ls", "<cmd>StopPreview<CR>", desc = "Live Preview: Stop" },
    },
  },

  -- ═══════════════════════════════════════════════════════════
  -- Which-key group registration
  -- ═══════════════════════════════════════════════════════════
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>l", group = "live preview", icon = "󰐃" },
      },
    },
  },
}
