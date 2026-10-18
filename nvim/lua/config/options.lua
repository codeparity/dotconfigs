-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.opt.mouse = ""
vim.opt.title = true
vim.opt.titlestring = "%F"
-- vim.opt.titleold = true
vim.opt.titleold = "Terminal"

vim.opt.nu = true
vim.opt.relativenumber = true
vim.o.statuscolumn = "%s %l %r "
vim.o.exrc = true

-- Disable vim's default 4-space markdown indent style
vim.g.markdown_recommended_style = 0
