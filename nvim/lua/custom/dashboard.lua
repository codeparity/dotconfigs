return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
  _________ __                       ___.                  __   
 /   _____//  |_  ___________ ___.__.\_ |__   ____   ____ |  |  
 \_____  \\   __\/  _ \_  __ <   |  | | __ \ /  _ \ /  _ \|  |  
 /        \|  | (  <_> )  | \/\___  | | \_\ (  <_> |  <_> )  |__
/_______  /|__|  \____/|__|   / ____| |___  /\____/ \____/|____/
        \/                    \/          \/                    
          ]],
          -- Remove the default LazyVim keys and replace them with purely Storybook ones
          keys = {
            { icon = "📖", key = "o", desc = "Open Existing Volume", action = ":Telescope find_files search_dirs={'metaverses/terra-666/books'}<cr>" },
            { icon = "➕", key = "n", desc = "Start New Volume", action = ":StorybookNewVolume<cr>" },
            { icon = "👁️", key = "p", desc = "Open Compiler Preview", action = ":StorybookPreview<cr>" },
            { icon = "🚪", key = "q", desc = "Quit Studio", action = ":qa<cr>" },
          },
        },
      },
    },
  },
}
