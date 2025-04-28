return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      {
        mode = { "n", "v" },
        { "<leader>f", "Find" },
        { "<leader>p", "Project" },
        { "<leader>g", "Git" },
        { "<leader>n", "Neogen" },
        { "<leader>t", "Toggle "},
        {
          "<leader>w",
          proxy = "<c-w>",
          group = "windows",
          expand = function()
            return require("which-key.extras").expand.win()
          end,
        },
        { "gs", "", desc = "+surround" },
      },
    },
  },
}
