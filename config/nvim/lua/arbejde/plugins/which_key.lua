vim.keymap.del("n", "grn")
vim.keymap.del({"n", "v"}, "gra")
vim.keymap.del("n", "grr")
return {
  "folke/which-key.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "echasnovski/mini.icons",
  },
  opts = {
    spec = {
      { "J", ":m '>+1<CR>gv=gv", desc = "Move selected lines 1 line down", mode = "v" },
      { "K", ":m '<-2<CR>gv=gv", desc = "Move selected lines 1 line up", mode = "v" },

      { "J", "mzJ`z", desc = "Append line below to current line", mode = "n" },
      { "<C-d>", "<C-d>zz", desc = "Scroll half buffer down and center cursor", mode = "n" },
      { "<C-u>", "<C-u>zz", desc = "Scroll half buffer up and center cursor", mode = "n" },
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
      { "<leader>y", [["+y]], desc = "Yank selection to system register", mode = { "n", "v" } },
      { "<leader>Y", [["+Y]], desc = "Yank line to system register", mode = "n" },
      { "<leader>d", [["_d]], desc = "Delete to void register", mode = { "n", "v" } },

      { "Q", "<nop>", desc = "I will never need Ex mode, so remove it.", mode = "n" },

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
        "<leader>k",
        "<cmd>lnext<CR>zz",
        desc = "Go to next item in the file local quickfist list and center cursor",
        mode = "n",
      },
      {
        "<leader>j",
        "<cmd>lprev<CR>zz",
        desc = "Go to prev item in the file local quickfist list and center cursor",
        mode = "n",
      },

      {
        "<leader>sr",
        [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
        desc = "Regex find replace word under cursor",
        mode = "n",
      },
      {
        "<leader>x",
        "<cmd>!chmod +x %<CR>",
        silent = true,
        desc = "Make current file executable (if on Linux)",
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
      },
    },
  },
}
