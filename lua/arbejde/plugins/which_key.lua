return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  -- init = function()
  --   vim.o.timeout = true
  --   vim.o.timeoutlen = 500
  -- end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  config = function()
    local wk = require("which-key")
    wk.setup({
      key_labels = {
        ["<leader>"] = "SPC",
        ["<space>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB",
      },
      window = {
        winblend = 20,
      },
    })
    wk.register({
      mode = { "n", "v" },
      ["g"] = { name = "+goto" },
      ["]"] = { name = "+next" },
      ["["] = { name = "+prev" },
      ["<leader>f"] = { name = "+find" },
      ["<leader>p"] = { name = "+project" },
      ["<leader>g"] = { name = "+git" },
      ["<leader>t"] = { name = "+toggle" },
    })
  end,
}
