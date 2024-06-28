return {
  {
    "tpope/vim-fugitive",
    lazy = false,
    keys = {
      {
        "<leader>gs",
        vim.cmd.Git,
        desc = "Toggle Fugitive",
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function ()
      require("gitsigns").setup()
    end
  }
}
