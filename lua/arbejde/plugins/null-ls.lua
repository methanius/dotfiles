return {
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.diagnostics.mypy,
          null_ls.builtins.diagnostics.selene,
        }
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
  },
}
