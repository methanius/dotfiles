return {
  "stevearc/dressing.nvim",
  dependencies = "nvim-telescope/telescope.nvim",
  opts = {
    select = {
      relative = "cursor",
      telescope = require("telescope.themes").get_cursor(),
    }
  },
}
