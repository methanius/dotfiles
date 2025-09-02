return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
    },
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
  },

}
