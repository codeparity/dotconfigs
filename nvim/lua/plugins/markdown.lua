return {
  -- Prettier and Harper-ls installation in Mason
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "prettier", "harper-ls", "marksman" })
    end,
  },

  -- Prettier formatting for Markdown via conform.nvim
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft["markdown"] = opts.formatters_by_ft["markdown"] or {}
      if not vim.tbl_contains(opts.formatters_by_ft["markdown"], "prettier") then
        table.insert(opts.formatters_by_ft["markdown"], "prettier")
      end
      opts.formatters_by_ft["markdown.mdx"] = opts.formatters_by_ft["markdown.mdx"] or {}
      if not vim.tbl_contains(opts.formatters_by_ft["markdown.mdx"], "prettier") then
        table.insert(opts.formatters_by_ft["markdown.mdx"], "prettier")
      end
    end,
  },

  -- Markdown Language Servers: Marksman (structure/links) + Harper (grammar/prose)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {},
        harper_ls = {
          filetypes = { "markdown", "text", "gitcommit" },
          settings = {
            ["harper-ls"] = {
              userDictPath = "~/dict.txt",
              markdown = {
                IgnoreLinkTitle = true,
              },
            },
          },
        },
      },
    },
  },

  -- bullets.vim: Automated bullet lists, checkboxes, and renumbering
  {
    "bullets-vim/bullets.vim",
    ft = { "markdown", "text", "gitcommit", "scratch" },
    init = function()
      vim.g.bullets_enabled_file_types = { "markdown", "text", "gitcommit", "scratch" }
      vim.g.bullets_enable_in_empty_buffers = 0
      vim.g.bullets_set_mappings = 1
      vim.g.bullets_outline_levels = { "std-", "std*", "std+", "num" }
    end,
  },

  -- Tabular: Table and delimiter alignment tool
  {
    "godlygeek/tabular",
    cmd = { "Tabularize" },
    keys = {
      { "<leader>at", "<cmd>Tabularize /|<cr>", mode = { "n", "v" }, desc = "Align Markdown Table (|)" },
      { "<leader>a=", "<cmd>Tabularize /=<cr>", mode = { "n", "v" }, desc = "Align by =" },
      { "<leader>a:", "<cmd>Tabularize /:<cr>", mode = { "n", "v" }, desc = "Align by :" },
      { "<leader>a,", "<cmd>Tabularize /,<cr>", mode = { "n", "v" }, desc = "Align by ," },
    },
  },
}
