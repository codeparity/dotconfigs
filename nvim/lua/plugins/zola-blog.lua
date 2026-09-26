-- Dashboard entries for the Zola blog, added only when the project opts in.
--
-- The project's .nvim.lua sets vim.g.zola_project = true before this runs
-- (exrc is processed before UIEnter, when the dashboard renders).
-- Commands live in .nvim.lua too; if exrc hasn't been trusted yet the
-- fallback action is harmless.

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
    if not vim.g.zola_project then
      return
    end
    local keys = vim.tbl_get(opts, "dashboard", "preset", "keys")
    if not keys then
      return
    end
    local dirs = vim.g.zola_content_dirs or { "source" }
    table.insert(keys, 1, {
      icon = " ",
      key = "a",
      desc = "Blog Article",
      action = run("ZolaArticles", function()
        Snacks.picker.files({ dirs = dirs })
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
