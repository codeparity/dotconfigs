-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--- Lua

-- Auto-save SVG files on leaving insert mode (for live preview)
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = "*.svg",
  callback = function()
    if vim.bo.modified and vim.bo.buftype == "" and vim.bo.filetype ~= "image" then
      vim.cmd("silent! write")
    end
  end,
  desc = "Auto-save SVG files for live preview",
})
