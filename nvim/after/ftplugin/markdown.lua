-- Markdown Natural Writing & List Configuration
-- Runs automatically for markdown filetypes after runtime defaults

--------------------------------------------------------------------------------
-- 1. Indentation Settings (2 Spaces)
--------------------------------------------------------------------------------
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

-- Disable treesitter indentexpr for markdown to prevent unexpected cursor jumps
vim.bo.indentexpr = ""

--------------------------------------------------------------------------------
-- 2. Natural Text & Prose Wrapping
--------------------------------------------------------------------------------
-- Soft wrapping at word boundaries without breaking words mid-character
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true
vim.opt_local.textwidth = 0

-- Prevent Vim from auto-inserting hard newlines mid-sentence while typing
vim.opt_local.formatoptions:remove({ "t", "c", "o" })
vim.opt_local.formatoptions:append("j") -- clean join lines without trailing comment leaders

-- Concealment: clean rendered view, reveals raw markdown when cursor is on the line
vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = ""

--------------------------------------------------------------------------------
-- 3. Visual Line Navigation (Move through wrapped prose naturally)
--------------------------------------------------------------------------------
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, buffer = true, silent = true, desc = "Down visual line" })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, buffer = true, silent = true, desc = "Up visual line" })

--------------------------------------------------------------------------------
-- 4. Helper Functions for Markdown Lists
--------------------------------------------------------------------------------
local function is_list_line(line)
  return line:match("^%s*[%-%*%+]%s*") ~= nil or line:match("^%s*%d+[%.%)%]]%s*") ~= nil
end

--------------------------------------------------------------------------------
-- 5. Tab & Shift-Tab (2 spaces, but as list indentation)
--------------------------------------------------------------------------------
-- Insert Mode: Tab
vim.keymap.set("i", "<Tab>", function()
  local line = vim.api.nvim_get_current_line()
  if is_list_line(line) then
    return "<C-t>"
  end
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local next_char = line:sub(col + 1, col + 1)
  -- Autopair bracket / quote jump-out
  if next_char:match("[%)}%\"%]]") or next_char == "`" then
    return "<Right>"
  else
    return "  "
  end
end, { expr = true, buffer = true, silent = true, desc = "Indent list item or insert 2 spaces" })

-- Insert Mode: Shift-Tab
vim.keymap.set("i", "<S-Tab>", function()
  local line = vim.api.nvim_get_current_line()
  if is_list_line(line) or line:match("^%s+") then
    return "<C-d>"
  end
  return ""
end, { expr = true, buffer = true, silent = true, desc = "Dedent list item or line" })

-- Normal Mode: Tab / Shift-Tab
vim.keymap.set("n", "<Tab>", function()
  local line = vim.api.nvim_get_current_line()
  if is_list_line(line) then
    return ">>"
  else
    return "<Tab>"
  end
end, { expr = true, buffer = true, silent = true, desc = "Indent list item" })

vim.keymap.set("n", "<S-Tab>", function()
  local line = vim.api.nvim_get_current_line()
  if is_list_line(line) or line:match("^%s+") then
    return "<<"
  else
    return "<S-Tab>"
  end
end, { expr = true, buffer = true, silent = true, desc = "Dedent list item" })

-- Visual Mode: Tab / Shift-Tab (keeps selection with gv)
vim.keymap.set("v", "<Tab>", ">gv", { buffer = true, silent = true, desc = "Indent selection" })
vim.keymap.set("v", "<S-Tab>", "<gv", { buffer = true, silent = true, desc = "Dedent selection" })

--------------------------------------------------------------------------------
-- 6. Smart Enter (<CR>) & New Lines (o / O)
--------------------------------------------------------------------------------
-- Automatically continues list items on Enter, and deletes empty bullet on second Enter
local function handle_cr()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local before = line:sub(1, col)
  local after = line:sub(col + 1)

  -- Checkbox lists: e.g. - [ ] item or - [x] item
  local indent, bullet, box, rest = line:match("^(%s*)([%-%*%+]%s+)%[([%s%w]?)%]%s*(.*)$")
  if indent then
    if rest:match("^%s*$") and col >= #line - #rest then
      vim.api.nvim_set_current_line(indent)
      return
    end
    local pre_rest = before:match("^%s*[%-%*%+]%s+%[[%s%w]?%]%s*(.*)$") or ""
    vim.api.nvim_set_current_line(indent .. bullet .. "[" .. box .. "] " .. pre_rest)
    local next_prefix = indent .. bullet .. "[ ] "
    local row = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, row, row, false, { next_prefix .. after })
    vim.api.nvim_win_set_cursor(0, { row + 1, #next_prefix })
    return
  end

  -- Numbered lists: e.g. 1. item or 1) item
  local indent, num, delim, rest = line:match("^(%s*)(%d+)([%.%)])%s*(.*)$")
  if indent then
    if rest:match("^%s*$") and col >= #line - #rest then
      vim.api.nvim_set_current_line(indent)
      return
    end
    local pre_rest = before:match("^%s*%d+[%.%)]%s*(.*)$") or ""
    vim.api.nvim_set_current_line(indent .. num .. delim .. " " .. pre_rest)
    local next_prefix = indent .. tostring(tonumber(num) + 1) .. delim .. " "
    local row = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, row, row, false, { next_prefix .. after })
    vim.api.nvim_win_set_cursor(0, { row + 1, #next_prefix })
    return
  end

  -- Bullet lists: e.g. - item, * item, + item
  local indent, bullet, rest = line:match("^(%s*)([%-%*%+]%s+)(.*)$")
  if indent then
    if rest:match("^%s*$") and col >= #line - #rest then
      vim.api.nvim_set_current_line(indent)
      return
    end
    local pre_rest = before:match("^%s*[%-%*%+]%s+(.*)$") or ""
    vim.api.nvim_set_current_line(indent .. bullet .. pre_rest)
    local next_prefix = indent .. bullet
    local row = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, row, row, false, { next_prefix .. after })
    vim.api.nvim_win_set_cursor(0, { row + 1, #next_prefix })
    return
  end

  local key = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
  vim.api.nvim_feedkeys(key, "n", false)
end

vim.keymap.set("i", "<CR>", handle_cr, { buffer = true, silent = true, desc = "Continue list item or newline" })

-- Normal Mode: o and O
local function handle_o(above)
  local line = vim.api.nvim_get_current_line()
  local row = vim.api.nvim_win_get_cursor(0)[1]

  -- Checkbox
  local indent, bullet = line:match("^(%s*)([%-%*%+]%s+)%[[%s%w]?%]")
  if indent then
    local new_prefix = indent .. bullet .. "[ ] "
    local insert_row = above and (row - 1) or row
    vim.api.nvim_buf_set_lines(0, insert_row, insert_row, false, { new_prefix })
    vim.api.nvim_win_set_cursor(0, { insert_row + 1, #new_prefix })
    vim.cmd("startinsert!")
    return
  end

  -- Numbered list
  local indent, num, delim = line:match("^(%s*)(%d+)([%.%)])%s+")
  if indent then
    local next_num = above and num or tostring(tonumber(num) + 1)
    local new_prefix = indent .. next_num .. delim .. " "
    local insert_row = above and (row - 1) or row
    vim.api.nvim_buf_set_lines(0, insert_row, insert_row, false, { new_prefix })
    vim.api.nvim_win_set_cursor(0, { insert_row + 1, #new_prefix })
    vim.cmd("startinsert!")
    return
  end

  -- Bullet list
  local indent, bullet = line:match("^(%s*)([%-%*%+]%s+)")
  if indent then
    local new_prefix = indent .. bullet
    local insert_row = above and (row - 1) or row
    vim.api.nvim_buf_set_lines(0, insert_row, insert_row, false, { new_prefix })
    vim.api.nvim_win_set_cursor(0, { insert_row + 1, #new_prefix })
    vim.cmd("startinsert!")
    return
  end

  local key = vim.api.nvim_replace_termcodes(above and "O" or "o", true, false, true)
  vim.api.nvim_feedkeys(key, "n", false)
end

vim.keymap.set("n", "o", function() handle_o(false) end, { buffer = true, silent = true, desc = "New list item below" })
vim.keymap.set("n", "O", function() handle_o(true) end, { buffer = true, silent = true, desc = "New list item above" })

--------------------------------------------------------------------------------
-- 7. Checkbox Toggle (<leader>mx)
--------------------------------------------------------------------------------
local function toggle_checkbox()
  local line = vim.api.nvim_get_current_line()
  if line:match("^%s*[%-%*%+]%s+%[%s?%]") then
    local new_line = line:gsub("^(%s*[%-%*%+]%s+)%[%s?%]", "%1[x]", 1)
    vim.api.nvim_set_current_line(new_line)
  elseif line:match("^%s*[%-%*%+]%s+%[[xX]%]") then
    local new_line = line:gsub("^(%s*[%-%*%+]%s+)%[[xX]%]", "%1[ ]", 1)
    vim.api.nvim_set_current_line(new_line)
  end
end

vim.keymap.set("n", "<leader>mx", toggle_checkbox, { buffer = true, silent = true, desc = "Toggle markdown checkbox" })
