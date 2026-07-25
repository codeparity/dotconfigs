return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    -- Load global AIST .env file, then override with local project .env
    local aist_env = {}
    local function load_env_file(filepath)
      local f = io.open(filepath, "r")
      if f then
        for line in f:lines() do
          local key, value = string.match(line, "^export%s+([%w_]+)%s*=%s*[\"']?(.-)[\"']?$")
          if key and value then aist_env[key] = value end
        end
        f:close()
      end
    end

    load_env_file(vim.fn.expand("~/projects/ai_studio/.env"))
    load_env_file(vim.fn.getcwd() .. "/.env")

    local llm_port = aist_env["AI_STUDIO_LLM_PORT"] or "8001"
    local llm_model = aist_env["AIST_CODE_MODEL"] or aist_env["AI_STUDIO_LLM_MODEL"] or "default"

    require("codecompanion").setup({
      strategies = {
        -- Enable inline generation workflows
        chat = { adapter = "aist" },
        inline = { adapter = "aist" },
        agent = { adapter = "aist" },
      },
      adapters = {
        aist = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            name = "aist",
            env = {
              url = "http://127.0.0.1:" .. llm_port,
              api_key = "aist",
            },
            schema = {
              model = {
                default = llm_model,
              },
            },
          })
        end,
      },
    })
  end,
}
