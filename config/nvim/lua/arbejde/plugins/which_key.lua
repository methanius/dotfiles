return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "echasnovski/mini.icons",
  },
  -- init = function()
  --   vim.o.timeout = true
  --   vim.o.timeoutlen = 500
  -- end,
  opts = {},
  config = function()
    local wk = require("which-key")
    wk.add({
      mode = { "n", "v" },
      { "<leader>f", "find" },
      { "<leader>p", "project" },
      { "<leader>g", "git" },
      { "<leader>t", "toggle" },
      { "<leader>h", "git hunk" },
      { "<leader>n", "neogen" },
      { "<leader>w", proxy = "<c-w>", group = "windows" },
    })
  end,
}
