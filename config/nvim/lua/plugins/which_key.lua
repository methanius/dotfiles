return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "J",     ":m '>+1<CR>gv=gv", desc = "Move selected lines 1 line down",           mode = "v" },
      { "K",     ":m '<-2<CR>gv=gv", desc = "Move selected lines 1 line up",             mode = "v" },

      { "J",     "mzJ`z",            desc = "Append line below to current line",         mode = "n" },
      { "<C-d>", "<C-d>zz",          desc = "Scroll half buffer down and center cursor", mode = "n" },
      { "<C-u>", "<C-u>zz",          desc = "Scroll half buffer up and center cursor",   mode = "n" },
      {
        "n",
        "nzzzv",
        desc = "Next item matching search, including in folds, keeping cursor centered in buffer",
        mode = "n",
      },
      {
        "N",
        "Nzzzv",
        desc = "Prev item matchin search, including in folds, keeping cursor centered in buffer",
        mode = "n",
      },

      -- next greatest remap ever : asbjornHaland
      { "<leader>d", [["_d]], desc = "Delete to void register",                  mode = { "n", "v" } },

      { "Q",         "<nop>", desc = "I will never need Ex mode, so remove it.", mode = "n" },

      {
        "<C-k>",
        "<cmd>cprev<CR>zz",
        desc = "Go to prev item in the quickfix list and center cursor",
        mode = "n",
      },
      {
        "<C-j>",
        "<cmd>cnext<CR>zz",
        desc = "Go to next item in the quickfix list and center cursor",
        mode = "n",
      },
      {
        "<leader><leader>",
        function()
          vim.cmd("so")
        end,
        desc = "Shout out current file",
        mode = "n",
      },
      {
        mode = { "n", "v" },
        { "<leader>f", "find" },
        { "<leader>p", "project" },
        { "<leader>g", "git" },
        { "<leader>t", "toggle" },
        { "<leader>h", "git hunk" },
        { "<leader>n", "neogen" },
        { "<leader>w", proxy = "<c-w>", group = "windows" },
        { "gs",        "",              desc = "+surround" },
      },
    },
  },
}
