return {
  -- ═══════════════════════════════════════════════════════════
  -- snacks.nvim — image viewer for raster images & docs
  -- Default behavior: SVGs open as editable XML source text by hand.
  -- Press <leader>lv to open an on-demand floating visual preview of the SVG.
  -- ═══════════════════════════════════════════════════════════
  {
    "folke/snacks.nvim",
    opts = {
      image = {
        enabled = true,
        doc = {
          enabled = true,
          inline = true,
          float = true,
        },
      },
    },
    keys = {
      {
        "<leader>lv",
        function()
          local file = vim.api.nvim_buf_get_name(0)
          if not file:match("%.svg$") then
            vim.notify("Current buffer is not an SVG file", vim.log.levels.WARN)
            return
          end
          if vim.bo.modified then
            vim.cmd("silent! write")
          end
          local out_png = vim.fn.tempname() .. ".png"
          local cmd = { "rsvg-convert", "-o", out_png, file }
          if vim.fn.executable("rsvg-convert") ~= 1 then
            cmd = { "convert", file, out_png }
          end
          local proc = vim.system(cmd):wait()
          if proc.code == 0 and vim.fn.filereadable(out_png) == 1 then
            local ok_snacks, snacks = pcall(require, "snacks")
            if ok_snacks and snacks.image then
              local buf = vim.api.nvim_create_buf(false, true)
              local width = math.min(70, vim.o.columns - 4)
              local height = math.min(30, vim.o.lines - 4)
              local win = vim.api.nvim_open_win(buf, true, {
                relative = "editor",
                width = width,
                height = height,
                row = math.floor((vim.o.lines - height) / 2),
                col = math.floor((vim.o.columns - width) / 2),
                border = "rounded",
                title = " SVG Preview: " .. vim.fn.fnamemodify(file, ":t") .. " ",
                title_pos = "center",
              })
              snacks.image.buf._attach(buf, { src = out_png })
              local close = function()
                if vim.api.nvim_win_is_valid(win) then
                  vim.api.nvim_win_close(win, true)
                end
                pcall(vim.fn.delete, out_png)
              end
              vim.keymap.set("n", "q", close, { buffer = buf, silent = true })
              vim.keymap.set("n", "<Esc>", close, { buffer = buf, silent = true })
            end
          else
            vim.notify("SVG rasterization failed: " .. (proc.stderr or ""), vim.log.levels.ERROR)
          end
        end,
        desc = "Live Preview: Floating terminal image",
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
      { "<leader>lp", "<cmd>LivePreview<CR>", desc = "Live Preview: Start browser" },
      { "<leader>ls", "<cmd>StopPreview<CR>", desc = "Live Preview: Stop browser" },
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
