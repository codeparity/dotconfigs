-- Dashboard entries for the Zola blog, added only when nvim starts in it.
--
-- The commands themselves live in the project's own .nvim.lua, so they are not
-- defined yet when this file is read and may not be defined when the key is
-- pressed either (exrc has to have been trusted). Each action checks first and
-- falls back to something harmless.

local function in_blog()
  local cwd = vim.fn.getcwd()
  return vim.fn.filereadable(cwd .. "/config.toml") == 1
    and vim.fn.isdirectory(cwd .. "/content") == 1
    and vim.fn.filereadable(cwd .. "/.nvim.lua") == 1
end

local function run(command, fallback)
  return function()
    if vim.fn.exists(":" .. command) == 2 then
      vim.cmd(command)
    else
      fallback()
    end
  end
end

return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    if not in_blog() then
      return
    end
    local keys = vim.tbl_get(opts, "dashboard", "preset", "keys")
    if not keys then
      return
    end
    table.insert(keys, 1, {
      icon = " ",
      key = "a",
      desc = "Blog Article",
      action = run("ZolaArticles", function()
        Snacks.picker.files({ dirs = { "content/articles", "content/substack" } })
      end),
    })
    table.insert(keys, 2, {
      icon = " ",
      key = "z",
      desc = "Blog Serve",
      action = run("ZolaTest", function()
        vim.notify("ZolaTest needs the project's .nvim.lua — :trust it first", vim.log.levels.WARN)
      end),
    })
  end,
}
