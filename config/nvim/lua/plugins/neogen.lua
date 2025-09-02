return {
  {
    "danymat/neogen",
    lazy=true,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "L3MON4D3/LuaSnip", -- Snippet engine
    },
    opts = {
      snippet_engine = "luasnip",
    },
  },
}
