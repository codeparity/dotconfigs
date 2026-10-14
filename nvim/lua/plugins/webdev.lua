return {
  -- ═══════════════════════════════════════════════════════════
  -- CSS LSP (cssls), HTML, and Emmet Language Server
  -- ═══════════════════════════════════════════════════════════
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {},
        html = {},
        emmet_language_server = {
          filetypes = {
            "html",
            "css",
            "scss",
            "less",
            "javascript",
            "javascriptreact",
            "typescriptreact",
            "vue",
            "svelte",
          },
        },
      },
    },
  },

  -- ═══════════════════════════════════════════════════════════
  -- Treesitter — ensure web languages are installed
  -- ═══════════════════════════════════════════════════════════
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "html",
        "css",
        "scss",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "jsonc",
        "svg",
        "xml",
      },
    },
  },

  -- ═══════════════════════════════════════════════════════════
  -- tailwind-tools.nvim — class concealing, sorting, color hints
  -- ═══════════════════════════════════════════════════════════
  {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig",
    },
    opts = {
      document_color = {
        enabled = true,
        kind = "inline", -- "inline" | "foreground" | "background"
      },
      conceal = {
        enabled = true, -- conceal long class strings
        min_length = 30, -- only conceal classes longer than this
        symbol = "…", -- symbol to show instead
        highlight = {
          fg = "#38BDF8", -- tailwind blue
        },
      },
    },
    ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
  },

  -- ═══════════════════════════════════════════════════════════
  -- nvim-colorizer — inline color previews (hex, rgb, hsl, tailwind, CSS named)
  -- ═══════════════════════════════════════════════════════════
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = { "*" },
      user_default_options = {
        names = true, -- CSS named colors (e.g., "red", "blue")
        RGB = true, -- #RGB hex
        RRGGBB = true, -- #RRGGBB hex
        RRGGBBAA = true, -- #RRGGBBAA hex
        rgb_fn = true, -- CSS rgb() / rgba()
        hsl_fn = true, -- CSS hsl() / hsla()
        css = true, -- all CSS features combined
        css_fn = true, -- CSS functions like color()
        tailwind = true, -- Tailwind class colors
        mode = "virtualtext", -- "background" | "foreground" | "virtualtext"
        virtualtext = "■",
        virtualtext_inline = true,
      },
    },
  },

  -- ═══════════════════════════════════════════════════════════
  -- nvim-emmet — wrap with emmet abbreviation in visual mode
  -- ═══════════════════════════════════════════════════════════
  {
    "olrtg/nvim-emmet",
    keys = {
      {
        "<leader>xe",
        function()
          require("nvim-emmet").wrap_with_abbreviation()
        end,
        desc = "Emmet: Wrap with abbreviation",
        mode = "v",
      },
    },
  },
}
