-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
vim.api.nvim_set_keymap("i", "<C-h>", "<Left>", { noremap = true, silent = true, desc = "Move left in insert mode" })
vim.api.nvim_set_keymap("i", "<C-j>", "<Down>", { noremap = true, silent = true, desc = "Move down in insert mode" })
vim.api.nvim_set_keymap("i", "<C-k>", "<Up>", { noremap = true, silent = true, desc = "Move up in insert mode" })
vim.api.nvim_set_keymap("i", "<C-l>", "<Right>", { noremap = true, silent = true, desc = "Move right in insert mode" })

function Set_terminal_keymaps()
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua Set_terminal_keymaps()")

local lazygit = nil
function _LAZYGIT_TOGGLE()
  if not lazygit then
    local Terminal = require("toggleterm.terminal").Terminal
    lazygit = Terminal:new({ cmd = "lazygit", hidden = false })
  end
  lazygit:toggle()
end

local python = nil
function _PYTHON_TOGGLE()
  if not python then
    local Terminal = require("toggleterm.terminal").Terminal
    python = Terminal:new({ cmd = "python3", hidden = true })
  end
  python:toggle()
end

local opts = { noremap = true, silent = false }
--for running code
--vim.api.nvim_set_keymap("v", "<leader>r", "<Plug>SnipRun", { silent = true })
--vim.api.nvim_set_keymap("n", "<leader>r", "<Plug>SnipRun", { silent = true })
-- vim.keymap.set("n", "<leader>rr", ":QuickRun<CR>", opts)
vim.keymap.set("n", "<leader>rr", ":RunCode<CR>", opts)
vim.keymap.set("n", "<leader>rf", ":RunFile<CR>", opts)
vim.keymap.set("n", "<leader>rft", ":RunFile tab<CR>", opts)
vim.keymap.set("n", "<leader>rp", ":RunProject<CR>", opts)
vim.keymap.set("n", "<leader>rc", ":RunClose<CR>", opts)

-- Better escape
vim.keymap.set("i", "jk", "<ESC>", opts)

vim.keymap.set("n", "<ESC>", "<ESC>:noh<CR>", opts)
vim.keymap.set("n", "fs", "<cmd>w<cr>", opts)

pcall(vim.keymap.del, "n", "<leader>l")

-- dap keys
local function set_dapui_context_keys()
  local dap = require("dap")
  local opts = { buffer = true, silent = true }

  -- Single-key debugging actions inside the UI panels
  vim.keymap.set("n", "c", dap.continue, vim.tbl_extend("force", opts, { desc = "DAP Continue" }))
  vim.keymap.set("n", "n", dap.step_over, vim.tbl_extend("force", opts, { desc = "DAP Step Over (Next)" }))
  vim.keymap.set("n", "i", dap.step_into, vim.tbl_extend("force", opts, { desc = "DAP Step Into" }))
  vim.keymap.set("n", "o", dap.step_out, vim.tbl_extend("force", opts, { desc = "DAP Step Out" }))
  vim.keymap.set("n", "b", dap.toggle_breakpoint, vim.tbl_extend("force", opts, { desc = "DAP Toggle Breakpoint" }))

  -- Quick escape: press 'q' inside any panel to close the whole debug UI
  vim.keymap.set("n", "q", function()
    require("dapui").close()
  end, opts)
end

-- Automatically apply these maps ONLY to DAP UI and REPL buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "dapui_scopes",
    "dapui_breakpoints",
    "dapui_stacks",
    "dapui_watches",
    "dapui_repl",
    "dap-repl",
  },
  callback = set_dapui_context_keys,
})

-- Toggle AI Chat Sidebar
vim.api.nvim_set_keymap("n", "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { silent = true })
vim.api.nvim_set_keymap("v", "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { silent = true })

-- Request Inline Assistance or Refactor selected text
vim.api.nvim_set_keymap("n", "<leader>ai", "<cmd>CodeCompanion<cr>", { silent = true })
vim.api.nvim_set_keymap("v", "<leader>ai", "<cmd>CodeCompanion<cr>", { silent = true })

-- Open pre-built action menus (Explain code, Fix bugs, Optimize)
vim.api.nvim_set_keymap("n", "<leader>aa", "<cmd>CodeCompanionActions<cr>", { silent = true })
vim.api.nvim_set_keymap("v", "<leader>aa", "<cmd>CodeCompanionActions<cr>", { silent = true })
-- Move windows left/up/down/right
-- nnoremap <C-w>j <C-w>J
-- nnoremap <C-w>k <C-w>K
-- nnoremap <C-w>h <C-w>H
-- nnoremap <C-w>l <C-w>L
-- local wk = require("which-key")
-- wk.add({
--   { "<leader>fs", "<cmd>w<cr>", desc = "[s]ave file", mode = "n" },
-- })
--
