return {
  "stevearc/dressing.nvim",
  dependencies = "nvim-telescope/telescope.nvim",
  config = function()
    require("dressing").setup({
      select = {
        telescope = require("telescope.themes").get_cursor(),
      },
    })
  end,
}
