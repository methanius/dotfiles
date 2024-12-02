return {
  "stevearc/dressing.nvim",
  dependencies = "nvim-telescope/telescope.nvim",
  event = "VeryLazy",
  opts = {
    select = {
      relative = "cursor",
      telescope = require("telescope.themes").get_cursor(),
    }
  },
}
