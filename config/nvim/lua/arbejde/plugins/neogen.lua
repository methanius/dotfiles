return {
  {
    "danymat/neogen",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "L3MON4D3/LuaSnip", -- Snippet engine
    },
    opts = {
      snippet_engine = "luasnip",
    },
    config = true,
    keys = {
      {
        "<leader>nm",
        mode = "n",
        function()
          require("neogen").generate({ type = "func" })
        end,
        desc = "Neogen function docstring generation",
      },
      {
        "<leader>nc",
        mode = "n",
        function()
          require("neogen").generate({ type = "class" })
        end,
        desc = "Neogen class docstring generation",
      },
      {
        "<leader>nt",
        mode = "n",
        function()
          require("neogen").generate({ type = "type" })
        end,
        desc = "Neogen type docstring generation",
      },
      {
        "<leader>ng",
        mode = "n",
        function()
          require("neogen").generate({})
        end,
        desc = "Neogen docstring generation",
      },
      {
        "<leader>nf",
        mode = "n",
        function()
          require("neogen").generate({ type = "file"})
        end,
        desc = "Neogen file docstring generation",
      },
    },
  },
}
