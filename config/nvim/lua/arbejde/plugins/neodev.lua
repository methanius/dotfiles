return {
  {
    "folke/neodev.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      library = {
        plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
      },
    }
  },
}
